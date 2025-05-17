import 'package:flutter_test/flutter_test.dart';
import 'package:exam_app/core/services/exam_api.dart';

void main() {
  late ExamApi examApi;

  setUp(() {
    examApi = ExamApiImpl();
  });

  group('getRandomNumbers', () {
    test('should return a list with the requested quantity', () {
      final result = examApi.getRandomNumbers(5);
      expect(result.length, 5);
    });

    test('should return unique numbers', () {
      final result = examApi.getRandomNumbers(10);
      final uniqueNumbers = result.toSet();
      expect(uniqueNumbers.length, result.length);
    });

    test('should throw ArgumentError for negative quantity', () {
      expect(() => examApi.getRandomNumbers(-1), throwsArgumentError);
    });
  });

  group('checkOrder', () {
    test('should return true for ascending ordered list', () {
      final result = examApi.checkOrder([1, 2, 3, 4, 5]);
      expect(result, true);
    });

    test('should return false for unordered list', () {
      final result = examApi.checkOrder([3, 1, 4, 2, 5]);
      expect(result, false);
    });

    test('should return true for empty list', () {
      final result = examApi.checkOrder([]);
      expect(result, true);
    });
  });
}