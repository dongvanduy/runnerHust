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
    try {
      final GoogleSignInAccount? account =
          await _googleSignIn.signInSilently() ?? await _googleSignIn.signIn();
      if (account == null) {
        throw const GoogleDriveSyncException(
          'Không thể đăng nhập Google. Hãy kiểm tra SHA-1/OAuth client trên Google Cloud.',
        );
      }

      final Map<String, String> authHeaders = await account.authHeaders;
      final _GoogleAuthClient client = _GoogleAuthClient(authHeaders);
      try {
        final drive.DriveApi driveApi = drive.DriveApi(client);

        final String content = jsonEncode({
          'updatedAt': DateTime.now().toIso8601String(),
          'runs': runs.map((r) => r.toCloudJson()).toList(),
        });

        final List<int> bytes = utf8.encode(content);
        final drive.File file = drive.File()
          ..name = 'runner_history_backup.json'
          ..mimeType = 'application/json';

        final drive.FileList existed = await driveApi.files.list(
          q: "name='runner_history_backup.json' and trashed=false",
          spaces: 'drive',
          $fields: 'files(id,name)',
        );

        if (existed.files != null && existed.files!.isNotEmpty) {
          await driveApi.files.update(
            file,
            existed.files!.first.id!,
            uploadMedia: drive.Media(Stream.value(bytes), bytes.length),
          );
        } else {
          await driveApi.files.create(
            file,
            uploadMedia: drive.Media(Stream.value(bytes), bytes.length),
          );
        }
      } finally {
        client.close();
      }
    } on GoogleDriveSyncException {
      rethrow;
    } catch (e) {
      throw GoogleDriveSyncException('Đồng bộ Google Drive thất bại: $e');
    }
  }
}

class GoogleDriveSyncException implements Exception {
  const GoogleDriveSyncException(this.message);

  final String message;

  @override
  String toString() => message;
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
