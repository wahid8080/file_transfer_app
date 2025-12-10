import 'dart:isolate';
import 'dart:ui';

import 'package:file_transfer_app/floating_window.dart';
import 'package:flutter/material.dart';
import 'package:file_transfer_module/file_transfer_module.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String token = "eyJraWQiOiI0IiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiJhYmlyIiwiYXVkIjoiY2xpZW50IiwiY29tcGFueUlkIjoyLCJuYmYiOjE3NjUzMjQzODcsInNjb3BlIjpbInByb2ZpbGUiXSwiaXNzIjoiaHR0cDovLzU0LjI0MS4yMDAuMTcyOjg4MDEvYXV0aC13cyIsImlkIjo0LCJyb2xlQWNjZXNzIjoiQWRtaW4iLCJleHAiOjE3NjUzMzE1ODcsImlhdCI6MTc2NTMyNDM4NywianRpIjoiMGJmMjRiNWQtNDc5NS00MTYyLWEwNmYtZmQzNDI4ZTE4NGNmIiwiYXV0aG9yaXRpZXMiOlsiQWRtaW4iXX0.CpxRIeW9BDsvFTWSMFQPLtiDQpciIrQDY8P3nopgRlumwtFxpK2x8bOp2kHJzrxuEDi6VyvMNBzg0l9e02TDO91CQoNtpEzECeT17dYhG-cTXV-pJrGGvkJRY0hTAOPyb-znQel41Mnq53JX1BxkKbD7NTl5um6K6mePKkF60PzGf5js-v8RPPSWcRwVYnV4lNO6aSIzTp3bvlr-au_Dq8OU7jUOpGSQPPgot1BphOWRise1ct4qst-E7nN3cHPI2AiPNBzgfIukWaLELinNiczGK1dcp0SmQ5yJ2jd0pJWfclKjZf0HE8A0cHyusKa_nZhjSglgs3Y8jzOmN_8BLA";



    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'My App',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/upload':
            return MaterialPageRoute(
              builder: (context) => FileTransferModuleProviders(
                child: FileUploadScreen(
                  token: token,
                ),
              ),
            );
          case '/download':
            return MaterialPageRoute(
              builder: (context) => FileTransferModuleProviders(
                child: FileDownloadScreen(
                  token: token,
                ),
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const HomePage(),
            );
        }
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final receivePort = ReceivePort();
  OverlayEntry? _overlayEntry;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _setupIsolateListener();


  }

  void _showGlobalOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => FloatingDownloadWidget(
        isExpanded: _isExpanded,
        onToggle: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
          _overlayEntry?.markNeedsBuild();
        },
      ),
    );

    navigatorKey.currentState?.overlay?.insert(_overlayEntry!);
  }

  void _setupIsolateListener() {


    IsolateNameServer.registerPortWithName(receivePort.sendPort, 'upload_stream');

    receivePort.listen((message) {
      if (message is Map) {
        final progress = message["progress"] as int? ?? 0;
        final status = message["status"] as bool? ?? false;
        UploadProgressService.instance?.updateProgress(progress: progress);

        if(progress>0){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showGlobalOverlay();
          });
        }
      }
    });
  }

  @override
  void dispose() {
    receivePort.close();
    IsolateNameServer.removePortNameMapping('upload_stream');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My App')),
      body: StreamBuilder<UploadProgressModel>(
        stream: UploadProgressService.instance?.progressStream,
        initialData: UploadProgressService.instance?.currentProgress,
        builder: (context, snapshot) {
          final progress = snapshot.data?.progress ?? 0;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Upload Progress: $progress%',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                LinearProgressIndicator(
                  value: progress / 100.0,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.blue,
                  ),
                ),
                SizedBox(height: 100),
                ElevatedButton(
                  onPressed: () {
                    print("Current progress: ${snapshot.data?.progress}");
                  },
                  child: const Text('Get Data'),
                ),
                SizedBox(height: 100),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/upload'),
                  child: const Text('Upload File'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/download'),
                  child: const Text('Download File'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}