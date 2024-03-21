import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

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
          title: Text('Информация'),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Добро пожаловать в Rhythm Challenge - вашего надежного спутника в мире тренировки ритма и музыкальной координации! Если вы мечтаете стать мастером ритма, наше приложение поможет вам достичь этой цели. '),
              SizedBox(height: 5),
              Text('Приложение разработано на Flutter.'),
              SizedBox(height: 20),
              Text(
                'Разработчик',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 10),
                  Text(
                    'Алейник Андрей Иванович',
                    style: TextStyle(color: Color.fromARGB(255, 44, 44, 44)),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.public),
                  SizedBox(width: 10),
                  Text(
                    'www.lcfc.ru',
                    style: TextStyle(color: Color.fromARGB(255, 44, 44, 44)),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.mail_outline_outlined),
                  SizedBox(width: 10),
                  Text(
                    'sn67@inbox.ru',
                    style: TextStyle(color: Color.fromARGB(255, 44, 44, 44)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
