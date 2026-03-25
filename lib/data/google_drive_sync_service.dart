import 'dart:async';
import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;

import '../models/run_record.dart';

class GoogleDriveSyncService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[drive.DriveApi.driveFileScope],
  );

  Future<void> uploadRuns(List<RunRecord> runs) async {
    final GoogleSignInAccount? account =
        await _googleSignIn.signInSilently() ?? await _googleSignIn.signIn();
    if (account == null) {
      throw Exception('Google sign-in failed.');
    }

    final Map<String, String> authHeaders = await account.authHeaders;
    final _GoogleAuthClient client = _GoogleAuthClient(authHeaders);
    final drive.DriveApi driveApi = drive.DriveApi(client);

    final String content = jsonEncode({
      'updatedAt': DateTime.now().toIso8601String(),
      'runs': runs.map((r) => r.toCloudJson()).toList(),
    });

    final drive.File file = drive.File()
      ..name = 'runner_history_backup.json'
      ..mimeType = 'application/json';

    await driveApi.files.create(
      file,
      uploadMedia: drive.Media(Stream.value(utf8.encode(content)), content.length),
    );

    client.close();
  }
}

class _GoogleAuthClient extends http.BaseClient {
  _GoogleAuthClient(this._headers);

  final Map<String, String> _headers;
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _inner.send(request);
  }

  @override
  void close() {
    _inner.close();
  }
}
