import 'package:flutter/material.dart';
import 'package:gera_client/src/get_audio_url.dart';


void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final Future<String> responseJson = getAudioUrl();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FutureBuilder<String>(
            future: responseJson,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text('Error: ${snapshot.error}');
              } else {
                print(snapshot.data);
                return Text(snapshot.data ?? 'No data');
              }
            },
          ),
        ),
      ),
    );
  }
}
