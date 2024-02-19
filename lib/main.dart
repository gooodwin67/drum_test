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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 56, 41, 25),
          primary: Color.fromARGB(255, 94, 72, 45),
        ),
        primaryColorDark: Color(0xFFA08F7B),
        primaryColor: Colors.white,
        useMaterial3: true,
        textTheme: const TextTheme().copyWith(
          bodySmall: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          bodyMedium: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          bodyLarge: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255), fontSize: 23),
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/rhythm-back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 50),
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "RHYTHM CHALLENGE",
              style: TextStyle(
                fontSize: 35,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TutorialScreen()));
              },
              child: Text(
                'Инструкция',
                style: TextStyle(color: Color.fromARGB(255, 73, 73, 73)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FreeScreen()));
              },
              child: Text(
                'Ритм Челлендж',
                style: TextStyle(color: Color.fromARGB(255, 73, 73, 73)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SelectGameScreen()));
              },
              child: Text(
                'Игра "Ритм Челлендж"',
                style: TextStyle(color: Color.fromARGB(255, 73, 73, 73)),
              ),
            ),
          ],
        )),
      ),
    );
  }
}

//const FreeScreen(title: 'Rhythm Challenge')