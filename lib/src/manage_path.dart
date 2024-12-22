import 'dart:io';


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