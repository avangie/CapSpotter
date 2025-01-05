import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:capspotter/main.dart';
import 'package:capspotter/library.dart';
import 'package:capspotter/take_photo.dart';
import 'package:capspotter/pick_photo.dart';
import 'package:flutter/foundation.dart';

void main() {
  testWidgets('HomePage displays app icon and name',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CapSpotterApp()));
    expect(find.byKey(const Key('appIcon')), findsOneWidget);
    expect(find.text('CapSpotter'), findsOneWidget);
  });

  testWidgets('HomePage has three buttons', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CapSpotterApp()));
    expect(find.byType(ElevatedButton), findsNWidgets(3));
  });

  testWidgets(
      'HomePage navigates to TakePhotoPage when clicking "Zrób zdjęcie"',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CapSpotterApp()));
    await tester.pumpAndSettle();
    final takePhotoButton = find.text('Zrób zdjęcie');
    await tester.tap(takePhotoButton);
    await tester.pumpAndSettle();

    expect(find.byType(TakePhotoPage), findsOneWidget);
  });

  testWidgets(
      'HomePage navigates to PickFromGalleryPage when clicking "Wybierz zdjęcie z galerii"',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CapSpotterApp()));
    await tester.pumpAndSettle();
    final galleryButton = find.text('Wybierz zdjęcie z galerii');
    await tester.tap(galleryButton);
    await tester.pumpAndSettle();

    expect(find.byType(PickFromGalleryPage), findsOneWidget);
  });

  testWidgets(
      'HomePage navigates to BrowseSpeciesPage when clicking "Przeglądaj gatunki"',
      (WidgetTester tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    await tester.pumpWidget(const MaterialApp(home: CapSpotterApp()));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Przeglądaj gatunki'));
    final browseButton = find.text('Przeglądaj gatunki');
    await tester.tap(browseButton);
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(seconds: 1));
    }

    expect(find.byType(BrowseSpeciesPage), findsOneWidget);
    debugDefaultTargetPlatformOverride = null;
  });
}
