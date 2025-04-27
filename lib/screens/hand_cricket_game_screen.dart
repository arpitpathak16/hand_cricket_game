import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'dart:math';

class HandCricketGameScreen extends StatefulWidget {
  const HandCricketGameScreen({super.key});

  @override
  State<HandCricketGameScreen> createState() => _HandCricketGameScreenState();
}

class _HandCricketGameScreenState extends State<HandCricketGameScreen> {
  // Game state variables
  bool isPlayerBatting = true;
  int playerScore = 0;
  int computerScore = 0;
  int currentBall = 0;
  List<int> playerScores = [];
  List<int> computerScores = [];

  String? overlayImagePath;
  double overlayOpacity = 0.0;
  double overlayScale = 0.8; // Start slightly small

  int remainingTime = 10;
  Timer? choiceTimer;

  bool isBlinking = false;

  // Artboard related variables
  Artboard? _playerArtboard;
  Artboard? _computerArtboard;
  SMINumber? _playerHandInput;
  SMINumber? _computerHandInput;

  @override
  void initState() {
    super.initState();
    _loadRiveAssets();
    _showOverlayImage('batting');
    _startChoiceTimer(); // Start timer when game starts
  }

  void _startChoiceTimer() {
    choiceTimer?.cancel();
    setState(() {
      remainingTime = 10;
    });

    choiceTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel();
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    // if (isPlayerBatting) {
    //   _showOverlayImage('time_up');
    //   Future.delayed(const Duration(milliseconds: 1200), () {
    //     _showGameOver("Time's Up! You Lost!");
    //   });
    // } else {
    //   // If needed: you can handle timeout for computer batting too
    // }
    _showOverlayImage('time_up');
    Future.delayed(const Duration(milliseconds: 1200), () {
      _showGameOver("Time's Up! You Lost!");
    });
  }

  void _loadRiveAssets() async {
    final playerData = await rootBundle.load('assets/riv/hand.riv');
    final playerFile = RiveFile.import(playerData);
    final playerArtboard = playerFile.mainArtboard;
    final playerController = StateMachineController.fromArtboard(
      playerArtboard,
      'State Machine 1',
    );

    if (playerController != null) {
      playerArtboard.addController(playerController);
      _playerHandInput =
          playerController.findInput<double>('Input') as SMINumber?;
      _playerHandInput?.value = 0;
    }

    final computerData = await rootBundle.load('assets/riv/hand.riv');
    final computerFile = RiveFile.import(computerData);
    final computerArtboard = computerFile.mainArtboard;
    final computerController = StateMachineController.fromArtboard(
      computerArtboard,
      'State Machine 1',
    );

    if (computerController != null) {
      computerArtboard.addController(computerController);
      _computerHandInput =
          computerController.findInput<double>('Input') as SMINumber?;
      _computerHandInput?.value = 0;
    }

    setState(() {
      _playerArtboard = playerArtboard;
      _computerArtboard = computerArtboard;
    });
  }

  void _playTurn(int playerChoice) {
    final computerChoice = Random().nextInt(6) + 1;

    _playerHandInput?.value = playerChoice.toDouble();
    _computerHandInput?.value = computerChoice.toDouble();

    setState(() {
      bool isOut = (playerChoice == computerChoice);

      // Map the number to the overlay image
      final numberOverlay = {
        1: 'ONE',
        2: 'TWO',
        3: 'THREE',
        4: 'FOUR',
        5: 'FIVE',
        6: 'sixer',
      };

      if (isPlayerBatting) {
        if (isOut) {
          _showOverlayImage('out');
          _switchToComputerBatting();
        } else {
          playerScore += playerChoice;
          playerScores.add(playerChoice);

          _showOverlayImage(numberOverlay[playerChoice]!); // <-- dynamic lookup

          currentBall++;
          if (currentBall == 6) {
            _switchToComputerBatting();
          }
        }
      } else {
        if (isOut) {
          _showOverlayImage('out');
          _showResult();
        } else {
          computerScore += computerChoice;
          computerScores.add(computerChoice);

          _showOverlayImage(
            numberOverlay[computerChoice]!,
          ); // <-- dynamic lookup

          currentBall++;
          if (computerScore > playerScore) {
            _showResult();
          } else if (currentBall == 6) {
            _showResult();
          }
        }
      }
      // At the very end of _playTurn()
      _startChoiceTimer();
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      _playerHandInput?.value = 0;
      _computerHandInput?.value = 0;
    });
  }

