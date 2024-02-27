//https://github.com/sintakt/sintakt.github.io/blob/master/lib/src/click_player/click_player.dart

import 'package:drum_test/free.dart';
import 'package:drum_test/game.dart';
import 'package:drum_test/info.dart';
import 'package:drum_test/online_game/online_game.dart';
import 'package:drum_test/tutorial.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android:
                FadeUpwardsPageTransitionsBuilder(), // Apply this to every platforms you need.
          },
        ),
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
        padding:
            const EdgeInsets.only(left: 60, right: 60, top: 50, bottom: 10),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                        style:
                            TextStyle(color: Color.fromARGB(255, 73, 73, 73)),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const InfoScreen()));
                      },
                      child: Text(
                        'Информация',
                        style:
                            TextStyle(color: Color.fromARGB(255, 73, 73, 73)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "RHYTHM CHALLENGE",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FreeScreen()));
                  },
                  child: Text(
                    'Свободная тренировка',
                    style: TextStyle(color: Color.fromARGB(255, 73, 73, 73)),
                    textAlign: TextAlign.center,
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
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OnlineGameWidget()));
                  },
                  child: Text(
                    'Online соревнование',
                    style: TextStyle(color: Color.fromARGB(255, 73, 73, 73)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}

//const FreeScreen(title: 'Rhythm Challenge')