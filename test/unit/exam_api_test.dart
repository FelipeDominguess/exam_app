import 'package:flutter_test/flutter_test.dart';
import 'package:exam_app/services/exam_api.dart';

import '../helpers/test_utils.dart';

void main() {
  late ExamApi examApi;

  setUp(() {
    examApi = ExamApiImpl();
  });

  TestUtils.init();
  TestUtils.setupTearDownAll('ExamApi');

  // Agrupa testes relacionados ao método getRandomNumbers
  group('getRandomNumbers', () {
    // Testa se o método retorna uma lista com a quantidade solicitada
    TestUtils.runTest('should return a list with the requested quantity',
        () async {
      final result = examApi.getRandomNumbers(5);
      expect(result.length, 5);
    });

    // Testa se o método retorna números únicos
    TestUtils.runTest('should return unique numbers', () async {
      final result = examApi.getRandomNumbers(10);
      final uniqueNumbers = result.toSet();
      expect(uniqueNumbers.length, result.length);
    });

    // Testa se o método lança erro para quantidade negativa
    TestUtils.runTest('should throw ArgumentError for negative quantity',
        () async {
      expect(() => examApi.getRandomNumbers(-1), throwsArgumentError);
    });
  });

  // Agrupa testes relacionados ao método checkOrder
  group('checkOrder', () {
    // Testa se o método retorna true para uma lista em ordem crescente
    TestUtils.runTest('should return true for a list in ascending order',
        () async {
      final result = examApi.checkOrder([1, 2, 3, 4, 5]);
      expect(result, true);
    });

    // Testa se o método retorna false para uma lista fora de ordem
    TestUtils.runTest('should return false for an unordered list', () async {
      final result = examApi.checkOrder([3, 1, 4, 2, 5]);
      expect(result, false);
    });

    // Testa se o método retorna true para uma lista vazia
    TestUtils.runTest('should return true for an empty list', () async {
      final result = examApi.checkOrder([]);
      expect(result, true);
    });
  });
}