import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';
import 'dart:math';
import 'database_helper.dart';

class ResultPage extends StatefulWidget {
  static const int WIDTH = 224;
  static const int HEIGHT = 224;
  final img.Image image;

  ResultPage({super.key, required this.image});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final List<String> classList = [
    'Agaricus augustus',
    'Agaricus xanthodermus',
    'Amanita muscaria',
    'Amanita phalloides',
    'Amanita rubescens',
    'Armillaria mellea',
    'Armillaria tabescens',
    'Artomyces pyxidatus',
    'Bolbitius titubans',
    'Cerioporus squamosus',
    'Chlorophyllum brunneum',
    'Clitocybe nuda',
    'Coprinellus micaceus',
    'Coprinopsis lagopus',
    'Coprinus comatus',
    'Crucibulum laeve',
    'Daedaleopsis confragosa',
    'Flammulina velutipes',
    'Galerina marginata',
    'Ganoderma applanatum',
    'Ganoderma oregonense',
    'Gliophorus psittacinus',
    'Gloeophyllum sepiarium',
    'Grifola frondosa',
    'Gymnopilus luteofolius',
    'Hericium coralloides',
    'Hericium erinaceus',
    'Hygrophoropsis aurantiaca',
    'Hypholoma fasciculare',
    'Hypholoma lateritium',
    'Ischnoderma resinosum',
    'Lacrymaria lacrymabunda',
    'Laetiporus sulphureus',
    'Leratiomyces ceres',
    'Leucoagaricus americanus',
    'Leucoagaricus leucothites',
    'Lycogala epidendrum',
    'Lycoperdon perlatum',
    'Lycoperdon pyriforme',
    'Mycena haematopus',
    'Panaeolina foenisecii',
    'Panaeolus cinctulus',
    'Panaeolus papilionaceus',
    'Panellus stipticus',
    'Phaeolus schweinitzii',
    'Phlebia tremellosa',
    'Phyllotopsis nidulans',
    'Pleurotus ostreatus',
    'Pleurotus pulmonarius',
    'Pluteus cervinus',
    'Psathyrella candolleana',
    'Pseudohydnum gelatinosum',
    'Psilocybe cyanescens',
    'Sarcomyxa serotina',
    'Schizophyllum commune',
    'Stereum ostrea',
    'Stropharia rugosoannulata',
    'Suillus americanus',
    'Suillus luteus',
    'Tapinella atrotomentosa',
    'Trametes betulina',
    'Trametes gibbosa',
    'Trametes versicolor',
    'Trichaptum biforme',
    'Tricholomopsis rutilans',
    'Tubaria furfuracea',
    'Tylopilus felleus',
    'Volvopluteus gloiocephalus'
  ];

  String resultText = "Przetwarzanie...";
  Widget mushroomInfo = const SizedBox();
  String mushroomPolishName = '';
  String mushroomImage1Path = '';
  String mushroomImage2Path = '';
  String similarMushroom1PolishName = '';
  String similarMushroom1ImagePath = '';
  String similarMushroom2PolishName = '';
  String similarMushroom2ImagePath = '';

  @override
  void initState() {
    super.initState();
    _processImage();
  }

  Float32List preprocessImage(img.Image image, List<int> inputShape) {
    img.Image resizedImage =
        img.copyResize(image, width: inputShape[1], height: inputShape[2]);

    List<double> flattenedList = resizedImage.data!
        .expand((pixel) => [
              pixel.r.toDouble() / 255.0,
              pixel.g.toDouble() / 255.0,
              pixel.b.toDouble() / 255.0,
            ])
        .toList();

    return Float32List.fromList(flattenedList);
  }

  List<double> applySoftmax(List<double> logits) {
    double maxLogit = logits.reduce(max);
    List<double> exps = logits.map((logit) => exp(logit - maxLogit)).toList();
    double sumExps = exps.reduce((a, b) => a + b);
    return exps.map((expVal) => expVal / sumExps).toList();
  }

  Future<List<double>> runInference(Float32List inputTensor) async {
    try {
      final interpreter = await Interpreter.fromAsset('assets/model.tflite');
      var input =
          inputTensor.reshape([1, ResultPage.WIDTH, ResultPage.HEIGHT, 3]);
      var output =
          List.filled(1 * classList.length, 0.0).reshape([1, classList.length]);
      interpreter.run(input, output);
      return List<double>.from(output[0]);
    } catch (e) {
      print("Błąd przy uruchamianiu inferencji: $e");
      return [];
    }
  }

