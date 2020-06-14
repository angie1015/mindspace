import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindspace/AgoraFiles/JoinMeeting.dart';

TextStyle question =  GoogleFonts.pacifico(color: Colors.white, letterSpacing: 2.0, fontSize: 26 );


class Sentimental extends StatefulWidget {
  final double previousSum;
  const Sentimental({Key key, this.previousSum}) : super(key: key);

  @override
  _SentimentalState createState() => _SentimentalState();
}

class _SentimentalState extends State<Sentimental> {
  var result = new List(2);
  var count=0;
  var list = [];
  var sumResult=0.0;
  var ready = false;
  final databaseReference = Firestore.instance;
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getList();
  }




  Future<void> _getList() async{
    count =0;
    await databaseReference
        .collection('sentimental')
        .limit(2)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        list.add(f.data['quest']);
        count++;
      });
    });
    setState(() {
      ready=true;
    });
  }


  void getSentimentalResult() async{
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JoinMeeting(),
        ),
      );

  }

  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sentimental',
        style:  TextStyle(color: Colors.white,  fontSize: 22.0, letterSpacing: 3.0, fontWeight: FontWeight.w200),),
      backgroundColor: Colors.blueGrey[800],),
      body: Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
    image: DecorationImage(
    image: AssetImage('assets/images/bkgnd_2.jpg'),
    fit: BoxFit.cover)),
    child: ready? Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height, // card height
            child: PageView.builder(
              itemCount: 2,
              controller: PageController(viewportFraction: 1),
              onPageChanged: (int index) => setState(() {
                _index = index;
                textController.clear();
                if(result[_index]!=null){
                  setState(() {
                    textController.text = result[_index];
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 12.0),
                                child: Text('${list[i]}',style: question,
                                //TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,),
                              ),
                              SizedBox(height: 20,),
                              TextField(
                                cursorColor: Colors.blue[900],
                                style: TextStyle(color: Colors.white, fontSize: 20),
                                textCapitalization: TextCapitalization.sentences,
                                controller: textController,
                                maxLines: 5,
                                textInputAction: TextInputAction.newline,
                                onChanged: (text){
                                  result[i]=text;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter your answer here',
                                  hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                                  labelText: 'YOUR ANSWER',
                                  labelStyle: TextStyle(color: Colors.white,  fontSize: 20.0, letterSpacing: 5.0, fontWeight: FontWeight.w200),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue[900]),
                                    borderRadius: BorderRadius.circular(25.7),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue[900]),
                                    borderRadius: BorderRadius.circular(25.7),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              if (i==1) Center(
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                  color: Colors.white,
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Next',style: TextStyle(color: Colors.blue[900],fontSize: 20.0),),
                                  onPressed: getSentimentalResult,
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
      ):Container(
        color: Colors.blueGrey[200],
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              backgroundColor: Colors.blueGrey[500],

            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 25),
              child: Text("Loading",style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 24.0
              ),),
            )
          ],
        ),
      ),
    ));
  }

}