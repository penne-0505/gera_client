import 'package:audioplayers/audioplayers.dart';


class EpisodePlayer {
  final AudioPlayer _audioPlayer = AudioPlayer();

  void play(String filePath) {
    _audioPlayer.play(filePath, isLocal: true);
  }

  void dispose() {
    _audioPlayer.dispose(); 
  }
}
