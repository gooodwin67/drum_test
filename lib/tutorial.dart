import 'package:drum_test/player_widget_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _controller = YoutubePlayerController.fromVideoId(
      videoId: 'z_fJTMWPqcw',
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );
    final _controller2 = YoutubePlayerController.fromVideoId(
      videoId: 'I9XQgBhbjWk',
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true),
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
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Идея приложения была взята из видео на YouTube.',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                YoutubePlayer(
                  controller: _controller,
                  aspectRatio: 16 / 9,
                ),
                SizedBox(height: 30),
                Text(
                  'Пример работы приложения',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                YoutubePlayer(
                  controller: _controller2,
                  aspectRatio: 16 / 9,
                ),
                SizedBox(height: 30),
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
                  child: Text('Инструкция по интерфейсу'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
