import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/exam_provider.dart';
import '../widgets/input_field.dart';
import '../widgets/number_tile.dart';
import '../widgets/action_buttons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _validateAndGenerate(BuildContext context, String value) {
    final provider = Provider.of<ExamProvider>(context, listen: false);

    if (value.isEmpty) {
      _showSnackBar(context, 'Insira um número por favor', Colors.red);
      return;
    }

    try {
      final quantity = int.parse(value);
      if (quantity <= 0) {
        _showSnackBar(context, 'Insira um número maior que 0', Colors.red);
      } else {
        provider.fetchRandomNumbers(quantity);
      }
    } catch (e) {
      _showSnackBar(context, 'Insira um número inteiro válido', Colors.red);
    }
  }

  @override
Widget build(BuildContext context) {
    final provider = Provider.of<ExamProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ordene os Números'),
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        child: provider.numbers.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Nenhum número gerado ainda.',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 180),
                      InputField(
                        controller: _controller,
                        onSubmitted: (value) {
                          FocusScope.of(context).unfocus();
                          _validateAndGenerate(context, value);
                        },
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        key: const Key('generateButton'), // Added key here
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          _validateAndGenerate(context, _controller.text);
                        },
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Gerar'),
                      ),
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Lista de números
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ReorderableListView(
                          onReorder: provider.reorderNumbers,
                          children: [
                            for (int i = 0; i < provider.numbers.length; i++)
                              NumberTile(
                                number: provider.numbers[i],
                                key: ValueKey('${provider.numbers[i]}-$i'),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Input e botões
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: InputField(
                                      controller: _controller,
                                      onSubmitted: (value) {
                                        FocusScope.of(context).unfocus();
                                        _validateAndGenerate(context, value);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  FilledButton.icon(
                                    key: const Key('generateButton'), // Added key here
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      _validateAndGenerate(
                                          context, _controller.text);
                                    },
                                    icon: const Icon(Icons.check_circle),
                                    label: const Text('Gerar'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ActionButtons(
                                onValidate: () {
                                  provider.checkOrder();
                                  final msg = provider.isOrdered == true
                                      ? 'Ordem correta!'
                                      : 'A ordem está incorreta.';
                                  final color = provider.isOrdered == true
                                      ? Colors.green
                                      : Colors.red;
                                  _showSnackBar(context, msg, color);
                                },
                                onReset: () {
                                  _controller.clear();
                                  provider.reset();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}