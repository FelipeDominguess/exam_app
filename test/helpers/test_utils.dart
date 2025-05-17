import 'package:flutter_test/flutter_test.dart';

   class TestUtils {
     static int passed = 0;
     static int failed = 0;
     static late DateTime startTime;

     /// Initializes the test utilities, resetting counters and start time.
     static void init() {
       passed = 0;
       failed = 0;
       startTime = DateTime.now();
     }

     /// Sets up the tearDownAll callback to print test results.
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

     /// Runs a test case, updating passed/failed counters.
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
   }