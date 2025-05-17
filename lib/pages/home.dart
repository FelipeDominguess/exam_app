import 'package:exam_app/services/exam_api.dart';
import 'package:exam_app/providers/exam_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExamProvider(ExamApiImpl()),
      child: const _HomePageView(),
    );
  }
}

class _HomePageView extends StatefulWidget {
  const _HomePageView();

  @override
  State<_HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<_HomePageView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExamProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ordene os Números'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // CAMPO DE TEXTO
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantidade de números',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                final quantity = int.tryParse(value);
                if (quantity != null && quantity > 0) {
                  provider.fetchRandomNumbers(quantity);
                } else {
                  provider.errorMessage = 'Por favor, insira um número positivo';
                  provider.notifyListeners();
                }
              },
            ),

            const SizedBox(height: 16),

            // MENSAGEM DE ERRO
            if (provider.errorMessage != null)
              Text(
                provider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),

            // LISTA REORDENÁVEL
            if (provider.numbers.isNotEmpty)
              Expanded(
                child: ReorderableListView(
                  onReorder: provider.reorderNumbers,
                  children: [
                    for (int i = 0; i < provider.numbers.length; i++)
                      ListTile(
                        key: ValueKey(provider.numbers[i].toString() + i.toString()),
                        title: Text(
                          provider.numbers[i].toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                        tileColor: Colors.grey.shade100,
                      ),
                  ],
                ),
              ),

            const SizedBox(height: 12),

            // BOTÕES
            if (provider.numbers.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      provider.checkOrder();
                      final message = provider.isOrdered == true
                          ? 'Ordem correta!'
                          : 'A ordem está incorreta.';
                      final color = provider.isOrdered == true
                          ? Colors.green
                          : Colors.red;

                      _showSnackBar(message, color);
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Validar Ordem'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      _controller.clear();
                      provider.reset();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reiniciar'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
