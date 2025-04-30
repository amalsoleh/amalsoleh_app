// lib/widgets/book_list.dart

import 'package:flutter/material.dart';
import '../models/book_metadata.dart';

class BookList extends StatelessWidget {
  final String title;
  final List<ChapterMetadata> chapters;

  const BookList({
    Key? key,
    required this.title,
    required this.chapters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),

        // Carousel
        SizedBox(
          height: 200, // total height of each card
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: chapters.length,
            itemBuilder: (ctx, i) {
              final chap = chapters[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  width: 140, // card width
                  height: 200, // must match outer SizedBox height
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // 1) Cover image fills all space above title
                        Expanded(
                          child: Image.asset(
                            chap.getCover(portrait: true),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),

                        // 2) Title bar with fixed height
                        Container(
                          height: 48,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            chap.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
