


import 'package:file_transfer_app/internet_connection_manager.dart';
import 'package:file_transfer_module/file_transfer_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget ConnectionStateWidget(NetworkState state) {
  switch (state) {
    case NetworkState.none:
      return Text("No Network Access", style: TextStyle(color: Colors.red),);
    case NetworkState.low:
      return Text("Low Network Access", style: TextStyle(color: Colors.yellow),);
    case NetworkState.normal:
      return Text("Normal Network Access", style: TextStyle(color: Colors.yellowAccent),);
    case NetworkState.heigh:
      return Text("High Network Access", style: TextStyle(color: Colors.blue),);
  }
}
