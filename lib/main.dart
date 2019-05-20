import 'dart:convert';

import 'dart:io';

import 'package:file_share/pages/qrPage.dart';

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';

import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';

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
  String fileName = 'testing.txt';
  String data = '';

  //This function read the qr code and decode it.
  Future decode(File pickedImage) async {
    FirebaseVisionImage img = FirebaseVisionImage.fromFile(pickedImage);
    BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector();

    List barCodes = await barcodeDetector.detectInImage(img);

    for (Barcode code in barCodes) {
      setState(() {
        data = code.displayValue;
      });
    }
    print(data);
  }

  //This function gets an image from the gallery < a photo of the QR code to scan >
  Future _getImage() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    ); //open galley

    setState(() {
      _image = image; //sets the variable with the image you picked.
      decode(image);
    });
  }

  //This function gets the app local path.
  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();
    print(directory.path);
    return directory.path;
  }

  //This function gets the file local path.
  Future<File> get _localFile async {
    String file = fileName;
    final path = await _localPath;
    print('Path : $path');
    return File('$path/Download/$file');
  }

  //This Function write data to the file.
  Future writeFile(String txt) async {
    final file = await _localFile;

    // Write the file
    file.writeAsStringSync(
      txt,
      mode: FileMode.write,
      encoding: utf8,
    );
  }

  //This function opens a <Text file for the moment> file and read its content.
  Future _getFiles() async {
    File temp = await FilePicker.getFile(
      type: FileType.CUSTOM,
      fileExtension: 'txt',
    ); //open file

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QRPage(
              data: temp.readAsStringSync(), //read file content
            ),
      ),
    );

//    writeFile();
//    print('Stattus: Done');
  }

  //This function reads data from the file.
  Future readFile() async {
    try {
      final file = await _localFile;

      // Read the file
      String content = await file.readAsString();

      print('File content: $content');
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
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
            data == null ? Text('') : Text(data),
            SizedBox(height: 25),
            _image != null
                ? Image.file(
                    _image,
                    width: 200,
                    height: 200,
                  )
                : Container(),
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
                RaisedButton(
                  onPressed: readFile,
                  child: Text('Read file'),
                ),
                data == null
                    ? Container()
                    : RaisedButton(
                        onPressed: () => writeFile(data),
                        child: Text('Write file'),
                      ),
              ],
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
