import 'package:gera_client/src/get_episode_info.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' show parse;
import 'dart:io';
import 'package:gera_client/env/env.dart';
import 'package:gera_client/src/manage_path.dart';


Future<String> getEpisodeUrl(int episodeNumber) async {
  final String apiKey = Env.apiKey;
  final String customSearchEngineId = Env.engineId;
  final String query = 'sn@gera.fan ${episodeNumber.toString()}';
  final String url = 'https://www.googleapis.com/customsearch/v1?key=${apiKey}&cx=${customSearchEngineId}&q=${query}';
  final http.Response response = await http.get(Uri.parse(url));
  final Map<String, dynamic> responseJson = jsonDecode(response.body);

  final List<String> urls = responseJson['items'].map<String>((dynamic item) => item['link'] as String).toList();
  final String resultUrl = urls.first;

  return resultUrl;
}

Future<String> getAudioUrl(String url) async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var htmlDocument = parse(response.body);

    Element? audioElement = htmlDocument.querySelector('audio');

    String audioUrl = audioElement?.attributes['src'] ?? '';
    
    return audioUrl;

  } else {
    throw Exception('Failed to load audio');
  }
}

/// downloadPath must be a full path including the file name
Future<void> downloadAudio(String url, String downloadPath) async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final file = File(downloadPath);
    await file.writeAsBytes(response.bodyBytes);
  } else {
    throw Exception('Failed to download audio');
  }
}

// これまでの関数を使って、一連の処理を行う関数
Future<void> downloadEpisode(int episodeNumber) async {
  final String baseDirectory = await getBaseDirectory();
  if (baseDirectory == '') {
    throw Exception('Base directory is not set');
  }

  final String episodeUrl = await getEpisodeUrl(episodeNumber);
  final String audioUrl = await getAudioUrl(episodeUrl);
  final String seriesName = await getEpisodeInfo(episodeNumber);
  final String downloadPath = await getDownloadPath(seriesName, episodeNumber);
  await downloadAudio(audioUrl, downloadPath);
}

// 指定された範囲のエピソードをダウンロードする関数
Future<void> downloadEpisodes(int start, int end) async {
  for (int i = start; i <= end; i++) {
    await downloadEpisode(i);
  }
}