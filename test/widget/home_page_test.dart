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
      await tester.tap(find.byKey(const Key('resetButton')));
      await tester.pump();
      expect(find.textContaining(RegExp(r'\d')), findsNothing);
    });

    // Testa se um erro é exibido quando o input está vazio
    TestUtils.runWidgetTest('should show error when input is empty',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.byKey(const Key('generateButton')));
      await tester.pump();
      expect(find.text('Insira um número por favor'), findsOneWidget);
    });

    // Testa se um erro é exibido para valores zero ou negativos
    TestUtils.runWidgetTest('should show error for zero or negative input',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.enterText(find.byType(TextField), '-1');
      await tester.tap(find.byKey(const Key('generateButton')));
      await tester.pump();
      expect(find.text('Insira um número maior que 0'), findsOneWidget);
    });

    // Testa se um erro é exibido para entrada não numérica
    TestUtils.runWidgetTest('should show error for non-integer input',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.enterText(find.byType(TextField), 'abc');
      await tester.tap(find.byKey(const Key('generateButton')));
      await tester.pump();
      expect(find.text('Insira um número inteiro válido'), findsOneWidget);
    });

    // Testa se o campo TextField é limpo após pressionar o botão Reset
    TestUtils.runWidgetTest(
        'should clear TextField when Reset button is pressed', (tester) async {
      examProvider.fetchRandomNumbers(3);
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextField), '5');
      await tester.pump();

      await tester.tap(find.byKey(const Key('resetButton')));
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller!.text, isEmpty);
    });

    // Testa se números únicos são gerados com a quantidade correta
    TestUtils.runWidgetTest(
        'should generate unique numbers with correct quantity', (tester) async {
      examProvider.fetchRandomNumbers(5);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(examProvider.numbers.length, 5);
      expect(examProvider.numbers.toSet().length, 5);
    });

    // Testa o fluxo completo: gerar, reorganizar e validar
    TestUtils.runWidgetTest(
        'should complete full flow: generate, reorder, validate',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.enterText(find.byType(TextField), '3');
      await tester.tap(find.byKey(const Key('generateButton')));
      await tester.pumpAndSettle();

      expect(find.byType(ReorderableListView), findsOneWidget);
      expect(examProvider.numbers.length, 3);

      final originalNumbers = List<int>.from(examProvider.numbers);
      examProvider.numbers.sort();
      examProvider.notifyListeners();
      await tester.pump();

      await tester.tap(find.byKey(const Key('checkOrderButton')));
      await tester.pumpAndSettle();

      expect(find.text('Ordem correta!'), findsOneWidget);
    });

    // Testa se feedback de erro é exibido quando a ordem está incorreta
    TestUtils.runWidgetTest('should show error when order is incorrect',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      examProvider.numbers = [3, 1, 2];
      examProvider.notifyListeners();
      await tester.pump();

      await tester.tap(find.byKey(const Key('checkOrderButton')));
      await tester.pumpAndSettle();

      expect(find.text('A ordem está incorreta.'), findsOneWidget);
    });

    // Testa novamente se feedback de erro é exibido com lista invertida
    TestUtils.runWidgetTest('should show error when order is incorrect',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.enterText(find.byType(TextField), '3');
      await tester.tap(find.byKey(const Key('generateButton')));
      await tester.pumpAndSettle();

      examProvider.numbers = List.from(examProvider.numbers)
        ..sort((a, b) => b.compareTo(a)); // Inverte a ordem
      examProvider.notifyListeners();
      await tester.pump();
      await tester.tap(find.byKey(const Key('checkOrderButton')));
      await tester.pumpAndSettle();
      expect(find.text('A ordem está incorreta.'), findsOneWidget);
    });

    group('Invalid Inputs', () {
      Widget createWidgetUnderTest() {
        return ChangeNotifierProvider<ExamProvider>.value(
          value: examProvider,
          child: MaterialApp(
            home: HomePage(),
          ),
        );
      }

      TestUtils.runWidgetTest('should show error when input is empty',
          (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.tap(find.byKey(const Key('generateButton')));
        await tester.pump();
        expect(find.text('Insira um número por favor'), findsOneWidget);
      });

      TestUtils.runWidgetTest('should show error for zero or negative input',
          (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.enterText(find.byType(TextField), '-1');
        await tester.tap(find.byKey(const Key('generateButton')));
        await tester.pump();
        expect(find.text('Insira um número maior que 0'), findsOneWidget);
      });

      TestUtils.runWidgetTest('should show error for non-integer input',
          (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.enterText(find.byType(TextField), 'abc');
        await tester.tap(find.byKey(const Key('generateButton')));
        await tester.pump();
        expect(find.text('Insira um número inteiro válido'), findsOneWidget);
      });
    });
  });
}
