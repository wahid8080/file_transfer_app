import 'package:file_transfer_app/connection_state.dart';
import 'package:file_transfer_app/internet_connection_manager.dart';
import 'package:file_transfer_module/file_transfer_module.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


class FloatingDownloadWidget extends StatefulWidget {
  const FloatingDownloadWidget({super.key});

  @override
  State<FloatingDownloadWidget> createState() => _FloatingDownloadWidgetState();
}

class _FloatingDownloadWidgetState extends State<FloatingDownloadWidget> {

  NetworkState networkState = NetworkState.none;

  @override
  void initState() {
    initNetworkListener();
    super.initState();
  }

  void initNetworkListener() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) async {
      final status = await InternetConnectionManager.getNetworkStatus();
      if (!mounted) return;
      setState(() {
        networkState = status;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100,
      right: 20,
      left: 20,
      child: StreamBuilder<UploadProgressModel>(
        stream: BroadcastProcessingService.instance?.getUploadStream(),
        initialData: BroadcastProcessingService.instance?.getInitialProgressModel(),
        builder: (context, snapshot) {
          final progress = snapshot.data?.progress ?? 0;

          return Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(5),
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConnectionStateWidget(networkState),
                  Text('${snapshot.data!.streamStatus==1 ? "Download": "Upload"} Progress: $progress%',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: 16),),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}