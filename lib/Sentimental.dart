import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'API.dart';
import 'firebaseDB/firestoreDB.dart';

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
  var sentimentalSum=0.0;
  var totalSum=0.0;
  var disorderCollection;
  var email;

  @override
  void initState() {
    super.initState();
    _getList();
    loadSharedPref();
  }

  void loadSharedPref() async{
    final prefs = await SharedPreferences.getInstance();
    var tempEmail = prefs.getString('email') ?? 'null';
    if(tempEmail!='null') {
      email = tempEmail;
    }
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
    var tempSum =0;
    for(int i=0;i<2;i++) {
      var data = await getDataResult(
          'http://alanta335.pythonanywhere.com/api?Query=' + result[i]);
      var decodedData = jsonDecode(data);
      var queryText = decodedData['Query'];
      var resultSent = int.parse(queryText);
      tempSum += resultSent;
    }
    tempSum -= 2;
    tempSum *= -1;
    sentimentalSum = tempSum/4.0;
    totalSum = (widget.previousSum + sentimentalSum)/2.0;
    print('total: $totalSum');
    if (totalSum > 0.5 && totalSum <= 0.65) {
      disorderCollection = "anxiety";
    }

    else if (totalSum > 0.65 && totalSum <= 0.8) {
      disorderCollection = "depression";
    }


    else if (totalSum > 0.8 && totalSum <= 1) {
      disorderCollection = "aggression";
    }
    if(totalSum > 0.5){
      /*bool prime = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Severity(
            disorder: disorderCollection,
          ),
        ),
      ) ?? false;
      if(prime == true){

        Navigator.pop(context,true);
      }*/
    }
    else{
      FireStoreClass.pushResultDB(result: totalSum,email: email,normality: 'normal');
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('primaryAnalysis', true);
      prefs.setString('question', 'sent');
      prefs.setDouble('result', totalSum);
      Navigator.pop(context,true);
    }

  }

  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Preliminary'),
      backgroundColor: Colors.lightBlue,),
      body: ready? Center(
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
                  child: Card(
                    color: Colors.blue[100],
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
                              child: Text('${list[i]}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,),
                            ),
                            SizedBox(height: 20,),
                            TextField(
                              cursorColor: Colors.blue[900],
                              textCapitalization: TextCapitalization.sentences,
                              controller: textController,
                              maxLines: 5,
                              textInputAction: TextInputAction.newline,
                              onChanged: (text){
                                result[i]=text;
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter your answer here',
                                labelText: 'Your Answer',
                                labelStyle: TextStyle(color: Colors.black),
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
                );
              },
            ),
          ),
        ),
      ):Container(
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
              child: Text("Loading",style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 18.0
              ),),
            )
          ],
        ),
      ),
    );
  }

}