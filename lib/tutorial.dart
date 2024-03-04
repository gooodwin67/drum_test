import 'package:drum_test/player_widget_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: 'z_fJTMWPqcw',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/back-tutorial.jpg'),
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
          title: Text('Инструкция'),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text('Идея приложения была взята из видео на YouTube.'),
              SizedBox(height: 10),
              YoutubePlayer(controller: _controller),
              SizedBox(height: 30),
              Text('Перейдите на страницу с обучением.'),
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowCaseWidget(
                            builder: Builder(
                                builder: (context) => PlayerWidgetTutorial()),
                          ),
                        ));
                  },
                  child: Text('Обучение')),
            ],
          ),
        ),
      ),
    );
  }
}
