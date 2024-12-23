import 'package:flutter/material.dart';
import 'package:gera_client/src/download_episode.dart';
import 'package:gera_client/src/get_episode_info.dart';
import 'package:gera_client/model/episode_info.dart';
import 'package:gera_client/src/manage_path.dart';
import 'package:gera_client/env/env.dart';
import 'package:gera_client/src/play_episode.dart';


void main() {
  // runApp(MainApp());
  getEpisodeInfos().then((e) => print(e));
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List<EpisodeInfo> episodeInfos = [];


  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    episodeInfos = await getEpisodeInfos();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  await downloadEpisodes(1, episodeInfos.length + 1);
                },
                child: Text('Download all episodes'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: episodeInfos.length,
                  itemBuilder: (context, index) {
                    final episodeInfo = episodeInfos[index];
                    return ListTile(
                      title: Text(episodeInfo.title),
                      subtitle: Text(episodeInfo.episodeNumber.toString()),
                      onTap: () async {
                        final episodePlayer = EpisodePlayer();
                        episodePlayer.play(episodeInfo.downloadPath);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
