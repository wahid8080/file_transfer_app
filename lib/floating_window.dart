import 'package:file_transfer_module/file_transfer_module.dart';
import 'package:flutter/material.dart';

class FloatingDownloadWidget extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;

  const FloatingDownloadWidget({super.key, required this.isExpanded, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80,
      right: 20,
      left: 20,
      child: StreamBuilder<UploadProgressModel>(
        stream: UploadProgressService.instance?.progressStream,
        initialData: UploadProgressService.instance?.currentProgress,
        builder: (context, snapshot) {
          final progress = snapshot.data?.progress ?? 0;

          return Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text( 'Upload Progress: $progress%',),
            ),
          );
        },
      ),
    );
  }
}