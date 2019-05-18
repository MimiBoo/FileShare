import 'dart:io';

import 'package:file_share/pages/qrPage.dart';

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';

import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Share',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: MyHomePage(title: 'File Share'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;

  //This function gets an image from the gallery < a photo of the QR code to scan >
  Future _getImage() async {
    var image =
        await ImagePicker.pickImage(source: ImageSource.gallery); //open galley

    setState(() {
      _image = image; //sets the variable with the image you picked.
    });
  }

  //This function opens a <Text file for the moment> file and read its content.
  Future _getFiles() async {
    File temp = await FilePicker.getFile(
        type: FileType.CUSTOM, fileExtension: 'txt'); //open file

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QRPage(
              data: temp.readAsStringSync(), //read file content
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  onPressed: _getImage,
                  child: Text('Recive File'),
                ),
                RaisedButton(
                  onPressed: _getFiles,
                  child: Text('Send File'),
                ),
              ],
            ),
            SizedBox(height: 25),
            _image != null
                ? Image.file(
                    _image,
                    width: 200,
                    height: 200,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
