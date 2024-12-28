import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';
import 'dart:math';

class ResultPage extends StatelessWidget {
  static const int WIDTH = 224;
  static const int HEIGHT = 224;
  final img.Image image;

  // Lista klas grzybów
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

  ResultPage({super.key, required this.image});

  // Funkcja do przetwarzania obrazu
  Float32List preprocessImage(img.Image image, List<int> inputShape) {
    img.Image resizedImage =
        img.copyResize(image, width: inputShape[1], height: inputShape[2]);

    // Flatten image data and normalize
    List<double> flattenedList = resizedImage.data!
        .expand((pixel) => [
              pixel.r.toDouble() / 255.0,
              pixel.g.toDouble() / 255.0,
              pixel.b.toDouble() / 255.0,
            ])
        .toList();

    return Float32List.fromList(flattenedList);
  }

  // Funkcja do zastosowania softmax na wynikach
  List<double> applySoftmax(List<double> logits) {
    double maxLogit = logits.reduce(max);
    List<double> exps = logits.map((logit) => exp(logit - maxLogit)).toList();
    double sumExps = exps.reduce((a, b) => a + b);
    return exps.map((expVal) => expVal / sumExps).toList();
  }

  // Funkcja do uruchamiania inferencji na modelu
  Future<List<double>> runInference(Float32List inputTensor) async {
    try {
      final interpreter = await Interpreter.fromAsset('assets/model.tflite');
      var input = inputTensor.reshape([1, WIDTH, HEIGHT, 3]);
      var output =
          List.filled(1 * classList.length, 0.0).reshape([1, classList.length]);
      interpreter.run(input, output);
      return List<double>.from(output[0]);
    } catch (e) {
      print("Błąd przy uruchamianiu inferencji: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<int> inputShape = [1, WIDTH, HEIGHT, 3];

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
              onPressed: () async {
                try {
                  Float32List inputTensor = preprocessImage(image, inputShape);
                  List<double> result = await runInference(inputTensor);

                  if (result.isNotEmpty) {
                    // Zastosowanie softmax na wynikach
                    List<double> resultProbabilities = applySoftmax(result);
                    List<int> topIndices =
                        List.generate(result.length, (i) => i)
                          ..sort((a, b) => resultProbabilities[b]
                              .compareTo(resultProbabilities[a]));

                    print("Top-3 wyniki:");
                    for (int i = 0; i < min(3, topIndices.length); i++) {
                      print(
                          "${classList[topIndices[i]]}: ${(resultProbabilities[topIndices[i]] * 100).toStringAsFixed(2)}%");
                    }

                    // Zapisz obraz po przetworzeniu
                    // await saveImageToFile(image);
                  }
                } catch (e) {
                  print("Błąd: $e");
                }
              },
              child: const Text('Przetwórz obraz'),
            ),
          ],
        ),
      ),
    );
  }
}
