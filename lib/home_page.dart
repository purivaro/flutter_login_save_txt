import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController controller = TextEditingController();
  String state;
  Future<Directory> _appDocDir;
  final Storage storage = Storage();

  @override
  void initState() {
    super.initState();
    storage.readData().then((String value) {
      setState(() {
        state = value;
      });
    });
  }

  Future<File> writeData() async {
    setState(() {
      state = controller.text;
      controller.text = '';
    });

    return storage.writeData(state);
  }

  void getAppDirectory() {
    setState(() {
      _appDocDir = getApplicationDocumentsDirectory();
    });
  }



  @override
  Widget build(BuildContext context) {
    final alucard = Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircleAvatar(
          radius: 72.0,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/alucard.jpg'),
        ),
      ),
    );

    final welcome = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Welcome $state',
        style: TextStyle(fontSize: 28.0, color: Colors.white),
      ),
    );

    final lorem = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Please enter your name',
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
    );

    final firstname = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'First Name',
        hintStyle: TextStyle(color: Colors.white60),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        
      ),
    );

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.blue,
          Colors.lightBlueAccent,
        ]),
      ),
      child: Column(
        children: <Widget>[
          alucard, 
          welcome, 
          lorem,
          firstname,
          Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: RaisedButton(
              onPressed: writeData,
              child: Text('Write to File', style: TextStyle(color: Colors.black54)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: EdgeInsets.all(12),
              color: Colors.yellowAccent,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: RaisedButton(
              onPressed: getAppDirectory,
              child: Text('Get DIR path', style: TextStyle(color: Colors.white)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: EdgeInsets.all(12),
              color: Colors.lightBlueAccent,
            ),
          ),
          FutureBuilder<Directory>(
            future: _appDocDir,
            builder:
                (BuildContext context, AsyncSnapshot<Directory> snapshot) {
              Text text = Text('');
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  text = Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  text = Text('Path: ${snapshot.data.path}');
                } else {
                  text = Text('Unavailable');
                }
              }
              return new Container(
                child: text,
              );
            },
          ),
        ],
      ),
    );

    return Scaffold(
      body: body,
    );
  }
}



class Storage {
  Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/db.txt');
  }

  Future<String> readData() async {
    try {
      final file = await localFile;
      String body = await file.readAsString();

      return body;
    } catch (e) {
      return e.toString();
    }
  }

  Future<File> writeData(String data) async {
    final file = await localFile;
    return file.writeAsString("$data");
  }
}