import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Meeting.dart';

class JoinMeeting extends StatefulWidget{
  final methodType;
  const JoinMeeting({Key key, this.methodType}) : super(key: key);

  @override
  _JoinMeetingState createState() => _JoinMeetingState();
}

class _JoinMeetingState extends State<JoinMeeting> {
  static final Firestore _db = Firestore.instance;
  var email;
  bool docReady = false;
  var channelId=0;

  @override
  void initState() {
    super.initState();
    waitForConnection();
    //loadSharedPref();
  }



  void waitForConnection() {
    _db.collection('mindspace')
        .snapshots()
        .listen((result) {
      result.documents.forEach((result) {
        if(result.data['docReady']==true)
          setState(() {
            docReady = true;
            channelId = result.data['channelId'];
          });
      });
    });
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waiting Room', style: TextStyle(color: Colors.white,  fontSize: 22.0, letterSpacing: 3.0, fontWeight: FontWeight.w200),),
        backgroundColor: Colors.blueGrey[800],

      ),
      body: Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
    image: DecorationImage(
    image: AssetImage('assets/images/bkgnd_2.jpg'),
    fit: BoxFit.cover)),
    child: docReady? Opacity(
      opacity: .5,
      child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.blue[100],
          child: Center(
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              color: Colors.white,
              padding: EdgeInsets.all(15.0),
              elevation: 6,
              onPressed: () async{
                await _handleCameraAndMic();
                //Fluttertoast.showToast(msg: '${widget.methodType}, $channelId,  $email',toastLength: Toast.LENGTH_LONG);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Meeting(
                      channelId: channelId,
                      channelName: 'test',
                    ),
                  ),
                );
              },
              child: Text('Join Meeting',
                style: TextStyle(color: Colors.blue[900],fontSize: 20.0),),
            ),
          ),
        ),
    ):
      Opacity(
        opacity: .5,
        child: Container(
          color: Colors.blue[100],
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 25),
                child: Text("Waiting for doctor to start the session",style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0
                ),),
              )
            ],
          ),
        ),
      ),
    )
    );

  }
}