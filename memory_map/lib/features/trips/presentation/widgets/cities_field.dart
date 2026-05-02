import 'package:flutter/material.dart';

import '../../../../core/data/cities.dart';

class CitiesField extends StatefulWidget {
  const CitiesField({
    super.key,
    required this.selectedCountries,
    required this.cities,
    required this.onChanged,
    this.label = 'Cities',
  });

  final List<String> selectedCountries;
  final List<String> cities;
  final ValueChanged<List<String>> onChanged;
  final String label;

  @override
  State<CitiesField> createState() => _CitiesFieldState();
}

class _CitiesFieldState extends State<CitiesField> {
  Future<void> _open() async {
    if (widget.selectedCountries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose a country first.')),
      );
      return;
    }
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _CitySearchSheet(
        initial: widget.cities,
        countryCodes: widget.selectedCountries,
      ),
    );
    if (result != null) widget.onChanged(result);
  }

  void _remove(String c) {
    widget.onChanged(widget.cities.where((e) => e != c).toList());
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _open,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.label,
          suffixIcon: const Icon(Icons.search),
        ),
        child: widget.selectedCountries.isEmpty
            ? const Text('Pick a country to unlock city suggestions')
            : widget.cities.isEmpty
                ? const Text('Tap to choose')
                : Wrap(
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
      ),
    );
  }
}

class _CitySearchSheet extends StatefulWidget {
  const _CitySearchSheet({required this.initial, required this.countryCodes});
  final List<String> initial;
  final List<String> countryCodes;

  @override
  State<_CitySearchSheet> createState() => _CitySearchSheetState();
}

class _CitySearchSheetState extends State<_CitySearchSheet> {
  late final Set<String> _selected = widget.initial.toSet();
  String _query = '';
  final _manualController = TextEditingController();

  @override
  void dispose() {
    _manualController.dispose();
    super.dispose();
  }

  void _toggle(String city, bool value) {
    setState(() {
      if (value) {
        _selected.add(city);
      } else {
        _selected.remove(city);
      }
    });
  }

  void _addManual() {
    final v = _manualController.text.trim();
    if (v.isEmpty) return;
    if (_selected.contains(v)) {
      _manualController.clear();
      return;
    }
    setState(() {
      _selected.add(v);
      _manualController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final all = citiesForCountries(widget.countryCodes);
    final filtered = all
        .where((c) => c.toLowerCase().contains(_query.toLowerCase().trim()))
        .toList(growable: false);

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
                  hintText: 'Search city…',
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                controller: _manualController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.add_location_alt_outlined),
                  hintText: 'Add manually',
                  suffixIcon: IconButton(
                    onPressed: _addManual,
                    icon: const Icon(Icons.add),
                  ),
                ),
                onSubmitted: (_) => _addManual(),
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text('No results'))
                  : ListView.builder(
                      controller: scroll,
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final city = filtered[i];
                        final selected = _selected.contains(city);
                        return CheckboxListTile(
                          value: selected,
                          onChanged: (v) => _toggle(city, v == true),
                          title: Text(city),
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
                  child: const Text('Done'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
