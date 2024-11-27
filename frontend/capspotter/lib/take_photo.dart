import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NextPage extends StatefulWidget {
  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _image = File(photo.path);
      });
    }
  }

  Future<void> _chooseFromGallery() async {
    final XFile? galleryImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (galleryImage != null) {
      setState(() {
        _image = File(galleryImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment
                .center, // Umieszcza elementy wertykalnie w centrum
            crossAxisAlignment: CrossAxisAlignment
                .center, // Umieszcza elementy poziomo w centrum
            children: [
              const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center, // Wyrównanie tekstu do środka
              ),
              const SizedBox(height: 20),
              if (_image != null)
                Image.file(
                  _image!,
                  height: 200,
                ),
              ElevatedButton(
                onPressed: () {
                  _showImageSourceDialog(context);
                },
                child: const Text('Take a photo or choose from gallery'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Image Source"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _takePhoto();
              },
              child: const Text("Camera"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _chooseFromGallery();
              },
              child: const Text("Gallery"),
            ),
          ],
        );
      },
    );
  }
}
