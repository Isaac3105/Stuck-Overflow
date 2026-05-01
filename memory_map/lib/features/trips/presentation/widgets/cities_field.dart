import 'package:flutter/material.dart';

class CitiesField extends StatefulWidget {
  const CitiesField({
    super.key,
    required this.cities,
    required this.onChanged,
    this.label = 'Cidades',
  });

  final List<String> cities;
  final ValueChanged<List<String>> onChanged;
  final String label;

  @override
  State<CitiesField> createState() => _CitiesFieldState();
}

class _CitiesFieldState extends State<CitiesField> {
  final _controller = TextEditingController();

  void _addCurrent() {
    final v = _controller.text.trim();
    if (v.isEmpty) return;
    if (widget.cities.contains(v)) {
      _controller.clear();
      return;
    }
    widget.onChanged([...widget.cities, v]);
    _controller.clear();
  }

  void _remove(String c) {
    widget.onChanged(widget.cities.where((e) => e != c).toList());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: 'Ex: Lisboa, Porto…',
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addCurrent,
            ),
          ),
          onSubmitted: (_) => _addCurrent(),
        ),
        if (widget.cities.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: widget.cities
                .map(
                  (c) => Chip(
                    label: Text(c),
                    onDeleted: () => _remove(c),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}
