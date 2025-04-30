import 'package:json_annotation/json_annotation.dart';

part 'book_metadata.g.dart';

@JsonSerializable(explicitToJson: true)
class ChapterMetadata {
  final String id;
  final String title;

  @JsonKey(name: 'cover_portrait')
  final String coverPortrait;

  @JsonKey(name: 'cover_landscape')
  final String coverLandscape;

  @JsonKey(name: 'pdf_portrait')
  final String pdfPortrait;

  @JsonKey(name: 'pdf_landscape')
  final String pdfLandscape;

  final AudioMetadata audio;
  final int pages;

  @JsonKey(ignore: true)
  late String basePath;

  ChapterMetadata({
    required this.id,
    required this.title,
    required this.coverPortrait,
    required this.coverLandscape,
    required this.pdfPortrait,
    required this.pdfLandscape,
    required this.audio,
    required this.pages,
  });

  factory ChapterMetadata.fromJson(Map<String, dynamic> json) =>
      _$ChapterMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$ChapterMetadataToJson(this);

  String getCover({bool portrait = true}) =>
      '$basePath/${portrait ? coverPortrait : coverLandscape}';
}

@JsonSerializable()
class AudioMetadata {
  final String male;
  final String female;

  AudioMetadata({required this.male, required this.female});

  factory AudioMetadata.fromJson(Map<String, dynamic> json) =>
      _$AudioMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$AudioMetadataToJson(this);
}
