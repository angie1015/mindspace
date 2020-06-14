import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Sentimental.dart';

const title = TextStyle(color: Colors.white, fontSize: 36, letterSpacing: 13.0, fontWeight: FontWeight.w600);
// A screen that allows users to take a picture using a given camera.
class Preliminary extends StatefulWidget {
  @override
  PreliminaryState createState() => PreliminaryState();
}

class PreliminaryState extends State<Preliminary> {
  //String predictURL = "http://replica-alpha.herokuapp.com/predict";
  //Future<void> _initializeControllerFuture;
  int _radioMCQ = 0;
  var result = new List(6);
  var count = 0;
  final databaseReference = Firestore.instance;
  var list = [];
  var sumResult = 0.0;
  bool ready = false;
  

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.

    _getList();
    //loadSharedPref();
  }



  Future<void> _getList() async {
    count = 0;
    await databaseReference
        .collection('questions')
        .limit(6)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        list.add(f.data['quest']);
        count++;
      });
    });
    setState(() {
      ready = true;
    });
  }

  void _handleRadioValueChange1(int value) async {
    setState(() {
      _radioMCQ = value;
    });
    result[_index] = value;
  }

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Preliminary',
        style: TextStyle(color: Colors.white,  fontSize: 24.0, letterSpacing: 5.0, fontWeight: FontWeight.w200),), backgroundColor: Colors.blueGrey[800],),
        backgroundColor: Colors.blueGrey,
        // Wait until the controller is initialized before displaying the
        // camera preview. Use a FutureBuilder to display a loading spinner
        // until the controller has finished initializing.
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/bkgnd_2.jpg'),
                  fit: BoxFit.cover)),
          child: ready
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height:
                          MediaQuery.of(context).size.height, // card height
                      child: PageView.builder(
                        itemCount: 6,
                        controller: PageController(viewportFraction: 1),
                        onPageChanged: (int index) => setState(() {
                          _index = index;
                          _radioMCQ = -1;
                          if (result[_index] != 0) {
                            setState(() {
                              _radioMCQ = result[_index];
                            });
                          }
                        }),
                        itemBuilder: (_, i) {
                          return Transform.scale(
                            scale: i == _index ? 1 : 0.9,
                            child: Opacity(
                              opacity: .5,
                              child: Card(
                                color: Colors.blueGrey[400],
                                elevation: 6,
                                shape: RoundedRectangleBorder(

                                    borderRadius: BorderRadius.circular(20)),
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 18.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 12.0),
                                          child: Text(
                                            '${list[i]}',
                                            style: GoogleFonts.pacifico(color: Colors.white, letterSpacing: 2.0, fontSize: 36, ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Divider(
                                          thickness: 1,
                                          color: Colors.white,
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              _handleRadioValueChange1(1),
                                          child: Row(
                                            children: <Widget>[
                                              new Radio(
                                                activeColor: Colors.blueGrey[800],
                                                value: 1,
                                                groupValue: _radioMCQ,
                                                onChanged:
                                                    _handleRadioValueChange1,
                                              ),
                                              new Text(
                                                'STRONGLY AGREE',
                                                style: TextStyle(color: Colors.white,  fontSize: 24.0, letterSpacing: 5.0, fontWeight: FontWeight.w200),
                                               // new TextStyle(fontSize: 16.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              _handleRadioValueChange1(2),
                                          child: Row(
                                            children: <Widget>[
                                              new Radio(
                                                activeColor: Colors.blueGrey[800],
                                                value: 2,
                                                groupValue: _radioMCQ,
                                                onChanged:
                                                    _handleRadioValueChange1,
                                              ),
                                              new Text(
                                                'AGREE',
                                                style: TextStyle(color: Colors.white,  fontSize: 24.0, letterSpacing: 5.0, fontWeight: FontWeight.w200),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              _handleRadioValueChange1(4),
                                          child: Row(
                                            children: <Widget>[
                                              new Radio(
                                                activeColor: Colors.blueGrey[800],
                                                value: 4,
                                                groupValue: _radioMCQ,
                                                onChanged:
                                                    _handleRadioValueChange1,
                                              ),
                                              new Text(
                                                'UNDECIDED',
                                                style: TextStyle(color: Colors.white,  fontSize: 24.0, letterSpacing: 5.0, fontWeight: FontWeight.w200),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              _handleRadioValueChange1(7),
                                          child: Row(
                                            children: <Widget>[
                                              new Radio(
                                                activeColor: Colors.blueGrey[800],
                                                value: 7,
                                                groupValue: _radioMCQ,
                                                onChanged:
                                                    _handleRadioValueChange1,
                                              ),
                                              new Text(
                                                'DISAGREE',
                                                style: TextStyle(color: Colors.white,  fontSize: 24.0, letterSpacing: 5.0, fontWeight: FontWeight.w200),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        if (i == 5)
                                          Center(
                                            child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                              ),
                                              color: Colors.white,
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'Next',
                                                style: TextStyle(
                                                    color: Colors.blue[900],
                                                    fontSize: 20.0),
                                              ),
                                              onPressed: () async {
                                                //http.Response response = await http.get(predictURL);
                                                //data = response.body;
                                                //print('xperion $data');
                                                //var decodedData = jsonDecode(data);
                                                //print( '${decodedData['Query']} mxyzptlk');

                                                await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Sentimental(

                                                            ),
                                                          ),
                                                        );


                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              : Container(
                  color: Colors.blue[100],
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 25),
                        child: Text(
                          "Loading",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 18.0),
                        ),
                      )
                    ],
                  ),
                ),
        ));
  }
}
