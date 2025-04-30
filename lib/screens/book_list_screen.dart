import 'package:flutter/material.dart';
import '../services/book_service.dart';
import '../widgets/book_list.dart';
import '../models/book_metadata.dart';

const _gold = Color(0xFFFFD400);

class BookListScreen extends StatefulWidget {
  const BookListScreen({Key? key}) : super(key: key);
  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  late final Future<List<ChapterMetadata>> _chapFuture;

  @override
  void initState() {
    super.initState();
    _chapFuture = BookService().loadChapters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/splash_bg.png'),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: _gold),
            title: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Image.asset('assets/logo_ui.png', height: 50),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<ChapterMetadata>>(
        future: _chapFuture,
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final chapters = snap.data!;
          if (chapters.isEmpty) {
            return const Center(
              child: Text(
                'No books found.',
                style: TextStyle(color: Colors.black87),
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                BookList(title: 'New Arrivals', chapters: chapters),
                BookList(title: 'Most Read', chapters: chapters),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
