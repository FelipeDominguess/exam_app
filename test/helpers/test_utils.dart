import 'package:flutter_test/flutter_test.dart';

   class TestUtils {
     static int passed = 0;
     static int failed = 0;
     static late DateTime startTime;

     static void init() {
       passed = 0;
       failed = 0;
       startTime = DateTime.now();
     }

     static void setupTearDownAll(String groupName) {
       tearDownAll(() {
         final duration = DateTime.now().difference(startTime);
         final seconds = duration.inMilliseconds / 1000;

         print('\n=============');
         print('Grupo $groupName');
         print('Passou: $passed');
         print('Nao Passou: $failed');
         print('==============');
         print('Resumo dos Testes');

         if (failed == 0) {
           print('✅ Todos os testes passaram');
         } else {
           print('❌ Alguns testes falharam');
         }

         print('⏱️ Tempo total: ${seconds.toStringAsFixed(2)}s');
         print('-----------------');
       });
     }

     static void runTest(String description, Future<void> Function() testBody) {
       test(description, () async {
         try {
           await testBody();
           passed++;
         } catch (_) {
           failed++;
           rethrow;
         }
       });
     }

     static void runWidgetTest(String description, Future<void> Function(WidgetTester) testBody) {
    testWidgets(description, (WidgetTester tester) async {
      try {
        await testBody(tester);
        passed++;
      } catch (_) {
        failed++;
        rethrow;
      }
    });
  }
   }