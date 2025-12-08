import 'package:flutter/material.dart';
import 'package:file_transfer_module/file_transfer_module.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String token = "eyJraWQiOiI0IiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiJhYmlyIiwiYXVkIjoiY2xpZW50IiwiY29tcGFueUlkIjoyLCJuYmYiOjE3NjUyMTMwMDIsInNjb3BlIjpbInByb2ZpbGUiXSwiaXNzIjoiaHR0cDovLzU0LjI0MS4yMDAuMTcyOjg4MDEvYXV0aC13cyIsImlkIjo0LCJyb2xlQWNjZXNzIjoiQWRtaW4iLCJleHAiOjE3NjUyMjAyMDIsImlhdCI6MTc2NTIxMzAwMiwianRpIjoiYzY4ZTZmOTEtNWY4ZC00ZTc5LWJjMzAtZjJhZTBhNTVmOGRkIiwiYXV0aG9yaXRpZXMiOlsiQWRtaW4iXX0.BJjz7Sjb8vtvWeUvdWlyzkl-nN3JUDj_W7SbbwCUHOSVnWB2dGSIpnR5s0__DU9s1xqafCz17CcNNF2rdiYpkcoDIebxW-QggwZN12tOJc0ms8duK8_D1OwSoDpnUUnsLYngBzcR4cO3Wiu11PI8WAnP-c2G8WefrcTLgEvbcp7NpXaVbu2RYW_7c5qq5fU4nsyhUw-rU1s8v1QX6STnqwDspkGmkWY66JS6XKIZv3uF-44vO0Oq_Ygd45ynYwvt01Xeja7a9mxpxIUwZaaCymFcGh740aWzN2Jkz-x1ZMhBd7nLhKpsJl764EUEV5u8cJjMQ2JJ_WwEJ8SAW_fgqg";

    return MaterialApp(
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

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
      ),
    );
  }
}