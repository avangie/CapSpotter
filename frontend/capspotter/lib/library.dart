import 'package:flutter/material.dart';

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
