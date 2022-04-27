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
        title: const Text('Smart Breed Finder'),
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
                      Text(
                        "The Smart Breed Finder allows you to find the breed of a dog if your unaware of it. Get right to it by picking an image of a Dog!",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Note: This feature only works on dog breeds.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey, fontStyle: FontStyle.italic),
                      ),
                      SizedBox(
                        height: 20,
                      ),
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
                                    style: TextStyle(color: Colors.grey),
                                  ),
                            alignment: Alignment.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: ElevatedButton.icon(
                              icon: Icon(
                                Icons.camera,
                                color: Theme.of(context).primaryColor,
                              ),
                              label: Text(
                                'Choose Picture',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                side: BorderSide(
                                    width: 2,
                                    color: Theme.of(context).primaryColor),
                              ),
                              onPressed: openGallery,
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
                                : Text("Please pick and image",
                                    style: TextStyle(fontSize: 19)),
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
