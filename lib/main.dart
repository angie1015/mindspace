import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

import 'Preliminary.dart';

const img = 'assets/images/';
const title = TextStyle(color: Colors.white, fontSize: 36, letterSpacing: 13.0, fontWeight: FontWeight.w600);

void main() {
  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'Nunito'),
    debugShowCheckedModeBanner: false,
    home: HomeRoute(),
  ));
}

class HomeRoute extends StatefulWidget {

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {

  AudioPlayer player;
  AudioCache cache;
  bool initialPlay = true;
  bool playing;

  natureSounds(s1, s2, s3, s4, context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 10),
        soundBtnBg(s1, context),
        SizedBox(width: 10),
        soundBtnBg(s2, context),
        SizedBox(width: 10),
        soundBtnBg(s3, context),
        SizedBox(width: 10),
        soundBtnBg(s4, context),
        SizedBox(width: 10),],
    );
  }

  soundBtnBg(sound, context) {
    return GestureDetector(
      onTap: () {

        setState(() {
          player.stop();
          cache.clearCache();
          cache.play('audio/$sound.mp3');
          player.setVolume(.4);

         // if(playing==false) cache.play('audio/$sound.mp3');
          bg='${sound}_1';
        });
      },
      child: Column(
        children: [

          Image.asset('assets/icons/$sound.png',
            height: 50,
            width: 40,
          ),
          //Text(sound.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 1.0))
        ],
      ),
    );
  }

  row(s1, s2, s3, s4, context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 20),
        soundBtn(s1, context),
        SizedBox(width: 20),
        soundBtn(s2, context),
        SizedBox(width: 20),
        soundBtn(s3, context),
        SizedBox(width: 20),
        soundBtn(s4, context),
        SizedBox(width: 20),],
    );
  }

  soundBtn(sound, context) {
    return GestureDetector(
      onTap: () {

        player.stop();
        Navigator.push(context, MaterialPageRoute(builder: (context) => PlayRoute(sound: sound))); },
      child: Column(
        children: [
          Image.asset('assets/icons/$sound.png',
          height: 140,
              width: 120,
          ),
          Text(sound.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 3.0))
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    player = new AudioPlayer();
    cache = new AudioCache(fixedPlayer: player);
    //cache.play('audio/$sound1.mp3');
    //homeScreenBackground();
  }

  @override
  dispose() {
    super.dispose();
    player.stop();
  }
String sound1 = 'sunset';
  void homeScreenBackground() {

    playing = true;
    initialPlay = false;

  }
  
String bg='bkgnd_1';

  @override
  build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/$bg.jpg'), fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height:40),
              natureSounds('rain', 'forest', 'sunset', 'ocean', context),
              SizedBox(height:680),

              Text('MINDSPACE', style: title),

              SizedBox(height:50),
              Text('Music',
                  style: GoogleFonts.pacifico(color: Colors.white, fontSize: 36,)
                //  TextStyle(color: Colors.white, fontSize: 26, letterSpacing: 1.0, fontFamily: )
        ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: row('elven', 'memories', 'moment', 'space', context),
              ),
              SizedBox(height:30),
             Text('Podcasts',
               style: GoogleFonts.pacifico(color: Colors.white, fontSize: 36,)),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: row('relax', 'breathe', 'yoga', 'mountain', context),
              ),
              SizedBox(height:30),
              Text('Audiobooks',
                  style: GoogleFonts.pacifico(color: Colors.white, fontSize: 36,)),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: row('Atomic Habits', 'Declutter', 'Possibility', 'Hold Still', context),
              ),
              SizedBox(height:50),
              Opacity(
                opacity: .6,
                child: RaisedButton(
                  elevation: 5,
                  color: Colors.blueGrey,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    onPressed:(){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Preliminary())
                    );
                    },
                    child: Text("Tell us how you feel",
                        style:
                        //TextStyle(color: Colors.white, fontSize: 30, letterSpacing: 5.0, fontWeight: FontWeight.w600),
                        GoogleFonts.pacifico(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w100)
                    )
                ),
              ),
              SizedBox(height:50),
            ],
          ),
        )
      ),
    );
  }
}

class PlayRoute extends StatefulWidget {
  final String sound;
  const PlayRoute({Key key, this.sound}) : super(key: key);
  @override
  _PlayRouteState createState() => _PlayRouteState();
}

class _PlayRouteState extends State<PlayRoute> {
  AudioPlayer player;
  AudioCache cache;
  bool initialPlay = true;
  bool playing;

  @override
  initState() {
    super.initState();
    player = new AudioPlayer();
    cache = new AudioCache(fixedPlayer: player);
  }

  @override
  dispose() {
    super.dispose();
    player.stop();
  }

  playPause(sound) {
    if (initialPlay) {
      cache.play('audio/$sound.mp3');
      playing = true; 
      initialPlay = false;
    }
    return IconButton(
      color: Colors.white70, iconSize: 80.0, icon: playing ? Icon(Icons.pause_circle_filled) : Icon(Icons.play_circle_filled),
      onPressed: () {
        setState(() {
          if (playing) {
            playing = false;
            player.pause();
          } else {
            playing = true;
            player.resume();
          }
        });
      },
    );
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, child: Background(sound: widget.sound)),
          Positioned(top: 0, left: 0, right: 0, child: AppBar(backgroundColor: Colors.transparent, elevation: 0)),
          Padding(padding: const EdgeInsets.only(top: 180.0),
              child: Center(
                  child: Column(children: [Text(widget.sound.toUpperCase(), style: title), playPause(widget.sound)])
              )
          ),
        ],
      ),
    );
  }
}

class Background extends StatefulWidget {
  final String sound;
  const Background({Key key, this.sound}) : super(key: key);
  @override
  _BackgroundState createState() => _BackgroundState();
}


class _BackgroundState extends State<Background> {
  Timer timer;
  bool _visible = false;

  @override
  dispose() {
    timer.cancel();
    super.dispose();
  }

  swap() {
    if (mounted) {
      setState(() { _visible = !_visible;
      });
    }
  }

  @override
  build(BuildContext context) {
    timer = Timer(Duration(seconds: 6), swap);
    return Stack(
      children: [
        Image.asset(img + widget.sound + '_1.jpg'),
        AnimatedOpacity(
            child: Image.asset(img + widget.sound + '_2.jpg'),
            duration: Duration(seconds: 2),
            opacity: _visible ? 1.0 : 0.0)
      ],
    );
  }
}