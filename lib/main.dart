import 'package:flutter/material.dart';
import 'package:gera_client/src/download_episode.dart';
import 'package:gera_client/src/get_episode_info.dart';


void main() {
  // runApp(MainApp());
  downloadEpisode(221);
  getEpisodeInfo(221).then((value) => print(value));
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello, World!'),
        ),
      ),
    );
  }
}
