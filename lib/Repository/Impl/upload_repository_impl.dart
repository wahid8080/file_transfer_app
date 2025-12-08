import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_transfer_module/Network/network_service.dart';
import '../Repo/upload_repository.dart';

class UploadRepositoryImpl implements UploadRepository {

  final NetworkService _networkService = NetworkService();

  @override
  Future<String> uploadFile({required PlatformFile file, required Function(double) onProgress}) async {

    try {
      List<Map<String, dynamic>> jsonPatchArray = [
        {
          "op": "replace",
          "path": "/updateBy",
          "value": 123
        }
      ];
      String jsonPatchString = jsonEncode(jsonPatchArray);

      Map<String, dynamic> jsonPatch = {
        'jsonPatch': jsonPatchString,
      };

      File fileToUpload = File(file.path!);
      final response = await _networkService.uploadFile(fileToUpload, parameters: jsonPatch, onSendProgress: (sent, total) {
          if (total != -1) {
            final progress = (sent / total);
            onProgress(progress);
          }
        });

      if (response.statusCode == 200 || response.statusCode == 201) {
        return 'File uploaded successfully';
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Upload failed: $e');
    }
  }
}