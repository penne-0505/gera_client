import 'dart:convert';
import 'package:gera_client/model/episode_info.dart';
import 'package:gera_client/src/download_episode.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:gera_client/src/manage_path.dart';


/// downloadPath must be a full path including the file name
Future<String> downloadThumbnail(String url, String downloadPath) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final File file = File(downloadPath);
      if (!await file.exists()) {
        await file.create(recursive: true);
        await file.writeAsBytes(response.bodyBytes);
      }
      return downloadPath;
    } else {
      throw Exception('Failed to download thumbnail');
    }
  } catch (e) {
    throw Exception('Error downloading thumbnail: $e');
  }
}

Future<EpisodeInfo?> getEpisodeInfo(int episodeNumber) async {
  // エピソードのURLを取得
  final String episodeUrl = await getEpisodeUrl(episodeNumber);

  if (episodeUrl == '') {
    return null;
  }

  // エピソードのDOMを取得
  final http.Response response = await http.get(Uri.parse(episodeUrl));
  final Document htmlDocument = parse(response.body);

  // エピソードのタイトルと説明を取得
  final String rawTitle = htmlDocument.querySelector('meta[property="og:title"]')?.attributes['content'] ?? '';
  final String title = rawTitle.split(' ')[1];
  final String description = htmlDocument.querySelector('meta[property="og:description"]')?.attributes['content'] ?? '';

  // シリーズの名前を取得
  final scriptTags = htmlDocument.getElementsByTagName('script');
  String seriesName = '';
  for (var script in scriptTags) {
    final regex = RegExp(r'const chName = "(.*?)";'); // ちなみに、geraのページのscriptタグ内にはfirebaseのapiKeyが平文で書かれていて、やばい
    final match = regex.firstMatch(script.text);
    if (match != null) {
      seriesName = match.group(1) ?? '';
      break;
    }
  }
  
  // エピソードのシンボルを取得
  final String thumbnailUrl = htmlDocument.querySelector('meta[property="og:image"]')?.attributes['content'] ?? '';
  final String thumbnailPath = await getThumbnailPath(seriesName);
  await downloadThumbnail(thumbnailUrl, thumbnailPath);
  
  // エピソードの音声ファイルURLを取得
  final String audioUrl = await getAudioUrl(episodeUrl);

  // エピソードのダウンロード先を取得
  final String downloadPath = await getDownloadPath(seriesName, episodeNumber);


  final EpisodeInfo episodeInfo = EpisodeInfo(
    title: title,
    description: description,
    seriesName: seriesName,
    episodeNumber: episodeNumber,
    audioUrl: audioUrl,
    downloadPath: downloadPath,
    thumbnailPath: thumbnailPath,
  );

  final EpisodeInfo result = episodeInfo;
  return result;
}

// エラーが出るまでエピソードの情報を取得していく関数、エラーが出たら、エラーが出るまでのエピソードの情報を返す
Future<List<EpisodeInfo>> getEpisodeInfos() async {
  final List<EpisodeInfo> episodeInfos = [];
  int i = 1;
  try {
    while (true) {
      print('current episode number: $i');
      final EpisodeInfo? episodeInfo = await getEpisodeInfo(i);
      if (episodeInfo == null || i < episodeInfos.length) {
        break; // エピソードが存在しないか、すでに取得済みのエピソードの情報を取得しようとした場合、取得を終了する
      }
      episodeInfos.add(episodeInfo);
      i++;
    }
  } catch (e, stackTrace) {
    print('Error: $e');
    print('Stack trace: $stackTrace');
    return episodeInfos;
  }
  return episodeInfos;
}
  // jsonエンコードされたエピソード情報のリストを返す
  /* 例
  [
    {
      "title": "面白かったから上の方",
      "description": "【高校時代のニシダ】\nスクールカースト：上の方(自称)\n理由：面白かったから。面白ツッコミ・面白ボケをしていた。\nメールは「sn@gera.fan」まで！",
      "episodeLengthSeconds": null,
      "episodeNumber": 222,
      "audioUrl": "https://prd.gera-storage.com/episode-audios%2FuzETWEH7K19xLjHcyeYN%2F1713509211185_37d87763-5332-4866-a27a-fdf1f39a643c.mp3",
      "downloadPath": "C:/Users/penne/Downloads/audio.mp3",
      "downloadStatus": null,
      "thumbnailPath": "C:/Users/penne/Downloads/thumbnail.jpg"
    }
    ...
  ]
  */
