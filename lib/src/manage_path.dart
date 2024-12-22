import 'dart:io';
import 'package:gera_client/env/env.dart';
import 'dart:convert';


/*
現状のディレクトリ構成想定図：

- (base directory)
  - downloading
   - audio.mp3 <- ダウンロード中もしくはストリーミング中の音声ファイル
  - serieses
    - (series name)
      - episodes
        - thumbnail.jpg <- シンボルはエピソードを通して共有されるため、シリーズごとに保存される
        - (episode number)
          - audio.mp3
*/


/// The path must not include a file name
Future<void> setBaseDirectory(String path) async {
  final Directory directory = Directory(path);
  if (!await directory.exists()) {
    await directory.create();
  }
  Directory.current = path;

  final File configFile = File(Env.cfgPath);
  final Map<String, String> configData = {'baseDirectory': path};
  final String jsonConfig = jsonEncode(configData);

  if (!await configFile.exists()) {
    await configFile.create();
    await configFile.writeAsString(jsonConfig);
  } else {
    await configFile.writeAsString(jsonConfig);
  }

  final Directory downloadingDirectory = Directory('downloading');
  if (!await downloadingDirectory.exists()) {
    await downloadingDirectory.create();
  }

  final Directory seriesesDirectory = Directory('serieses');
  if (!await seriesesDirectory.exists()) {
    await seriesesDirectory.create();
  }
}

Future<String> getBaseDirectory() async {
  return Directory.current.path;
}

Future<void> createSeriesDirectory(String seriesName) async {
  final Directory seriesDirectory = Directory('serieses/$seriesName');
  if (!await seriesDirectory.exists()) {
    await seriesDirectory.create(recursive: true);
  }

  final Directory episodesDirectory = Directory('serieses/$seriesName/episodes');
  if (!await episodesDirectory.exists()) {
    await episodesDirectory.create(recursive: true);
  }
}

Future<String> getDownloadPath(String seriesName, int episodeNumber) async {
  final String episodeNumberString = episodeNumber.toString();
  final String downloadPath = 'serieses/$seriesName/episodes/$episodeNumberString/audio.mp3';
  return downloadPath;
}

Future<String> getThumbnailPath(String seriesName, int episodeNumber) async {
  final String episodeNumberString = episodeNumber.toString();
  final String thumbnailPath = 'serieses/$seriesName/episodes/$episodeNumberString/thumbnail.jpg';
  return thumbnailPath;
}