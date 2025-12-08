import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../Repo/download_repository.dart';

class DownloadRepositoryImpl implements DownloadRepository {

  @override
  Future<String> downloadFile({required String downloadUrl, required String fileName, required Function(double) onProgress}) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';


      return filePath;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Download failed: ${e.response?.data}');
      } else {
        throw Exception('Download failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Download failed: $e');
    }
  }
}