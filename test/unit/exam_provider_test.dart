import 'package:exam_app/providers/exam_provider.dart';
import 'package:exam_app/services/exam_api.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_utils.dart';

void main() {
  late ExamProvider examProvider;
  late ExamApi examApi;

  setUp(() {
    examApi = ExamApiImpl();
    examProvider = ExamProvider(examApi);
  });

  TestUtils.init();
  TestUtils.setupTearDownAll('ExamProvider');

  // Agrupa testes relacionados ao ExamProvider
  group('ExamProvider', () {
    // Testa se o método fetchRandomNumbers obtém números aleatórios e atualiza a lista
    TestUtils.runTest('should fetch random numbers and update the list',
        () async {
      examProvider.fetchRandomNumbers(5);
      expect(examProvider.numbers.length, 5);
      expect(examProvider.errorMessage, isNull);
    });

    // Testa se o método reorderNumbers reorganiza a lista corretamente
    TestUtils.runTest('should reorder numbers correctly', () async {
      try {
        examProvider.fetchRandomNumbers(3); // Gera uma lista com 3 números
        final initialNumbers =
            List<int>.from(examProvider.numbers); // Cópia da lista inicial

        examProvider.reorderNumbers(
            0, 3); // Move o primeiro elemento para a última posição

        expect(examProvider.numbers[0],
            initialNumbers[1]); // O novo primeiro deve ser o antigo segundo
        expect(examProvider.numbers[1],
            initialNumbers[2]); // O novo segundo deve ser o antigo terceiro
        expect(examProvider.numbers[2],
            initialNumbers[0]); // O último deve ser o antigo primeiro
      } catch (e) {
        rethrow;
      }
    });

    // Testa se o método checkOrder verifica a ordem e atualiza isOrdered
    TestUtils.runTest('should check order and update isOrdered', () async {
      examProvider.numbers = [1, 2, 3];
      examProvider.checkOrder();
      expect(examProvider.isOrdered, true);

      examProvider.numbers = [3, 1, 2];
      examProvider.checkOrder();
      expect(examProvider.isOrdered, false);
    });

    // Testa se o método reset limpa o estado do provider
    TestUtils.runTest('should reset state', () async {
      examProvider.fetchRandomNumbers(5);
      examProvider.reset();
      expect(examProvider.numbers, isEmpty);
      expect(examProvider.errorMessage, isNull);
      expect(examProvider.isOrdered, isNull);
    });

    // Testa se o método reorderNumbers lança erro para índices inválidos
    TestUtils.runTest('should not reorder with invalid indexes', () async {
      examProvider.fetchRandomNumbers(3);
      expect(
          () => examProvider.reorderNumbers(-1, 2), throwsA(isA<RangeError>()));
      expect(
          () => examProvider.reorderNumbers(0, 5), throwsA(isA<RangeError>()));
    });

    // Testa se o provider pode ser reutilizado após o reset
    TestUtils.runTest('should allow reuse after reset', () async {
      examProvider.fetchRandomNumbers(3);
      examProvider.reset();
      examProvider.fetchRandomNumbers(2);
      expect(examProvider.numbers.length, 2);
    });
  });
}