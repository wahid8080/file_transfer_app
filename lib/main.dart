import 'package:flutter/material.dart';
import 'package:file_transfer_module/file_transfer_module.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String token = "Bearer eyJraWQiOiI0IiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiJhYmlyIiwiYXVkIjoiY2xpZW50IiwiY29tcGFueUlkIjoyLCJuYmYiOjE3NjUwNDM4MDksInNjb3BlIjpbInByb2ZpbGUiXSwiaXNzIjoiaHR0cDovLzU0LjI0MS4yMDAuMTcyOjg4MDEvYXV0aC13cyIsImlkIjo0LCJyb2xlQWNjZXNzIjoiQWRtaW4iLCJleHAiOjE3NjUwNTEwMDksImlhdCI6MTc2NTA0MzgwOSwianRpIjoiMWIxMzA4YTYtZTAxOS00YTJhLTgyYjYtNGU4NTRmMTc4Y2Y0IiwiYXV0aG9yaXRpZXMiOlsiQWRtaW4iXX0.eVjgAWQUhgVcCqJhpPm2lAF0t6BwjBsjwSoF7SWvRUkztrcnLZDdRTM11Yg6bEGgP9WlDFwrTY1IVOgFnk7nMc8yLmq3Q3khVBuqrTG0wJ-DErIM-nNWBrDDSfhgq3laNOKUhW7W9Jhxo3QklHix8wBei0kW_uiCP6tO3nH7yIVw2YAPwTwLl3m8U8HxFZds4CO15pBJi2ejipNU7c9wFDrHkUkEVk_flA54V640xpS3ptphcVcKYWhshzd1DRZ7x6IfbQQucKC-qKsD1s6atUq9Xi_idAtqd1xudz94_uZ9CNIyemmeTvQXZIYDlmwYm3c12lRVSpQPRNKp5-yupQ";

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