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

  int rate = (60000 / 80).round();
  int inc = 0;
  int incTic = 4;

  List colors = [Colors.white, Colors.white, Colors.white, Colors.white];

  void _playTic() {
    if (incTic % 4 == 0) {
      inc = 0;
      player.play(AssetSource('sounds/tic0.mp3'));
    } else {
      player.play(AssetSource('sounds/tic5.mp3'));
    }

    Future.delayed(Duration(milliseconds: rate), () {
      _playTic();
      incTic++;
      colors = [Colors.white, Colors.white, Colors.white, Colors.white];
      setState(() {
        colors[inc] = Colors.red;
      });

      inc++;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: colors[0],
                ),
                child: Image.asset('assets/notes/nota1.jpg'),
              ),
              Container(
                width: 70,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: colors[1],
                ),
                child: Image.asset('assets/notes/nota1.jpg'),
              ),
              Container(
                width: 70,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: colors[2],
                ),
                child: Image.asset('assets/notes/nota1.jpg'),
              ),
              Container(
                width: 70,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: colors[3],
                ),
                child: Image.asset('assets/notes/nota1.jpg'),
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
