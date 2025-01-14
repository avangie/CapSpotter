import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'take_photo.dart';
import 'pick_photo.dart';
import 'library.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  runApp(const CapSpotterApp());
}

class CapSpotterApp extends StatelessWidget {
  const CapSpotterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CapSpotter',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        scaffoldBackgroundColor: const Color.fromRGBO(246, 252, 223, 1),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/appicon.png',
                  height: 120,
                  key: const Key('appIcon'),
                ),
                const SizedBox(height: 20),
                const Text(
                  'CapSpotter',
                  style: TextStyle(
                    fontFamily: 'SourGummy',
                    fontSize: 48,
                    color: Color.fromRGBO(49, 81, 30, 1),
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: 210,
                  height: 110,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TakePhotoPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: const Color.fromRGBO(133, 159, 61, 1),
                      elevation: 10,
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
                          style: TextStyle(fontSize: 12, color: Colors.white),
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
                            builder: (context) => const PickFromGalleryPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: const Color.fromRGBO(133, 159, 61, 1),
                      elevation: 10,
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
                          style: TextStyle(fontSize: 12, color: Colors.white),
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
                            builder: (context) => const BrowseSpeciesPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: const Color.fromRGBO(133, 159, 61, 1),
                      elevation: 10,
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
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
