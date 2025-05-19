import 'package:flutter/material.dart';

class NumberTile extends StatelessWidget {
  final int number;
  final Key key;

  const NumberTile({
    required this.number,
    required this.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(blurRadius: 2, color: Colors.black12)],
      ),
      child: ListTile(
        title: Text(
          number.toString(),
          style: const TextStyle(fontSize: 18),
        ),
        trailing: const Icon(Icons.drag_handle),
      ),
    );
  }
}
