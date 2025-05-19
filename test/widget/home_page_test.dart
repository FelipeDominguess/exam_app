import 'package:exam_app/pages/home.dart';
import 'package:exam_app/providers/exam_provider.dart';
import 'package:exam_app/services/exam_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import '../helpers/test_utils.dart';

void main() {
  late ExamProvider examProvider;

  setUp(() {
    examProvider = ExamProvider(ExamApiImpl());
  });

  TestUtils.init();
  TestUtils.setupTearDownAll('HomePage Widgets');

  // Agrupa testes relacionados à HomePage
  group('HomePage', () {
    // Configura o widget para teste com o provider e MaterialApp
    Widget createWidgetUnderTest() {
      return ChangeNotifierProvider<ExamProvider>.value(
        value: examProvider,
        child: MaterialApp(
          home: HomePage(),
        ),
      );
    }

    // Testa se a HomePage exibe um TextField para entrada de quantidade
    TestUtils.runWidgetTest('should display TextField for quantity input',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(TextField), findsOneWidget);
    });

    // Testa se a HomePage exibe um ReorderableListView com os números gerados
    TestUtils.runWidgetTest('should display ReorderableListView with numbers',
        (tester) async {
      examProvider.fetchRandomNumbers(3);
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(ReorderableListView), findsOneWidget);
      expect(find.textContaining(examProvider.numbers[0].toString()),
          findsOneWidget);
    });

    // Testa se a HomePage permite reorganizar os itens da lista
    TestUtils.runWidgetTest('should allow reordering of list items',
        (tester) async {
      examProvider.fetchRandomNumbers(2);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.drag(find.byType(ListTile).at(0), const Offset(0, 100));
      await tester.pump();
      expect(examProvider.numbers[0], isNot(equals(examProvider.numbers[1])));
    });

    // Testa se a HomePage exibe feedback após verificar a ordem
    TestUtils.runWidgetTest('should show feedback after checking order',
        (tester) async {
      examProvider.numbers = [1, 2, 3];
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.byKey(const Key('checkOrderButton')));
      await tester.pump();
      expect(find.textContaining('Ordem correta'), findsOneWidget);
    });

    // Testa se a HomePage limpa os dados ao pressionar o botão Reset
    TestUtils.runWidgetTest('should reset when Reset button is pressed',
        (tester) async {
      examProvider.fetchRandomNumbers(3);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Reset'));
      await tester.pump();
      expect(find.textContaining(RegExp(r'\d')), findsNothing);
    });
  });
}