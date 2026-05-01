import 'package:flag/flag.dart';
import 'package:flutter/material.dart';

import '../../../../core/data/countries.dart';

class CountryPickerField extends StatefulWidget {
  const CountryPickerField({
    super.key,
    required this.selected,
    required this.onChanged,
    this.label = 'Países',
  });

  final List<String> selected;
  final ValueChanged<List<String>> onChanged;
  final String label;

  @override
  State<CountryPickerField> createState() => _CountryPickerFieldState();
}

class _CountryPickerFieldState extends State<CountryPickerField> {
  Future<void> _open() async {
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _CountrySearchSheet(initial: widget.selected),
    );
    if (result != null) widget.onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _open,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.label,
          suffixIcon: const Icon(Icons.expand_more),
        ),
        child: widget.selected.isEmpty
            ? const Text('Toca para escolher')
            : Wrap(
                spacing: 6,
                runSpacing: 6,
                children: widget.selected
                    .map((c) => _CountryChip(code: c))
                    .toList(),
              ),
      ),
    );
  }
}

class _CountryChip extends StatelessWidget {
  const _CountryChip({required this.code});
  final String code;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 18,
            height: 12,
            child: Flag.fromString(code, fit: BoxFit.cover),
          ),
          const SizedBox(width: 6),
          Text(countryNamePt(code)),
        ],
      ),
    );
  }
}

class _CountrySearchSheet extends StatefulWidget {
  const _CountrySearchSheet({required this.initial});
  final List<String> initial;

  @override
  State<_CountrySearchSheet> createState() => _CountrySearchSheetState();
}

class _CountrySearchSheetState extends State<_CountrySearchSheet> {
  late final Set<String> _selected = widget.initial.toSet();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered =
        kCountries.where((c) => c.matches(_query)).toList(growable: false);
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (ctx, scroll) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Pesquisar país…',
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scroll,
                itemCount: filtered.length,
                itemBuilder: (_, i) {
                  final c = filtered[i];
                  final selected = _selected.contains(c.code);
                  return CheckboxListTile(
                    value: selected,
                    onChanged: (v) => setState(() {
                      if (v == true) {
                        _selected.add(c.code);
                      } else {
                        _selected.remove(c.code);
                      }
                    }),
                    title: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 16,
                          child: Flag.fromString(c.code, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(c.namePt)),
                      ],
                    ),
                  );
                },
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: () =>
                      Navigator.of(context).pop(_selected.toList()),
                  child: const Text('Concluído'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
