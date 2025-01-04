# CapSpotter

**CapSpotter** to aplikacja mobilna, która pomaga rozpoznawać gatunki grzybów na podstawie zdjęć przy użyciu sztucznej inteligencji. Aplikacja oferuje również możliwość przeglądania zdjęć i krótkich informacji o różnych gatunkach grzybów.

## Funkcjonalności

- **Rozpoznawanie gatunków grzybów**:  
  Prześlij zdjęcie grzyba, a aplikacja zidentyfikuje jego gatunek dzięki modelowi AI.
- **Galeria gatunków**:  
  Przeglądaj zdjęcia i podstawowe informacje, takie jak:
  - Opis
  - Nazwa łacińska i polska
  - Informacja o toksyczności
- **Offline**:  
  Możesz korzystać ze wszystkich funkcji aplikacji bez dostępu do internetu.

## Technologie

- **Frontend**: Flutter (Dart)
- **Operacje dotyczące modelu**: Python
- **Model**: Convolutional Neural Network (CNN) przeszkolony na dużym zbiorze zdjęć grzybów z zastosowaniem augmentacji danych.

## Instalacja i uruchomienie

1. Sklonuj repozytorium:
   ```bash
   git clone https://github.com/avangie/CapSpotter.git
   cd frontend/capspotter/
   ```
2. Zainstaluj zależności Flutter:
   ```bash
   flutter pub get
   ```
3. Uruchom aplikację na emulatorze lub urządzeniu fizycznym:
   ```bash
   flutter run
   ```