  void _switchToComputerBatting() {
    setState(() {
      isPlayerBatting = false;
      currentBall = 0;
      computerScores.clear();
    });

    Future.delayed(const Duration(milliseconds: 2500), () {
      _showOverlayImage('game_defend');
    });
    // First show a stylish RCB-style dialog
    Future.delayed(const Duration(milliseconds: 500), () {
      _showDefendDialog();
      _startChoiceTimer();
    });

    // Then show small defend overlay after dialog
  }

  void _showDefendDialog() {
    int targetScore = playerScore + 1;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0D1B46), // Deep RCB dark blue
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.amber, width: 3),
          ),
          title: const Text(
            'Get Ready!',
            style: TextStyle(
              color: Colors.amberAccent,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Defend $playerScore runs in 6 balls\nto win the match!",
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/overlays/game_bowl.png',
                height: 100,
                width: 100,
                fit: BoxFit.contain,
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Start Bowling",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showResult() {
    Future.delayed(const Duration(milliseconds: 1200), () {
      String message;
      String overlayName;
      if (computerScore > playerScore) {
        message = "Computer Wins!";
        overlayName = 'computer_won';
      } else if (computerScore < playerScore) {
        message = "You Win!";
        overlayName = 'you_won';
      } else {
        message = "Match Tied!";
        overlayName = 'draw';
      }
      _showOverlayImage(overlayName);
      Future.delayed(const Duration(milliseconds: 1500), () {
        _showGameOver(message);
      });
    });
  }

  void _showOverlayImage(String imageName) {
    setState(() {
      overlayImagePath = 'assets/overlays/$imageName.png';
      overlayOpacity = 0.0;
      overlayScale = 0.8; // Start small
    });

    // Fade in + Scale up
    Future.delayed(Duration.zero, () {
      setState(() {
        overlayOpacity = 1.0;
        overlayScale = 1.0; // Grow to full size
      });
    });

    // Fade out + Scale down after 1 second
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        overlayOpacity = 0.0;
        overlayScale = 0.8; // Shrink back
      });
    });

    // Remove overlay image completely after fade-out
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        overlayImagePath = null;
      });
    });
  }

  void _showGameOver(String message) {
    choiceTimer?.cancel(); // Stop timer

    showDialog(
      context: context,
      barrierDismissible: false, // User must click button
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.black.withOpacity(0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.redAccent, width: 3),
            ),
            title: Center(
              child: Text(
                'Game Over 🏏',
                style: const TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Player: $playerScore\nComputer: $computerScore',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _resetGame();
                },
                child: const Text(
                  'Play Again',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
    );
  }

  void _resetGame() {
    setState(() {
      isPlayerBatting = true;
      playerScore = 0;
      computerScore = 0;
      currentBall = 0;
      playerScores.clear();
      computerScores.clear();
    });

    _startCountdown();
  }

  void _startCountdown() {
    _showOverlayImage('num_3');

    Future.delayed(const Duration(milliseconds: 1000), () {
      _showOverlayImage('num_2');

      Future.delayed(const Duration(milliseconds: 1000), () {
        _showOverlayImage('num_1');

        Future.delayed(const Duration(milliseconds: 1000), () {
          _showOverlayImage('batting');

          Future.delayed(const Duration(milliseconds: 1000), () {
            _startChoiceTimer(); // Start timer AFTER "batting" screen finishes
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildPlayerInfoBar(),
                  _buildTimer(),
                  Expanded(child: _buildGameArea()),
                  _buildHandSelectionButtons(),
                ],
              ),
            ),
          ),
          if (overlayImagePath != null)
            Center(
              child: AnimatedOpacity(
                opacity: overlayOpacity,
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOut,
                child: AnimatedScale(
                  scale: overlayScale,
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeInOut,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(
                        0.3,
                      ), // subtle dark background
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Image.asset(
                      overlayImagePath!,
                      width: 250,
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlayerInfoBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: _buildPlayerInfoCard(
              "You",
              "$playerScore",
              true,
              isPlayerBatting,
            ),
          ),
          const SizedBox(width: 12), // small gap between player and computer
          Flexible(
            flex: 1,
            child: _buildPlayerInfoCard(
              "Computer",
              "$computerScore",
              true,
              !isPlayerBatting,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerInfoCard(
    String name,
    String score,
    bool isActive,
    bool isBatting,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = constraints.maxWidth;
        double baseFontSize = cardWidth * 0.18;
        double avatarRadius = cardWidth * 0.25;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: cardWidth * 0.08,
            vertical: cardWidth * 0.06,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isBatting ? Colors.amberAccent : Colors.grey.shade400,
              width: isBatting ? 3 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Text(
                      name[0],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: baseFontSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (isBatting)
                    Positioned(
                      bottom: -4,
                      right: -8,
                      child: Icon(
                        Icons.sports_cricket,
                        color: Colors.amberAccent,
                        size: baseFontSize * 0.8,
                      ),
                    ),
                ],
              ),
              SizedBox(width: cardWidth * 0.08),

              // Add Flexible around score text
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    score,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: baseFontSize * 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGameArea() {
    List<int> scoresToDisplay = isPlayerBatting ? playerScores : computerScores;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_playerArtboard != null && _computerArtboard != null)
          LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              final characterWidth = (totalWidth - 20) / 2;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: characterWidth,
                    height: characterWidth,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
                      child: Rive(artboard: _playerArtboard!),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: characterWidth,
                    height: characterWidth,
                    child: Rive(artboard: _computerArtboard!),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }

  Widget _buildTimer() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: isBlinking ? (remainingTime % 2 == 0 ? 1.0 : 0.0) : 1.0,
        child: Text(
          'Time Left: $remainingTime s',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color:
                remainingTime <= 3
                    ? Colors.red
                    : const Color.fromARGB(255, 255, 217, 0),
            shadows:
                remainingTime <= 3
                    ? [
                      const Shadow(
                        blurRadius: 10,
                        color: Colors.redAccent,
                        offset: Offset(0, 0),
                      ),
                    ]
                    : [],
          ),
        ),
      ),
    );
  }

  Widget _buildHandSelectionButtons() {
    List<int> scoresToDisplay = isPlayerBatting ? playerScores : computerScores;

    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;

        double boxSize = (screenWidth - (6 * 8)) / 6;
        double buttonWidth = (screenWidth - 2 * 10 - 2 * 16) / 3;
        double buttonHeight = buttonWidth * 0.75;

        int totalBallsPlayed = playerScores.length;
        double runRate =
            totalBallsPlayed > 0 ? (playerScore / totalBallsPlayed) * 6 : 0.0;
        double strikeRate =
            totalBallsPlayed > 0 ? (playerScore / totalBallsPlayed) * 100 : 0.0;
        int projectedScore = runRate.round();

        int remainingBalls = 6 - computerScores.length;
        int runsToDefend = 0;
        if (playerScore - computerScore >= 0) {
          runsToDefend = playerScore - computerScore + 1;
        } else {
          runsToDefend = playerScore - computerScore;
        }
        if (runsToDefend < 0) {
          runsToDefend = 0;
        }
        if (remainingBalls < 0) {
          remainingBalls = 0;
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔥 Dynamic Info Text Row
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                    255,
                    255,
                    176,
                    7,
                  ).withOpacity(0.2), // Light golden glow
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFFFB300), // Bold golden border
                    width: 2,
                  ),
                ),
                child: Text(
                  isPlayerBatting
                      ? "Strike Rate: ${strikeRate.toStringAsFixed(1)} | Projected: $projectedScore"
                      : "Target: ${playerScore + 1} | Defend $runsToDefend runs in $remainingBalls balls",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.amberAccent,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 8),

            //  Over balls (scoreboxes)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                Color boxColor = Colors.white.withOpacity(0.8);

                if (index < scoresToDisplay.length) {
                  if (scoresToDisplay[index] == 6) {
                    boxColor = Colors.green;
                  } else if (scoresToDisplay[index] == 4) {
                    boxColor = const Color.fromARGB(255, 255, 0, 0);
                  }
                }

                return Container(
                  margin: const EdgeInsets.all(4),
                  width: boxSize,
                  height: boxSize,
                  decoration: BoxDecoration(
                    color: boxColor,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color.fromARGB(255, 255, 208, 0),
                      width: 4,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      index < scoresToDisplay.length
                          ? '${scoresToDisplay[index]}'
                          : '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: boxSize * 0.4,
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            // 🔥 Buttons for hand selection
            SizedBox(
              height: buttonHeight * 2 + 20,
              child: GridView.count(
                crossAxisCount: 3,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: buttonWidth / buttonHeight,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: List.generate(6, (index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                      foregroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.all(8),
                    ),
                    onPressed: () => _playTurn(index + 1),
                    child: Image.asset(
                      'assets/images/${_getImageName(index)}.png',
                      fit: BoxFit.contain,
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getImageName(int index) {
    switch (index) {
      case 0:
        return 'one';
      case 1:
        return 'two';
      case 2:
        return 'three';
      case 3:
        return 'four';
      case 4:
        return 'five';
      case 5:
        return 'six';
      default:
        return 'one';
    }
  }
}
