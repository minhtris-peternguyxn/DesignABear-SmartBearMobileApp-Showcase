class SongModel {
  final String id;
  final String name;
  final String? audioUrl;
  final String? gcsPath;
  final String? artist;
  final String? duration;

  SongModel({
    required this.id,
    required this.name,
    this.audioUrl,
    this.gcsPath,
    this.artist,
    this.duration,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['id']?.toString() ?? json['Id']?.toString() ?? '',
      name: json['name'] ?? json['Name'] ?? 'Không tên',
      audioUrl: json['audioUrl'] ?? json['AudioUrl'],
      gcsPath: json['gcsPath'] ?? json['GcsPath'],
      artist: json['artist'] ?? json['Artist'],
      duration: json['duration']?.toString() ?? json['Duration']?.toString(),
    );
  }
}
