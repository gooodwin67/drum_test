//https://github.com/sintakt/sintakt.github.io/blob/master/lib/src/click_player/click_player.dart

import 'package:drum_test/free.dart';
import 'package:drum_test/game.dart';
import 'package:drum_test/tutorial.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainScreen());
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rhythm Challenge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        primaryColor: Colors.white,
        useMaterial3: true,
        textTheme: const TextTheme().copyWith(
          bodySmall: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          bodyMedium: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          bodyLarge: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          labelSmall:
              const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          labelMedium:
              const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          labelLarge:
              const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          displaySmall:
              const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          displayMedium:
              const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          displayLarge:
              const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      home: MenuScreen(),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(60),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TutorialScreen()));
              },
              child: Text('Tutorial'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FreeScreen()));
              },
              child: Text('FREE Rhytm Challenge'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GameScreen()));
              },
              child: Text('GAME Rhytm Challenge'),
            ),
          ],
        )),
      ),
    );
  }
}

//const FreeScreen(title: 'Rhythm Challenge')