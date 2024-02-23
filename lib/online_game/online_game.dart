import 'package:drum_test/online_game/tables.dart';
import 'package:flutter/material.dart';

class OnlineGameWidget extends StatelessWidget {
  const OnlineGameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/info-back.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text('Online соревнование'),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(onPressed: () {}, child: Text('Играть')),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OnlineTables()));
                  },
                  child: Text('Таблицы рекордов')),
            ],
          ),
        ),
      ),
    );
  }
}
