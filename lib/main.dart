import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MusicApp(),
    );
  }
}

class MusicApp extends StatefulWidget {
  @override
  _MusicAppState createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  //Variables for the controller
  bool playing = false;
  IconData playBtn = Icons.play_circle_fill_sharp;

  // Objects
  AudioPlayer _player = AudioPlayer();
  AudioCache cache;

  Duration pos = new Duration();
  Duration musicLength = new Duration();

  //slider
  Widget slider() {
    return Slider.adaptive(
        activeColor: Colors.blue[800],
        inactiveColor: Colors.grey[350],
        value: pos.inSeconds.toDouble(),
        max: musicLength.inSeconds.toDouble(),
        onChanged: (value) {
          seekToSec(value.toInt());
        });
  }

  //seek function
  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    _player.seek(newPos);
  }

  // initialization of player
  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    cache = AudioCache(fixedPlayer: _player);

    //handling audio player's time
    _player.durationHandler = (d) {
      // to get music duration
      setState(() {
        musicLength = d;
      });
    };
    _player.positionHandler = (p) {
      //allows moving of the cursor of the slider while song is played
      setState(() {
        pos = p;
      });
    };
    cache.load("kalinka.mp3");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue[900], Colors.blue[300]])),
        child: Padding(
          padding: EdgeInsets.only(
            top: 48,
          ), // left: 12, right: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // let's add some text, title
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  "ИТМО Music Player",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  " Listen to your favourite Music!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w200),
                ),
              ),
              SizedBox(
                height: 24,
              ),

              //let's add the music cover
              Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        image: AssetImage('assets/image.jpg'),
                      )),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                  child: Text(
                "Калинка",
                style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              )),
              SizedBox(
                height: 15,
              ),
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //we add controller
                    Container(
                      width: 700,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              "${pos.inMinutes}:${pos.inSeconds.remainder(60)}"),
                          slider(),
                          Text(
                              "${musicLength.inMinutes}:${musicLength.inSeconds.remainder(60)}"),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 50,
                          color: Colors.blue[500],
                          onPressed: () {},
                          icon: Icon(Icons.skip_previous_sharp),
                        ),
                        IconButton(
                          iconSize: 60,
                          color: Colors.blue,
                          onPressed: () {
                            if (!playing) {
                              setState(() {
                                // to play the song
                                cache.play("kalinka.mp3");

                                playBtn = Icons.pause_circle_filled_sharp;
                                playing = true;
                              });
                            } else {
                              setState(() {
                                _player.pause();

                                playBtn = Icons.play_circle_fill_sharp;
                                playing = false;
                              });
                            }
                          },
                          icon: Icon(playBtn),
                        ),
                        IconButton(
                          iconSize: 50,
                          color: Colors.blue[500],
                          onPressed: () {},
                          icon: Icon(Icons.skip_next_sharp),
                        )
                      ],
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
