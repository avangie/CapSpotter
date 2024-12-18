import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:CapSpotter/main.dart'; // Importuj plik główny aplikacji
import 'package:CapSpotter/take_photo.dart'; // Importuj stronę, którą chcesz testować
import 'package:CapSpotter/pick_photo.dart'; // Importuj stronę galerii
import 'package:CapSpotter/library.dart'; // Importuj stronę przeglądania gatunków

void main() {
  testWidgets('Sprawdzanie widżetów na stronie głównej',
      (WidgetTester tester) async {
    // Załaduj aplikację
    await tester.pumpWidget(CapSpotterApp());

    // Sprawdzamy, czy na ekranie jest logo
    expect(find.byType(Image), findsOneWidget);

    // Sprawdzamy, czy widoczny jest napis "CapSpotter"
    expect(find.text('CapSpotter'), findsOneWidget);

    // Sprawdzamy, czy istnieje przycisk "Zrób zdjęcie"
    expect(find.widgetWithText(ElevatedButton, 'Zrób zdjęcie'), findsOneWidget);

    // Sprawdzamy, czy istnieje przycisk "Wybierz zdjęcie z galerii"
    expect(find.widgetWithText(ElevatedButton, 'Wybierz zdjęcie z galerii'),
        findsOneWidget);

    // Sprawdzamy, czy istnieje przycisk "Przeglądaj gatunki"
    expect(find.widgetWithText(ElevatedButton, 'Przeglądaj gatunki'),
        findsOneWidget);
  });

  testWidgets('Test nawigacji do strony robienia zdjęcia',
      (WidgetTester tester) async {
    // Załaduj aplikację
    await tester.pumpWidget(CapSpotterApp());

    // Naciśnij przycisk "Zrób zdjęcie"
    await tester.tap(find.widgetWithText(ElevatedButton, 'Zrób zdjęcie'));
    await tester.pumpAndSettle(); // Poczekaj na zakończenie nawigacji

    // Sprawdzamy, czy nawigowano do strony TakePhotoPage
    expect(find.byType(TakePhotoPage), findsOneWidget);
  });

  testWidgets('Test nawigacji do strony wyboru zdjęcia z galerii',
      (WidgetTester tester) async {
    // Załaduj aplikację
    await tester.pumpWidget(CapSpotterApp());

    // Naciśnij przycisk "Wybierz zdjęcie z galerii"
    await tester
        .tap(find.widgetWithText(ElevatedButton, 'Wybierz zdjęcie z galerii'));
    await tester.pumpAndSettle(); // Poczekaj na zakończenie nawigacji

    // Sprawdzamy, czy nawigowano do strony PickFromGalleryPage
    expect(find.byType(PickFromGalleryPage), findsOneWidget);
  });

  testWidgets('Test nawigacji do strony przeglądania gatunków',
      (WidgetTester tester) async {
    // Załaduj aplikację
    await tester.pumpWidget(CapSpotterApp());

    // Naciśnij przycisk "Przeglądaj gatunki"
    await tester.tap(find.widgetWithText(ElevatedButton, 'Przeglądaj gatunki'));
    await tester.pumpAndSettle(); // Poczekaj na zakończenie nawigacji

    // Sprawdzamy, czy nawigowano do strony BrowseSpeciesPage
    expect(find.byType(BrowseSpeciesPage), findsOneWidget);
  });
}