  Future<void> _processImage() async {
    try {
      List<int> inputShape = [1, ResultPage.WIDTH, ResultPage.HEIGHT, 3];
      Float32List inputTensor = preprocessImage(widget.image, inputShape);
      List<double> result = await runInference(inputTensor);

      if (result.isNotEmpty) {
        List<double> resultProbabilities = applySoftmax(result);
        List<int> topIndices = List.generate(result.length, (i) => i)
          ..sort((a, b) =>
              resultProbabilities[b].compareTo(resultProbabilities[a]));

        String topClass = classList[topIndices[0]];
        String secondClass = classList[topIndices[1]];
        String thirdClass = classList[topIndices[2]];

        setState(() {
          resultText = "Top-3 wyniki:\n";
          for (int i = 0; i < min(3, topIndices.length); i++) {
            resultText +=
                "${classList[topIndices[i]]}: ${(resultProbabilities[topIndices[i]] * 100).toStringAsFixed(2)}%\n";
          }
        });

        await _fetchMushroomInfo(topClass, secondClass, thirdClass);
      } else {
        setState(() {
          resultText = "Nie udało się przeanalizować obrazu.";
        });
      }
    } catch (e) {
      setState(() {
        resultText = "Błąd: $e";
      });
    }
  }

  Future<void> _fetchMushroomInfo(
      String topClass, String secondClass, String thirdClass) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final mushrooms = await dbHelper.getMushrooms();

      final topMushroom = mushrooms.firstWhere(
          (element) => element['name_latin'] == topClass,
          orElse: () => {});
      final secondMushroom = mushrooms.firstWhere(
          (element) => element['name_latin'] == secondClass,
          orElse: () => {});
      final thirdMushroom = mushrooms.firstWhere(
          (element) => element['name_latin'] == thirdClass,
          orElse: () => {});

      setState(() {
        mushroomPolishName =
            topMushroom.isNotEmpty ? '${topMushroom['name_polish']}' : '';
        mushroomImage1Path = topMushroom.isNotEmpty
            ? 'assets/images/${topMushroom['imagePath1']}'
            : '';
        mushroomImage2Path = topMushroom.isNotEmpty
            ? 'assets/images/${topMushroom['imagePath2']}'
            : '';
        similarMushroom1PolishName =
            secondMushroom.isNotEmpty ? '${secondMushroom['name_polish']}' : '';
        similarMushroom1ImagePath = secondMushroom.isNotEmpty
            ? 'assets/images/${secondMushroom['imagePath1']}'
            : '';
        similarMushroom2PolishName =
            thirdMushroom.isNotEmpty ? '${thirdMushroom['name_polish']}' : '';
        similarMushroom2ImagePath = thirdMushroom.isNotEmpty
            ? 'assets/images/${thirdMushroom['imagePath1']}'
            : '';

        mushroomInfo = topMushroom.isNotEmpty
            ? Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topMushroom['name_polish'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${topMushroom['name_latin']}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Toksyczność: ${topMushroom['isEdible'] == 0 ? 'Trujący' : 'Jadalny'}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: topMushroom['isEdible'] == 0
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text("${topMushroom['description']}"),
                  ],
                ),
              )
            : const SizedBox();
      });
    } catch (e) {
      setState(() {
        resultText = "Błąd przy pobieraniu danych o grzybach.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Wyniki analizy",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(133, 159, 61, 1),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    "UWAGA! Model może się mylić. Wiele grzybów jest trujących, a niektóre są śmiertelnie trujące. Nie zbieraj grzybów na podstawie tylko wyników tej aplikacji!",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (mushroomPolishName.isNotEmpty)
                Text(
                  mushroomPolishName,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(133, 159, 61, 1)),
                ),
              const SizedBox(height: 18),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.memory(
                    Uint8List.fromList(img.encodeJpg(widget.image)),
                    height: 250,
                    width: 260,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (mushroomImage1Path.isNotEmpty &&
                  mushroomImage2Path.isNotEmpty)
                const Text("Inne zdjęcia tego gatunku"),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (mushroomImage1Path.isNotEmpty)
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(4, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            mushroomImage1Path,
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.width * 0.4,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 16),
                  if (mushroomImage2Path.isNotEmpty)
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(4, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            mushroomImage2Path,
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.width * 0.4,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              mushroomInfo,
              const SizedBox(height: 20),
              if (similarMushroom1PolishName.isNotEmpty ||
                  similarMushroom2PolishName.isNotEmpty)
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(133, 159, 61, 1),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Podobne gatunki",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (similarMushroom1PolishName.isNotEmpty &&
                          similarMushroom2PolishName.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 8,
                                          offset: Offset(4, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.asset(
                                        similarMushroom1ImagePath,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    similarMushroom1PolishName,
                                    style: const TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 8,
                                          offset: Offset(4, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.asset(
                                        similarMushroom2ImagePath,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    similarMushroom2PolishName,
                                    style: const TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
