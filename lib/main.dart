import 'package:hand_cricket_game/screens/hand_cricket_game_screen.dart';
import 'package:flutter/material.dart';
import 'package:hand_cricket_game/screens/instructions.dart';
import 'package:hand_cricket_game/screens/welcome_screen.dart';
import 'screens/rive_test.dart';
import 'screens/hand_num.dart';

void main() => runApp(const HandCricketApp());

class HandCricketApp extends StatelessWidget {
  const HandCricketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hand Cricket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      // Define app routes
      initialRoute: '/',
      routes: {
        // '/': (context) => const InstructionWidget(),
        // // '/': (context) => const HomeScreen(),
        // '/game': (context) => const HandCricketGameScreen(),
        // '/test': (context) => const RiveTestScreen(),
        // '/instruction': (context) => const InstructionWidget(),
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
      // appBar: AppBar(title: const Text('Hand Cricket')),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/background.png",
            ), // Add your background image path
            fit: BoxFit.cover, // Adjust based on your needs
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/overlays/game_bowl.png',
                  height: 150,
                ), // Add your logo
                const SizedBox(height: 40),
                _buildMenuButton(context, 'Start Game', '/game', Colors.green),
                const SizedBox(height: 20),
                _buildMenuButton(
                  context,
                  'Game Instructions',
                  '/instruction',
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
