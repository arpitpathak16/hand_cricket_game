import 'dart:async';
import 'package:flutter/material.dart';

class InstructionWidget extends StatefulWidget {
  const InstructionWidget({super.key});

  @override
  State<InstructionWidget> createState() => _InstructionWidgetState();
}

class _InstructionWidgetState extends State<InstructionWidget> {
  int _currentImageIndex = 0;
  Timer? _imageTimer;

  final List<String> instructionImages = [
    'assets/images/hand_cricket_logo.png',
    'assets/overlays/game_bowl.png',
    'assets/images/you_won.png',
  ];

  @override
  void initState() {
    super.initState();
    _startImageRotation();
  }

  void _startImageRotation() {
    _imageTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _currentImageIndex =
            (_currentImageIndex + 1) % instructionImages.length;
      });
    });
  }

  @override
  void dispose() {
    _imageTimer?.cancel();
    super.dispose();
  }

  void _showCountdown() async {
    List<String> countdownImages = [
      'assets/overlays/num_3.png',
      'assets/overlays/num_2.png',
      'assets/overlays/num_1.png',
    ];

    for (int i = 0; i < countdownImages.length; i++) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Center(
            child: Image.asset(
              countdownImages[i],
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
          );
        },
      );

      await Future.delayed(
        const Duration(seconds: 1),
      ); // Show each number for 1 second
      Navigator.of(context).pop(); // Close current popup
    }

    // After countdown complete → Navigate to game
    Navigator.pushReplacementNamed(context, '/game');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B46),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.03),

              _animatedEntry(
                delay: 0,
                child: Text(
                  "How to Play?",
                  style: TextStyle(
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              _animatedEntry(
                delay: 300,
                child: _buildStep(
                  stepNumber: "1",
                  title: "Tap the buttons to score Runs",
                  image: 'assets/images/six.png',
                  screenWidth: screenWidth,
                ),
              ),

              SizedBox(height: screenHeight * 0.025),

              _animatedEntry(
                delay: 600,
                child: _buildSameDifferentSection(screenWidth),
              ),

              SizedBox(height: screenHeight * 0.025),

              _animatedEntry(
                delay: 900,
                child: _buildStep(
                  stepNumber: "3",
                  title: "Be the highest scorer & win exciting prizes",
                  image: 'assets/images/you_won.png',
                  screenWidth: screenWidth,
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Changing images
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: Image.asset(
                  instructionImages[_currentImageIndex],
                  key: ValueKey(_currentImageIndex),
                  height: screenWidth * 0.4,
                  width: screenWidth * 0.4,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              _animatedEntry(
                delay: 1200,
                child: SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.07,
                  child: ElevatedButton(
                    onPressed: () async {
                      await Future.delayed(
                        const Duration(milliseconds: 500),
                      ); // Button click feel

                      _showCountdown(); // Show animated countdown
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB800),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Start Playing",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _animatedEntry({required int delay, required Widget child}) {
    return TweenAnimationBuilder(
      tween: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      builder: (context, offset, _) {
        return Transform.translate(
          offset: Offset(0, (offset as Offset).dy * 50),
          child: AnimatedOpacity(
            opacity: 1.0 - offset.dy,
            duration: const Duration(milliseconds: 300),
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildStep({
    required String stepNumber,
    required String title,
    required String image,
    required double screenWidth,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.orange,
            radius: screenWidth * 0.06,
            child: Text(
              stepNumber,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: screenWidth * 0.05,
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.04,
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.02),
          Image.asset(
            image,
            height: screenWidth * 0.1,
            width: screenWidth * 0.1,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildSameDifferentSection(double screenWidth) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/same_hands.png',
                  height: screenWidth * 0.2,
                  width: screenWidth * 0.2,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8),
                Text(
                  "Same number:\nYou're out!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.035,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/different_hands.png',
                  height: screenWidth * 0.2,
                  width: screenWidth * 0.2,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8),
                Text(
                  "Different number:\nYou score runs",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.035,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
