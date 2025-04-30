// lib/widgets/ebook_reader.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pdfx/pdfx.dart';

import '../models/book_metadata.dart';  // where ChapterMetadata lives

class EbookReader extends StatefulWidget {
  /// Metadata (parsed from meta.json)
  final ChapterMetadata chapter;

  const EbookReader({
    Key? key,
    required this.chapter,
  }) : super(key: key);

  @override
  State<EbookReader> createState() => _EbookReaderState();
}

class _EbookReaderState extends State<EbookReader> {
  static const _gold = Color(0xFFFFD400);

  late final PdfControllerPinch _pdfController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<String> _maleTracks = [];
  List<String> _femaleTracks = [];
  bool _isMale = true;
  int _currentPage = 1;
  bool _isPlaying = false;

  bool get _isPortrait =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  @override
  void initState() {
    super.initState();
    _initPdf();
    _loadAudioTracks().then((_) {
      _playAudioForPage(1);
    });
  }

  void _initPdf() {
    _pdfController = PdfControllerPinch(
      document: PdfDocument.openAsset(widget.chapter.getAssetPath(_isPortrait)),
      initialPage: 1,
    );
  }

  Future<void> _loadAudioTracks() async {
    final manifest = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> map = json.decode(manifest);

    final malePrefix = '${widget.chapter.basePath}/audio/male';
    final femalePrefix = '${widget.chapter.basePath}/audio/female';

    _maleTracks = map.keys
        .where((k) => k.startsWith(malePrefix) && k.endsWith('.mp3'))
        .toList()
      ..sort();
    _femaleTracks = map.keys
        .where((k) => k.startsWith(femalePrefix) && k.endsWith('.mp3'))
        .toList()
      ..sort();
  }

  Future<void> _playAudioForPage(int page) async {
    final tracks = _isMale ? _maleTracks : _femaleTracks;
    if (page - 1 < tracks.length) {
      final trackPath = '${widget.chapter.basePath}/audio/${_isMale ? 'male' : 'female'}/${page}_Chapter ${page}.mp3';
      await _audioPlayer.setAsset(trackPath);
      await _audioPlayer.play();
      setState(() => _isPlaying = true);

      // When audio completes, advance page
      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed &&
            _currentPage < widget.chapter.pages) {
          _goToPage(_currentPage + 1);
        }
      });
    }
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  Future<void> _goToPage(int page) async {
    if (page < 1 || page > widget.chapter.pages) return;
    await _pdfController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentPage = page;
      _isPlaying = false;
    });
    _playAudioForPage(page);
  }

  Future<void> _previousPage() async {
    if (_currentPage > 1) {
      await _pdfController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage--;
        _isPlaying = false;
      });
      _playAudioForPage(_currentPage);
    }
  }

  Future<void> _toggleVoice() async {
    setState(() => _isMale = !_isMale);
    if (_isPlaying) {
      await _audioPlayer.stop();
      _playAudioForPage(_currentPage);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with voice-toggle
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: _gold),
        flexibleSpace: Image.asset(
          'assets/splash_bg.png',
          fit: BoxFit.cover,
        ),
        title: Text(widget.chapter.title),
        actions: [
          IconButton(
            icon: Icon(_isMale ? Icons.mic : Icons.mic_none),
            color: _gold,
            onPressed: _toggleVoice,
            tooltip: _isMale ? 'Male narration' : 'Female narration',
          ),
        ],
      ),

      // PDF viewer
      body: PdfViewPinch(
        controller: _pdfController,
        onPageChanged: (page) {
          _currentPage = page;
          if (_isPlaying) {
            _playAudioForPage(page);
          }
        },
      ),

      // Playback controls
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous
              IconButton(
                icon: const Icon(Icons.chevron_left),
                color: Colors.white,
                onPressed: _currentPage > 1 ? _previousPage : null,
              ),

              // Play/Pause
              IconButton(
                icon:
                    Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle),
                color: Colors.white,
                iconSize: 36,
                onPressed: _togglePlayPause,
              ),

              // Next
              IconButton(
                icon: const Icon(Icons.chevron_right),
                color: Colors.white,
                onPressed: _currentPage < widget.chapter.pages
                    ? () => _goToPage(_currentPage + 1)
                    : null,
              ),

              // Page indicator
              Text(
                '$_currentPage / ${widget.chapter.pages}',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
