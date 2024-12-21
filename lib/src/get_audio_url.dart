import 'package:http/http.dart' as http;
import 'dart:convert';


Future<String> getAudioUrl() async {
  const String apiKey = 'AIzaSyCeQ_6bUYzKVMSgckMmSpTcsIFK6WaWaHM';
  const String customSearchEngineId = '9797ea352430a41cd';
  const String query = 'sn@gera.fan';
  const String url = 'https://www.googleapis.com/customsearch/v1?key=${apiKey}&cx=${customSearchEngineId}&q=${query}';
  final http.Response response = await http.get(Uri.parse(url));
  final Map<String, dynamic> responseJson = jsonDecode(response.body);

  final List<String> urls = responseJson['items'].map<String>((dynamic item) => item['link'] as String).toList();

  print(urls);

  return urls.first;
}

// ここから(これは動かないと思う)
// 次やること：保存したいファイルのURLを取得する
// 保存したいファイルのURLを取得したら、そのファイルを保存する
// 保存したファイルのパスをDBに保存する
Future<void> saveAudios(List<String> urls) async {
  for (final String url in urls) {
    final http.Response response = await http.get(Uri.parse(url));
    final String fileName = url.split('/').last;
    final String path = 'audios/$fileName';
    final File file = File(path);
    await file.writeAsBytes(response.bodyBytes);
  }
}