import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/Image_Input.dart';
import 'package:tflite/tflite.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class DetermineBreed extends StatefulWidget {
  static const routeName = '/determinePet';

  @override
  State<DetermineBreed> createState() => _DetermineBreedState();
}

class _DetermineBreedState extends State<DetermineBreed> {
  PickedFile _chosenImage;
  bool _loading = false;
  List<dynamic> _outputs;

  String _label = 'Not Found';
  String _Printlabel = 'Not Found';
  String _URLlabel;
  final ImagePicker _picker = ImagePicker();

  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  //Load the Tflite model
  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  classifyImage(image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _loading = false;
      //Declare List _outputs in the class which will be used to show the classified classs name and confidence
      _outputs = output;
      _label = _outputs[0]["label"];
      _Printlabel = _label.replaceAll(RegExp('[0-9]'), "").trim();
      _URLlabel = _Printlabel.replaceAll(RegExp(' '), "-").toLowerCase();
      String german = "german-shepherd";

      if (_URLlabel == german) {
        _URLlabel = "german-shepherd-dog";
      }
      print(_URLlabel);
    });
  }

  Future<void> _optiondialogbox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text(
                      "Camera",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    onTap: openCamera,
                  ),
                  Padding(padding: EdgeInsets.all(10.0)),
                  GestureDetector(
                    child: Text(
                      "Choose image ",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    onTap: openGallery,
                  )
                ],
              ),
            ),
          );
        });
  }

  Future openCamera() async {
    var image = await _picker.getImage(source: ImageSource.camera);

    setState(() {
      _chosenImage = image;
    });
    classifyImage(_chosenImage);
  }

  //camera method
  Future openGallery() async {
    var image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _chosenImage = image;
    });
    classifyImage(_chosenImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Classification'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _loading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: <Widget>[
                          Container(
                            width: 350,
                            height: 270,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _chosenImage != null
                                ? Image.file(
                                    File(_chosenImage.path),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  )
                                : Text(
                                    'No Image Found',
                                    textAlign: TextAlign.center,
                                  ),
                            alignment: Alignment.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.camera),
                              label: Text('Choose Picture'),
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                              ),
                              onPressed: _optiondialogbox,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: _outputs != null
                                ? Row(
                                    children: [
                                      Text("Breed: ",
                                          style: TextStyle(
                                            fontSize: 22,
                                          )),
                                      Text(
                                        _Printlabel,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ],
                                  )
                                : Text("NOT FOUND",
                                    style: TextStyle(fontSize: 22)),
                          ),
                          // Text("HELLO")
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: ElevatedButton.icon(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).primaryColor),
                              ),
                              onPressed: _outputs != null
                                  ? () async {
                                      final url =
                                          'https://dogtime.com/dog-breeds/$_URLlabel#/slide/1';
                                      try {
                                        await launch(url,
                                            forceWebView: true,
                                            enableJavaScript: true);
                                      } catch (e) {
                                        print(e);
                                      }
                                    }
                                  : null,
                              icon: Icon(Icons.info),
                              label: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Text("Learn about ",
                                          style: TextStyle(
                                            fontSize: 18,
                                          )),
                                      Text(
                                        _Printlabel,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                          // Text("HELLO")
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
