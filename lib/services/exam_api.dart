import 'dart:math';

abstract class ExamApi {
  // Retorna uma lista de números aleatórios com a quantidade de itens solicitada
  List<int> getRandomNumbers(int quantity);

  // Verifica se uma lista de números informada está em ordem crescente
  bool checkOrder(List<int> numbers);
}

class ExamApiImpl implements ExamApi {
  @override
  List<int> getRandomNumbers(int quantity) {
    //Não deve retornar número negativo
    if (quantity < 0) throw ArgumentError('Quantity must be non-negative');

    final random = Random();
    final numbers = <int>{};

    while (numbers.length < quantity) {
      numbers.add(random.nextInt(100) + 1);
    }

    return numbers.toList();
  }

  @override
  bool checkOrder(List<int> numbers) {
    if (numbers.isEmpty) return true;
    for (int i = 0; i < numbers.length - 1; i++) {
      if (numbers[i] > numbers[i + 1]) return false;
    }
    return true;
  }
}
