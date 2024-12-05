import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PickFromGalleryPage extends StatefulWidget {
  @override
  _PickFromGalleryPageState createState() => _PickFromGalleryPageState();
}

class _PickFromGalleryPageState extends State<PickFromGalleryPage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  @override
  void initState() {
    super.initState();
    _openGallery();
  }

  Future<void> _openGallery() async {
    try {
      final XFile? galleryImage =
          await _picker.pickImage(source: ImageSource.gallery);
      if (galleryImage != null) {
        setState(() {
          _image = File(galleryImage.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Wystąpił błąd przy otwieraniu galerii: $e")),
      );
    }
  }

  void _goToNextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Placeholder()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(133, 159, 61, 1),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ważne wskazówki dotyczące zdjęcia:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• Wybierz zdjęcie, na którym grzyb jest wyraźnie widoczny.',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '• Zadbaj o to, by grzyb był w centrum zdjęcia.',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '• Upewnij się, że zdjęcie jest odpowiednio doświetlone.',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_image != null)
                Container(
                  padding: const EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.55,
                        maxWidth: MediaQuery.of(context).size.width * 0.95,
                      ),
                      child: Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              if (_image == null) const SizedBox(height: 200),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _openGallery,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  backgroundColor: const Color.fromRGBO(133, 159, 61, 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/photos.png',
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Wybierz z galerii',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _image != null ? _goToNextPage : null,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  backgroundColor: const Color.fromRGBO(49, 81, 30, 1),
                  disabledBackgroundColor: Colors.grey[400],
                ),
                child: const Text(
                  'Prześlij',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
