import 'package:flutter/material.dart';
import 'database_helper.dart';

class BrowseSpeciesPage extends StatefulWidget {
  const BrowseSpeciesPage({super.key});

  @override
  _BrowseSpeciesPageState createState() => _BrowseSpeciesPageState();
}

class _BrowseSpeciesPageState extends State<BrowseSpeciesPage> {
  List<Map<String, dynamic>> allMushrooms = [];
  List<Map<String, dynamic>> filteredMushrooms = [];
  bool? filterEdibility;

  @override
  void initState() {
    super.initState();
    _fetchMushrooms();
  }

  Future<void> _fetchMushrooms() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    List<Map<String, dynamic>> data = await dbHelper.getMushrooms();
    setState(() {
      allMushrooms = data;
      filteredMushrooms = List.from(allMushrooms);
    });
  }

  void _filterMushrooms(bool? edible) {
    setState(() {
      filterEdibility = edible;
      if (edible != null) {
        filteredMushrooms = allMushrooms.where((mushroom) {
          return mushroom['isEdible'] == (edible ? 1 : 0);
        }).toList();
      } else {
        filteredMushrooms = List.from(allMushrooms);
      }
    });
  }

  void _sortMushroomsAlphabetically() {
    setState(() {
      filteredMushrooms = List.from(filteredMushrooms)
        ..sort((a, b) => a['name_polish'].compareTo(b['name_polish']));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: filteredMushrooms.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: filteredMushrooms.length,
              itemBuilder: (context, index) {
                final mushroom = filteredMushrooms[index];
                return GestureDetector(
                  onTap: () => _showMushroomDetails(context, mushroom),
                  child: Card(
                    color: const Color.fromRGBO(133, 159, 61, 1),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12.0),
                              topRight: Radius.circular(12.0),
                            ),
                            child: Image.asset(
                              'assets/images/${mushroom['imagePath1']}',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            mushroom['name_polish'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _showFilterDialog(context),
            heroTag: 'filterButton',
            backgroundColor: const Color.fromRGBO(133, 159, 61, 1),
            foregroundColor: Colors.white,
            child: const Icon(Icons.filter_list),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _sortMushroomsAlphabetically,
            heroTag: 'sortButton',
            backgroundColor: const Color.fromRGBO(133, 159, 61, 1),
            foregroundColor: Colors.white,
            child: const Icon(Icons.sort_by_alpha),
          ),
        ],
      ),
    );
  }

  void _showMushroomDetails(
      BuildContext context, Map<String, dynamic> mushroom) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromRGBO(246, 252, 223, 1),
        title: Text(mushroom['name_polish']),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.asset(
                  'assets/images/${mushroom['imagePath1']}',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.asset(
                  'assets/images/${mushroom['imagePath2']}',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Nazwa łacińska: ${mushroom['name_latin'] ?? 'Nieznana nazwa'}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Toksyczność:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                (mushroom['isEdible'] != null && mushroom['isEdible'] == 1)
                    ? 'Jadalny'
                    : 'Trujący',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: (mushroom['isEdible'] != null &&
                          mushroom['isEdible'] == 1)
                      ? Colors.green
                      : Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Opis:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                mushroom['description'] ?? 'Brak opisu',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: const Color.fromRGBO(133, 159, 61, 1),
              foregroundColor: Colors.white,
            ),
            child: const Text('Zamknij'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(133, 159, 61, 1),
          title: const Text(
            "Filtruj grzyby",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<bool?>(
                value: filterEdibility,
                onChanged: (value) {
                  Navigator.pop(context);
                  _filterMushrooms(value);
                },
                dropdownColor: const Color.fromRGBO(133, 159, 61, 1),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
                items: const [
                  DropdownMenuItem<bool?>(
                    value: null,
                    child: Text("Wszystkie"),
                  ),
                  DropdownMenuItem<bool?>(
                    value: true,
                    child: Text("Jadalne"),
                  ),
                  DropdownMenuItem<bool?>(
                    value: false,
                    child: Text("Trujące"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
