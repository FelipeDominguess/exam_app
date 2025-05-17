import 'package:flutter_test/flutter_test.dart';
import 'package:exam_app/core/services/exam_api.dart';

import '../helpers/test_utils.dart';


void main() {
  late ExamApi examApi;

  setUp(() {
    examApi = ExamApiImpl();
  });

  TestUtils.init();
  TestUtils.setupTearDownAll('ExamApi');

  group('getRandomNumbers', () {
    TestUtils.runTest('should return a list with the requested quantity', () async {
      final result = examApi.getRandomNumbers(5);
      expect(result.length, 5);
    });

    TestUtils.runTest('should return unique numbers', () async {
      final result = examApi.getRandomNumbers(10);
      final uniqueNumbers = result.toSet();
      expect(uniqueNumbers.length, result.length);
    });

    TestUtils.runTest('should throw ArgumentError for negative quantity', () async {
      expect(() => examApi.getRandomNumbers(-1), throwsArgumentError);
    });
  });

  group('checkOrder', () {
    TestUtils.runTest('should return true for a list in ascending order', () async {
      final result = examApi.checkOrder([1, 2, 3, 4, 5]);
      expect(result, true);
    });

    TestUtils.runTest('should return false for an unordered list', () async {
      final result = examApi.checkOrder([3, 1, 4, 2, 5]);
      expect(result, false);
    });

    TestUtils.runTest('should return true for an empty list', () async {
      final result = examApi.checkOrder([]);
      expect(result, true);
    });
  });
}