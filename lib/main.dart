// main.dart
import 'package:hand_cricket_game/screens/hand_cricket_game_screen.dart';
import 'package:flutter/material.dart';
import 'package:hand_cricket_game/screens/instructions.dart';
import 'package:hand_cricket_game/screens/welcome_screen.dart';
import 'screens/rive_test.dart';
import 'package:just_audio/just_audio.dart';

void main() => runApp(const HandCricketApp());

class HandCricketApp extends StatefulWidget {
  const HandCricketApp({super.key});

  @override
  State<HandCricketApp> createState() => _HandCricketAppState();
}

class _HandCricketAppState extends State<HandCricketApp> {
  final AudioPlayer _backgroundPlayer =
      AudioPlayer(); // Background music player

  @override
  void initState() {
    super.initState();
    _playBackgroundMusic();
  }

  void _playBackgroundMusic() async {
    try {
      await _backgroundPlayer.setLoopMode(LoopMode.one); // Repeat continuously
      await _backgroundPlayer.setVolume(0.4); // Softer volume
      await _backgroundPlayer.setAsset(
        'music/background-music.mp3',
      ); 
      await _backgroundPlayer.play();
    } catch (e) {
      debugPrint("Error playing background music: $e");
    }
  }

  @override
  void dispose() {
    _backgroundPlayer.dispose(); // Clean up
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hand Cricket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeSplashScreen(),
        '/instructions': (context) => const InstructionWidget(),
        '/game': (context) => const HandCricketGameScreen(),
        '/test': (context) => const RiveTestScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/overlays/game_bowl.png', height: 150),
                const SizedBox(height: 40),
                _buildMenuButton(context, 'Start Game', '/game', Colors.green),
                const SizedBox(height: 20),
                _buildMenuButton(
                  context,
                  'Game Instructions',
                  '/instructions',
                  Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String text,
    String route,
    Color color,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () => Navigator.pushNamed(context, route),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
