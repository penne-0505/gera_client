class EpisodeInfo {
  final String title;
  final String description;
  final int? episodeLengthSeconds;
  final int episodeNumber;
  final String audioUrl;
  final String downloadPath;
  final int? downloadStatus;
  final String thumbnailPath;

  EpisodeInfo({
    required this.title,
    required this.description,
    this.episodeLengthSeconds, // 再生が始まったときに取得する
    required this.episodeNumber,
    required this.audioUrl,
    required this.downloadPath,
    this.downloadStatus,
    required this.thumbnailPath,
  });

  @override
  String toString() {
    return 'EpisodeInfo(title: $title, description: $description, episodeLengthSeconds: $episodeLengthSeconds, episodeNumber: $episodeNumber, audioUrl: $audioUrl, downloadPath: $downloadPath, downloadStatus: $downloadStatus, thumbnailPath: $thumbnailPath)';
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'episodeLengthSeconds': episodeLengthSeconds,
      'episodeNumber': episodeNumber,
      'audioUrl': audioUrl,
      'downloadPath': downloadPath,
      'downloadStatus': downloadStatus,
      'thumbnailPath': thumbnailPath,
    };
  }
}
