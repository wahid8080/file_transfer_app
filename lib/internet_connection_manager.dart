

import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class InternetConnectionManager {
  static Future<NetworkState> getNetworkStatus() async {

    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return NetworkState.none;
    }

    final url = Uri.parse('https://www.google.com/favicon.ico');
    final stopwatch = Stopwatch()..start();

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));
      stopwatch.stop();

      if (response.statusCode == 200) {
        final timeTaken = stopwatch.elapsedMilliseconds / 1000;
        final totalKB = response.contentLength! / 1024;
        final speedKBps = totalKB / timeTaken;

        print("Total content: ${totalKB} KB");
        print("Total time: ${timeTaken} sec");
        print("Speed: ${speedKBps} KB/sec");

        if (speedKBps < 5) {
          return NetworkState.low;
        } else if (speedKBps < 50) {
          return NetworkState.normal;
        } else {
          return NetworkState.heigh;
        }

      } else {
        return NetworkState.low;
      }
    } on TimeoutException {
      return NetworkState.low;
    } on SocketException {
      return NetworkState.none;
    }
  }
}

enum NetworkState{
  heigh,
  low,
  normal,
  none,
}
