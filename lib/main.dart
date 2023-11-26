import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final player = AudioPlayer();
  //int rate = ((60000 / 54 * (1 / 4)) * 1000).round();
  int rate = (60000 / 50).round();

  void _playTic() async {
    player.play(AssetSource('sounds/tic.mp3'));
    Future.delayed(Duration(milliseconds: rate), () {
      _playTic();
    });
  }

  @override
  Widget build(BuildContext context) {
    print(rate);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 70,
                height: 150,
                color: Colors.red,
              ),
              Container(
                width: 70,
                height: 150,
                color: Colors.red,
              ),
              Container(
                width: 70,
                height: 150,
                color: Colors.red,
              ),
              Container(
                width: 70,
                height: 150,
                color: Colors.red,
              ),
            ],
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              enableFeedback: false,
              onTap: () async {
                //await player.play(AssetSource('sounds/tic.mp3'));
              },
              child: Container(
                color: Colors.green,
                width: double.infinity,
                height: 250,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _playTic,
        child: const Icon(Icons.play_arrow),
      ), //
    );
  }
}
