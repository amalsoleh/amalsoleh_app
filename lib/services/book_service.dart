import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/book_metadata.dart';

/// Service for loading and managing book metadata
class BookService {
  /// Load all chapters from assets/meta.json
  Future<List<ChapterMetadata>> loadChapters() async {
    try {
      // 1) Load the raw JSON text
      final jsonStr = await rootBundle.loadString('assets/meta.json');
      print('📦 Loaded meta.json: $jsonStr');

      // 2) Decode it into a List<dynamic>
      final List<dynamic> decoded = json.decode(jsonStr) as List<dynamic>;

      // 3) Map each entry to ChapterMetadata
      final chapters = decoded.map<ChapterMetadata>((item) {
        final map = item as Map<String, dynamic>;
        final chap = ChapterMetadata.fromJson(map);
        chap.basePath = 'assets/books/${chap.id}';
        return chap;
      }).toList();

      print('✅ Parsed chapter IDs: ${chapters.map((c) => c.id).toList()}');
      return chapters;
    } catch (e, stack) {
      // 4) On any error, log and return empty
      print('⚠️ Error loading chapters: $e');
      print(stack);
      return <ChapterMetadata>[];
    }
  }
}
