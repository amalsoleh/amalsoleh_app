// lib/widgets/home_screen.dart

import 'package:flutter/material.dart';
import '../models/book_metadata.dart';
import '../services/book_service.dart';
import '../widgets/book_list.dart';
import '../screens/book_list_screen.dart';

const _gold = Color(0xFFFFD400);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.35,
        minChildSize: 0.2,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // — header —
                Row(
                  children: [
                    Icon(Icons.menu, color: _gold),
                    const SizedBox(width: 8),
                    Text('Menu',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _gold,
                        )),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // — grid of tiles —
                Expanded(
                  child: GridView.count(
                    controller: scrollController,
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.8,
                    children: [
                      _MenuTile(
                        icon: Icons.home,
                        label: 'Home',
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      _MenuTile(
                        icon: Icons.library_books,
                        label: 'Library',
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const BookListScreen(),
                          ));
                        },
                      ),
                      _MenuTile(icon: Icons.card_giftcard, label: 'Earn Rewards', onTap: () {}),
                      _MenuTile(icon: Icons.monetization_on, label: 'My Points', onTap: () {}),
                      _MenuTile(icon: Icons.settings, label: 'Settings', onTap: () {}),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: _gold),
        flexibleSpace: Image.asset('assets/splash_bg.png', fit: BoxFit.cover),
        title: Image.asset('assets/logo_ui.png', height: 48),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: _gold),
          onPressed: () => _openMenu(context),
        ),
      ),
      body: FutureBuilder<List<ChapterMetadata>>(
        future: BookService().loadChapters(),
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done)
            return const Center(child: CircularProgressIndicator());
          final chapters = snap.data ?? [];
          if (chapters.isEmpty) return const Center(child: Text('No books found.'));
          return SingleChildScrollView(
            child: Column(
              children: [
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

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32, color: _gold),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
