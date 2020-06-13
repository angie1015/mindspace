import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AgoraFiles/JoinMeeting.dart';

class Appointment extends StatefulWidget{
  final String method;
  const Appointment({Key key, this.method}) : super(key: key);

  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  static final Firestore _db = Firestore.instance;
  var dbRef = _db.collection('user_email').document('test@gmail.com');
  var _showAppointment =false;
  bool doctorAppointed=false;
  bool _appointButton=true;
  var dbAppointment = false;
  var appointment=false;
  var streamVariable;
  var tempAppt;
  var docName;
  var stream;
  var docID;
  var email;
  var time;
  var name;


  @override
  void initState() {
    super.initState();
    loadSharedPref();
    loadAppointment();
    fetchData();

  }


  void fetchData(){

    _db.collection('appointment')
        .snapshots()
        .listen((result) {   // Listens to update in appointment collection
      result.documents.forEach((f) {

        /*if(f.data['email']==email){*/
          docID = f.documentID;
          tempAppt = f.data['appointment'] ?? false;
        //}
        dbAppointment = tempAppt;
        if(appointment==true|| dbAppointment==true){
          setState(() {
            _appointButton=false;
            _showAppointment=true;
          });
        }
      });
    });

   /* _db
        .collection("appointment")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        if(f.data['email']==email){
          docID = f.documentID;
          tempAppt = f.data['appointment'] ?? false;
        }
        dbAppointment = tempAppt;
        if(appointment==true|| dbAppointment==true){
          setState(() {
            _appointButton=false;
            _showAppointment=true;
          });
        }
      });
    });*/
  }

  void loadAppointment(){
    stream = _db.collection('appointment')
        .snapshots()
        .listen((result) {   // Listens to update in appointment collection
      result.documents.forEach((result) {
        if(/*result.data['email']==email &&*/ result.data['appointment']==true){
          setState(() {
            doctorAppointed = true;
            docName = result.data['docName'];
            time = result.data['time'];
          });
        }
        if(/*result.data['email']==email && */result.data['appointment']==false){
          setState(() {
            doctorAppointed = false;
          });
        }
      });
    });

  }

  void loadSharedPref() async{
    final prefs = await SharedPreferences.getInstance();
    var tempEmail = prefs.getString('email') ?? 'null';
    var tempName = prefs.getString('name') ?? 'null';
    appointment = prefs.getBool('appointment') ?? false;
    if(tempEmail!='null') {
      setState(() {
        email = tempEmail;
        streamVariable = Firestore.instance.collection('user_email').document(email).collection('pastHistory').snapshots();
      });
    }
    if(tempName!='null') {
      setState(() {
        name = tempName;
      });
    }

  }

  void _getAppointment()async{
    setState(() {
      _appointButton = false;
      _showAppointment = true;
    });
    await _db.collection('appointment').document(docID).updateData({
      'name': name,
      'email': email,
      'appointment': false,
      'docReady': false,
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('appointment', true);
  }

  Widget showAppointmentWidget(){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: double.infinity,
        height: 80,
        color: Colors.blue[800],
        child: doctorAppointed?
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Doctor: $docName',style: TextStyle(color: Colors.white,fontSize: 19),),
                  Text('Time: $time',style: TextStyle(color: Colors.white),),
                ],
              ),
            ),
            MaterialButton(
              child: Icon(
                widget.method=='audio' ? Icons.call:Icons.video_call,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: (){
                stream.cancel();  // cancels the listening of the FireStore Changes
                streamVariable = null;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JoinMeeting(
                      methodType: widget.method,
                    ),
                  ),
                );
              },
              minWidth: 0,
            )
          ],
        )
        :Center(child: Text("Awaiting Doctor's Timing!",style: TextStyle(color: Colors.white,fontSize: 19),)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('Appointment'),
      ),
      body: Container(
        color: Colors.blue[100],
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              color: Colors.yellow,
              width: double.infinity,
              child: Text(
                '400+ Doctors Available',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                color: Colors.white,
                padding: EdgeInsets.all(15.0),
                elevation: 6,
                disabledColor: Colors.black,
                disabledTextColor: Colors.grey,
                textColor: Colors.blue[900],
                onPressed: _appointButton? _getAppointment: null,
                child: Text('Get Appointment',style: TextStyle(fontSize: 20.0),),
              ),
            ),
            _showAppointment ? showAppointmentWidget(): SizedBox(height: 0,),

          ],
        ),
      ),
    );
  }
}