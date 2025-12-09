import 'package:flutter/material.dart';
import 'package:file_transfer_module/file_transfer_module.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String token = "eyJraWQiOiI0IiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiJhYmlyIiwiYXVkIjoiY2xpZW50IiwiY29tcGFueUlkIjoyLCJuYmYiOjE3NjUyNjE5ODgsInNjb3BlIjpbInByb2ZpbGUiXSwiaXNzIjoiaHR0cDovLzU0LjI0MS4yMDAuMTcyOjg4MDEvYXV0aC13cyIsImlkIjo0LCJyb2xlQWNjZXNzIjoiQWRtaW4iLCJleHAiOjE3NjUyNjkxODgsImlhdCI6MTc2NTI2MTk4OCwianRpIjoiZjZiMDU4MjYtMTQ2Mi00ZGI2LTk5NzEtNzg3MzZmZDhiMGExIiwiYXV0aG9yaXRpZXMiOlsiQWRtaW4iXX0.pSGKoPNpKIGw-PCuNOTgqy72lUIqpUMWtT9_qTdOE76tYdJZ9nx2GA0zDV5Ra6lNxjN7kVhQyqUx6nYmrloZT7gOxUKGNE4BGYR9VO9BaYxeTdFUtzQxi9YXDCtQTl0vaeQjU1TF9oZ1BfTAFD0iS5z4PkDx48pTOCWEJSyLKrv5WC3zh_dvBvUObs5B3Q2JCnNLg4mNRR1h7vj47nxX80bGb2Z3HmfEMUZ_Jvn98AtgLDw8DsAy48lIYFSecPf3-Hh-Mu2h3f4BYmQgnjonKaa8fWd5tx-GkxTRmY-mh8bVzFtUUesM9MTeEGbYswUN2x-cVGEhWUdtD4hfQpl3wQ";

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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My App')),
      body: StreamBuilder<UploadProgressModel>(
        stream: UploadProgressService().progressStream,
        initialData: UploadProgressService().currentProgress,
        builder: (context, snapshot) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LinearProgressIndicator(
                  value: snapshot.data!.progress / 100.0,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.blue,
                  ),
                ),
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