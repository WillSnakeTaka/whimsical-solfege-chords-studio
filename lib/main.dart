import 'package:flutter/material.dart';
import 'dart:math';
// removed unused webview/dart:io imports (not needed here)
import 'package:google_fonts/google_fonts.dart';
// categories screen not referenced from this file
import 'package:multiscreen/screens/twelve_keys.dart';
import 'package:multiscreen/screens/music_game.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 131, 57, 0),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whimsical Solfège Chords Studio',
      theme: theme,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Whimsical Solfège Chords Studio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _BigButton(
              title: '12 Keys',
              icon: Icons.music_note,
              color: Colors.purple,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TwelveKeysScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _BigButton(
              title: 'Music Game',
              icon: Icons.videogame_asset,
              color: Colors.teal,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MusicGameScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            _BigButton(
              label: 'Introduction',
              icon: Icons.movie,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const IntroductionScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _BigButton(
              label: 'Piano Keys',
              icon: Icons.piano,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PianoKeysScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _BigButton(
              label: 'Ear Training',
              icon: Icons.hearing,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EarTrainingScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BigButton extends StatelessWidget {
  final String? label;
  final String? title;
  final IconData icon;
  final VoidCallback? onTap;
  final VoidCallback? onPressed;
  final Color? color;

  const _BigButton({
    this.label,
    this.title,
    required this.icon,
    this.onTap,
    this.onPressed,
    this.color,
  }) : assert(label != null || title != null),
       assert(onTap != null || onPressed != null);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 28),
        label: Text(
          label ?? title!, 
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)
        ),
        onPressed: onPressed ?? onTap,
        style: color != null ? ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
        ) : null,
      ),
    );
  }
}

/// ---------------------- INTRODUCTION ----------------------

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});
  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  VideoPlayerController? _controller;

  // Set this to your YouTube or web game URL (opens in browser)
  final Uri _introLink = Uri.parse('https://example.com/your-video-or-game');

  @override
  void initState() {
    super.initState();
    // If you want to play a local video asset, uncomment the two lines below
    // and make sure assets/videos/intro.mp4 exists + is listed in pubspec.
    //
    // _controller = VideoPlayerController.asset('assets/videos/intro.mp4')
    //   ..initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _openExternal() async {
    if (!await launchUrl(_introLink, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasLocalVideo = _controller?.value.isInitialized == true;
    return Scaffold(
      appBar: AppBar(title: const Text('Introduction')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (hasLocalVideo) ...[
              AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(_controller!.value.isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: () {
                      setState(() {
                        _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
                      });
                    },
                  ),
                ],
              ),
            ] else ...[
              // Thumbnail fallback
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 240,
                        child: Image.asset('assets/images/intro_thumb.png', fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 96),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Tap below to open the video or web demo'),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open Intro Video / Web Demo'),
                  onPressed: _openExternal,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// ---------------------- PIANO KEYS ----------------------

class PianoKeysScreen extends StatefulWidget {
  const PianoKeysScreen({super.key});
  @override
  State<PianoKeysScreen> createState() => _PianoKeysScreenState();
}

class _PianoKeysScreenState extends State<PianoKeysScreen> {
  late final AudioPlayer _player;
  final List<String> _notes = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _play(String note) async {
    await _player.stop();
    await _player.play(AssetSource('audio/$note.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Piano Keys')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: _notes
              .map((n) => ElevatedButton(
                    onPressed: () => _play(n),
                    child: Text(n, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

/// ---------------------- EAR TRAINING ----------------------

class EarTrainingScreen extends StatefulWidget {
  const EarTrainingScreen({super.key});
  @override
  State<EarTrainingScreen> createState() => _EarTrainingScreenState();
}

class _EarTrainingScreenState extends State<EarTrainingScreen> {
  late final AudioPlayer _player;
  final List<String> _pool = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
  late String _answer;
  late List<String> _choices;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _newQuestion();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _newQuestion() {
    final r = Random();
    _answer = _pool[r.nextInt(_pool.length)];
    // pick 2 other random notes for choices
    final others = List<String>.from(_pool)..remove(_answer);
    others.shuffle();
    _choices = ([_answer, others[0], others[1]]..shuffle());
    setState(() {});
  }

  Future<void> _playQuestion() async {
    await _player.stop();
    await _player.play(AssetSource('audio/$_answer.mp3'));
  }

  void _pick(String choice) {
    final correct = choice == _answer;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(correct ? 'Correct! It was $_answer.' : 'Not quite. It was $_answer.')),
    );
    _newQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ear Training')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text('Play Note'),
                onPressed: _playQuestion,
              ),
            ),
            const SizedBox(height: 20),
            ..._choices.map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () => _pick(c),
                    child: Text(c, style: const TextStyle(fontSize: 18)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
