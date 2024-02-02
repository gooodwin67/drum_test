import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFffffff),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text('GAME Rhytm Challenge'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: 100,
                      height: 100,
                      color: const Color.fromARGB(255, 223, 223, 223),
                      alignment: Alignment.center,
                      child: Text('Начальный уровень'),
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 100,
                    height: 100,
                    color: const Color.fromARGB(255, 223, 223, 223),
                    alignment: Alignment.center,
                    child: Text('Продвинутый уровень'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
