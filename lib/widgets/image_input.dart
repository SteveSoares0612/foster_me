import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as systemPaths;

class ImageInput extends StatefulWidget {
  Function useImage;
  ImageInput(this.useImage);
  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _chosenImage;

  Future<void> _ChoosePicture() async {
    final Ipicker = ImagePicker();
    final imageFile = await Ipicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    ); //Choosing Image file
    setState(() {
      _chosenImage = File(imageFile.path);
      print(_chosenImage); //Converting file to String source
    });
    final appDir = await systemPaths.getApplicationDocumentsDirectory();
    final filename = path.basename(_chosenImage.path);
    final savedImage = await _chosenImage.copy('${appDir.path}/${filename}');
    widget.useImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                "Choose a Profile Image",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        CircleAvatar(
          radius: 80,
          backgroundColor: Colors.black,
          child: CircleAvatar(
            radius: 78,
            backgroundColor: Colors.white,
            backgroundImage:
                _chosenImage != null ? FileImage(_chosenImage) : null,
          ),
        ),
        // Container(
        //   height: 160,
        //   alignment: Alignment.center,
        //   decoration: BoxDecoration(
        //     border: Border.all(width: 1),
        //   ),
        //   child: _chosenImage != null
        //       ? Image.file(
        //           _chosenImage,
        //           fit: BoxFit.cover,
        //         )
        //       : Text(
        //           'No Image Found',
        //           textAlign: TextAlign.center,
        //         ),
        // ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: TextButton.icon(
                icon: Icon(Icons.image, color: Theme.of(context).primaryColor),
                label: Text(
                  "Choose Image",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: _ChoosePicture,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
