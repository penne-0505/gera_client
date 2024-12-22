import 'dart:convert';
import 'package:gera_client/model/episode_info.dart';
import 'package:gera_client/src/download_episode.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'dart:io';


Future<String> downloadThumbnail(String url, String downloadPath) async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final File file = File(downloadPath);
    await file.writeAsBytes(response.bodyBytes);
    return downloadPath;
  } else {
    throw Exception('Failed to download thumbnail');
  }
}

Future<String> getEpisodeInfo(int episodeNumber) async {
  final String episodeUrl = await getEpisodeUrl(episodeNumber);
  final http.Response response = await http.get(Uri.parse(episodeUrl));
  final Document htmlDocument = parse(response.body);
  final String rawTitle = htmlDocument.querySelector('meta[property="og:title"]')?.attributes['content'] ?? '';
  final String title = rawTitle.split(' ')[1];
  final String description = htmlDocument.querySelector('meta[property="og:description"]')?.attributes['content'] ?? '';
  final String thumbnailUrl = htmlDocument.querySelector('meta[property="og:image"]')?.attributes['content'] ?? '';
  const String thumbnailPath = 'C:/Users/penne/Downloads/thumbnail.jpg'; // シンボルの保存先(運用時は、固定pathに$seriesName + thumbnail.jpgとして保存する)
  await downloadThumbnail(thumbnailUrl, thumbnailPath);
  final String audioUrl = await getAudioUrl(episodeUrl);


  final EpisodeInfo episodeInfo = EpisodeInfo(
    title: title,
    description: description,
    episodeNumber: episodeNumber,
    audioUrl: audioUrl,
    downloadPath: 'C:/Users/penne/Downloads/audio.mp3',
    thumbnailPath: thumbnailPath,
  );

  final result = jsonEncode(episodeInfo.toJson());
  return result;
}
