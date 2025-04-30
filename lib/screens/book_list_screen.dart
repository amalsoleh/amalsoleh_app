import 'package:flutter/material.dart';
import '../models/book_metadata.dart';
import '../services/book_service.dart';
import '../widgets/book_list.dart';  // ← make sure this is here

/// The “home” screen that actually fetches your JSON and displays two BookList rows.
class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  late final Future<List<ChapterMetadata>> _chaptersFuture;

  @override
  void initState() {
    super.initState();
    _chaptersFuture = BookService().loadChapters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Image.asset('assets/logo_ui.png', height: 36),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<ChapterMetadata>>(
        future: _chaptersFuture,
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || (snap.data?.isEmpty ?? true)) {
            return const Center(child: Text('No books found.'));
          }

          final chapters = snap.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BookList(title: 'New Arrivals', chapters: chapters),
                BookList(title: 'Most Read',     chapters: chapters),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
