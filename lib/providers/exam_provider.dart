import 'package:flutter/material.dart';
import 'package:exam_app/services/exam_api.dart';

class ExamProvider extends ChangeNotifier {
  final ExamApi _examApi;
  List<int> numbers = [];
  String? errorMessage;
  bool? isOrdered;

  ExamProvider(this._examApi);
//Pega números aleatorio e nao repetidos
  void fetchRandomNumbers(int quantity) {
    try {
      if (quantity <= 0) throw ArgumentError('Quantity must be positive');
      numbers = _examApi.getRandomNumbers(quantity);
      errorMessage = null;
      isOrdered = null;
    } catch (e) {
      errorMessage = 'Erro ao gerar números: $e';
      numbers = [];
    }
    notifyListeners();
  }

//Funcao para mover o old para o newindex e limpa a ordem
  void reorderNumbers(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final number = numbers.removeAt(oldIndex);
    numbers.insert(newIndex, number);

    isOrdered = null;
    notifyListeners();
  }

//Verifica a ordem
  void checkOrder() {
    isOrdered = _examApi.checkOrder(numbers);
    notifyListeners();
  }

//Reinicia
  void reset() {
    numbers = [];
    errorMessage = null;
    isOrdered = null;
    notifyListeners();
  }
}
