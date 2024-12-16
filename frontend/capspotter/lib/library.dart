import 'package:flutter/material.dart';
import 'database_helper.dart';

class BrowseSpeciesPage extends StatefulWidget {
  @override
  _BrowseSpeciesPageState createState() => _BrowseSpeciesPageState();
}

class _BrowseSpeciesPageState extends State<BrowseSpeciesPage> {
  List<Map<String, dynamic>> mushrooms = [];

  @override
  void initState() {
    super.initState();
    _fetchMushrooms();
  }

  Future<void> _fetchMushrooms() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    List<Map<String, dynamic>> data = await dbHelper.getMushrooms();
    setState(() {
      mushrooms = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mushrooms.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: mushrooms.length,
              itemBuilder: (context, index) {
                final mushroom = mushrooms[index];
                return GestureDetector(
                  onTap: () => _showMushroomDetails(context, mushroom),
                  child: Card(
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0),
                            ),
                            child: Image.asset(
                              'assets/images/${mushroom['imagePath1']}',
                              fit: BoxFit
                                  .fitHeight, // zmienic
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            mushroom['name_latin'],
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showMushroomDetails(
      BuildContext context, Map<String, dynamic> mushroom) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(mushroom['name_latin']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              child: Image.asset(
                'assets/images/${mushroom['imagePath1']}',
                fit: BoxFit.fill, // zmienic
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              child: Image.asset(
                'assets/images/${mushroom['imagePath2']}',
                fit: BoxFit.fill, // zmienic
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Zamknij'),
          ),
        ],
      ),
    );
  }
}
