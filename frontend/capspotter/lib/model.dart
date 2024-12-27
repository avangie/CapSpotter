import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

class ResultPage extends StatelessWidget {
  final img.Image image;

  const ResultPage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wyniki analizy")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.memory(
              Uint8List.fromList(img.encodeJpg(image)),
              height: 300,
              width: 300,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Tutaj dodaj logikę przetwarzania obrazu i analizy (np. użycie TensorFlow Lite)
              },
              child: const Text('Przetwórz obraz'),
            ),
          ],
        ),
      ),
    );
  }
}
