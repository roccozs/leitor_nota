import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8;
import 'dart:convert';
//import 'package:http/http.dart';

void main() => runApp(new CameraApp());

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  File image;
  String textoOcr = "";
//  To use Gallery or File Manager to pick Image
//  Comment Line No. 19 and uncomment Line number 20
  picker() async {
    textoOcr = "";
    print('Picker is called');
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
//    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      image = img;
      upload(image);

      setState(() {});
    }
  }

  upload(File imageFile) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse('http://bolinhabolinha.com/ocr/upload.php');

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('image', stream, length,
        // filename: context.basename(imageFile.path));
        filename: imageFile.path);
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    postData();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  postData() async {
    var url =
        "https://vision.googleapis.com/v1/images:annotate?key=AIzaSyAdQOg_mVDRSQ0ohqqM6aUJC_F4RDnlQFQ";

    var body =
        '{ "requests": [ { "image": { "source": { "imageUri": "https://bolinhabolinha.com/ocr/teste.jpg"  }  }, "features": [  {  "type": "TEXT_DETECTION",  "maxResults": 1 },   ]  } ]}';

    http.post(url, body: body).then((response) {
//  print("Response status: ${response.statusCode}");
//  print("Response body: ${response.body}");
      //Map decodedMap = json.decode(response.body);
      Map texto = json.decode(response.body);
      textoOcr = texto['responses'][0]['textAnnotations'][0]['description'];
//print('===============> ${texto['responses'][0]['textAnnotations'][0]['description']}!');
      print("===============> $textoOcr ");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Leitor de Nota MilAte2019'),
        ),
        body: new Container(
          child: new Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                image == null ? Text('Nenhuma Imagem') : new Image.file(image),
                textoOcr == ""
                    ? Text("Nenhum texto Teconhecido")
                    : Text(textoOcr)
              ])),
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: picker,
          child: new Icon(Icons.camera_alt),
        ),
      ),
    );
  }
}
