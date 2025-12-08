import 'package:file_picker/file_picker.dart';

abstract class UploadRepository {
  Future<String> uploadFile({required PlatformFile file, required Function(double) onProgress});
}