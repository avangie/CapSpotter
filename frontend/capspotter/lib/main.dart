import 'package:flutter/material.dart';
import 'take_photo.dart'; // Import podstrony z obsługą zdjęć

void main() {
  runApp(CapSpotterApp());
}

class CapSpotterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CapSpotter',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        scaffoldBackgroundColor:
            const Color.fromRGBO(246, 252, 223, 1), // RGB color
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'CapSpotter',
              style: TextStyle(
                fontFamily: 'SourGummy',
                fontSize: 48,
                color: Color.fromRGBO(49, 81, 30, 1),
              ),
            ),
            const SizedBox(
                height: 50), // Przerwa między nagłówkiem a przyciskami
            SizedBox(
              width: 210,
              height: 110,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NextPage()), // Nawigacja do podstrony NextPage
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: const Color.fromRGBO(133, 159, 61, 1),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageIcon(
                      AssetImage("assets/camera.png"),
                      size: 50,
                      color: Colors.white,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Zrób zdjęcie',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 210,
              height: 110,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NextPage()), // Nawigacja do podstrony NextPage
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: const Color.fromRGBO(133, 159, 61, 1),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageIcon(
                      AssetImage("assets/photos.png"),
                      size: 50,
                      color: Colors.white,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Wybierz zdjęcie z galerii',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 210,
              height: 110,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BrowseSpeciesPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: const Color.fromRGBO(133, 159, 61, 1),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageIcon(
                      AssetImage("assets/book.png"),
                      size: 50,
                      color: Colors.white,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Przeglądaj gatunki',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder pages for navigation
class BrowseSpeciesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Przeglądaj gatunki'),
      ),
      body: const Center(
        child: Text('Tutaj będzie lista gatunków grzybów'),
      ),
    );
  }
}
