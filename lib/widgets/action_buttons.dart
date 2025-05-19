// widgets/action_buttons.dart

import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onValidate;
  final VoidCallback onReset;

  const ActionButtons({
    super.key,
    required this.onValidate,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            key: const Key('checkOrderButton'),
            onPressed: onValidate,
            child: const Text('Verificar Ordem'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: FilledButton(
            key: const Key('resetButton'),
            onPressed: onReset,
            child: const Text('Reiniciar'),
          ),
        ),
      ],
    );
  }
}
