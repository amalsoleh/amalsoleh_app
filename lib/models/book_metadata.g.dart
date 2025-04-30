// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChapterMetadata _$ChapterMetadataFromJson(Map<String, dynamic> json) =>
    ChapterMetadata(
      id: json['id'] as String,
      title: json['title'] as String,
      coverPortrait: json['cover_portrait'] as String,
      coverLandscape: json['cover_landscape'] as String,
      pdfPortrait: json['pdf_portrait'] as String,
      pdfLandscape: json['pdf_landscape'] as String,
      audio: AudioMetadata.fromJson(json['audio'] as Map<String, dynamic>),
      pages: (json['pages'] as num).toInt(),
    );

Map<String, dynamic> _$ChapterMetadataToJson(ChapterMetadata instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'cover_portrait': instance.coverPortrait,
      'cover_landscape': instance.coverLandscape,
      'pdf_portrait': instance.pdfPortrait,
      'pdf_landscape': instance.pdfLandscape,
      'audio': instance.audio.toJson(),
      'pages': instance.pages,
    };

AudioMetadata _$AudioMetadataFromJson(Map<String, dynamic> json) =>
    AudioMetadata(
      male: json['male'] as String,
      female: json['female'] as String,
    );

Map<String, dynamic> _$AudioMetadataToJson(AudioMetadata instance) =>
    <String, dynamic>{'male': instance.male, 'female': instance.female};
