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

        setState(() {
          resultText = "Top-3 wyniki:\n";
          for (int i = 0; i < min(3, topIndices.length); i++) {
            resultText +=
                "${classList[topIndices[i]]}: ${(resultProbabilities[topIndices[i]] * 100).toStringAsFixed(2)}%\n";
          }
        });

        await _fetchMushroomInfo(topClass);
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

  Future<void> _fetchMushroomInfo(String topClass) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final mushrooms = await dbHelper.getMushrooms();
      final mushroom = mushrooms.firstWhere(
          (element) => element['name_latin'] == topClass,
          orElse: () => {});
      print(mushroom);

      setState(() {
        mushroomPolishName = mushroom.isNotEmpty ? mushroom['name_polish'] : '';
        mushroomInfo = mushroom.isNotEmpty
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
                    RichText(
                      text: TextSpan(
                        text: "Opis: ",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [
                          TextSpan(
                            text: mushroom['description'],
                            style:
                                const TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        text: "Toksyczność: ",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [
                          TextSpan(
                            text: mushroom['isEdible'] == 1
                                ? "Jadalny"
                                : "Toksyczny",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: mushroom['isEdible'] == 1
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : const Text(
                "Brak informacji o wybranym grzybie.",
                textAlign: TextAlign.center,
              );
      });
    } catch (e) {
      setState(() {
        mushroomInfo = Text("Błąd podczas pobierania informacji: $e",
            textAlign: TextAlign.center);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wyniki analizy")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (mushroomPolishName.isNotEmpty)
              Text(
                mushroomPolishName,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 20),
            Image.memory(
              Uint8List.fromList(img.encodeJpg(widget.image)),
              height: 300,
              width: 300,
            ),
            const SizedBox(height: 20),
            Text(resultText, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            mushroomInfo,
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
