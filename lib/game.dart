import 'package:drum_test/games/easy_level.dart';
import 'package:drum_test/games/hard_level.dart';
import 'package:flutter/material.dart';

class SelectGameScreen extends StatelessWidget {
  const SelectGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/rhythm-back3.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            'Игра РИТМ Челлендж',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EasyScreen()));
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFF43886c),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(172, 0, 0, 0),
                            blurRadius: 5,
                            offset: Offset(2, 2)),
                      ],
                    ),
                    child: const Text(
                      'Начальный уровень',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HardScreen()));
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFFCA584C),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(172, 0, 0, 0),
                            blurRadius: 5,
                            offset: Offset(2, 2)),
                      ],
                    ),
                    child: const Text(
                      'Продвинутый уровень',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
