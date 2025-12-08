abstract class DownloadRepository {
  Future<String> downloadFile({
    required String downloadUrl,
    required String fileName,
    required Function(double) onProgress,
  });
}