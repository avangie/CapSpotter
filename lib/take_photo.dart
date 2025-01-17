import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'model.dart';
import 'dart:typed_data';

class TakePhotoPage extends StatefulWidget {
  const TakePhotoPage({super.key});

  @override
  _TakePhotoPageState createState() => _TakePhotoPageState();
}

class _TakePhotoPageState extends State<TakePhotoPage> {
  final ImagePicker _picker = ImagePicker();
  img.Image? _image;

  Future<void> _openCamera() async {
    final cameraPermission = await Permission.camera.request();

    if (cameraPermission.isGranted) {
      try {
        final XFile? photo =
            await _picker.pickImage(source: ImageSource.camera);
        if (photo != null) {
          final imageFile = File(photo.path);
          final imageBytes = await imageFile.readAsBytes();
          final image = img.decodeImage(Uint8List.fromList(imageBytes));

          setState(() {
            _image = image;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Wystąpił błąd przy otwieraniu kamery: $e")),
        );
      }
    } else if (cameraPermission.isDenied ||
        cameraPermission.isPermanentlyDenied) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Uprawnienia wymagane'),
            content: const Text(
              'Aby korzystać z aplikacji w pełni, musisz udzielić zgody na dostęp do kamery. '
              'Możesz zmienić ustawienia w swoim telefonie.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _goToNextPage() {
    if (_image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(image: _image!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context)
                .size
                .height,
          ),
          child: Center(
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
                          '• Upewnij się, że grzyb jest w centrum kadru.',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '• Ważne, aby zdjęcie było wyraźne i dobrze przedstawiało grzyba.',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '• Zadbaj o odpowiednie oświetlenie.',
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
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.55,
                            maxWidth: MediaQuery.of(context).size.width * 0.95,
                          ),
                          child: Image.memory(
                            Uint8List.fromList(img.encodeJpg(_image!)),
                            fit: BoxFit.cover,
                            height: 300,
                            width: 300,
                          ),
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: Text(
                        'Nie dodano zdjęcia',
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _openCamera,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      backgroundColor: const Color.fromRGBO(133, 159, 61, 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/camera.png',
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Zrób zdjęcie',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _image != null ? _goToNextPage : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
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
        ),
      ),
    );
  }
}
