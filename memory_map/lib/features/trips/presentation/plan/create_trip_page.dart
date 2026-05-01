import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/trip_providers.dart';
import '../widgets/cities_field.dart';
import '../widgets/country_picker.dart';

class CreateTripPage extends ConsumerStatefulWidget {
  const CreateTripPage({super.key});

  @override
  ConsumerState<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends ConsumerState<CreateTripPage> {
  final _name = TextEditingController();
  List<String> _countries = [];
  List<String> _cities = [];
  DateTimeRange? _range;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      initialDateRange: _range ??
          DateTimeRange(
            start: now,
            end: now.add(const Duration(days: 6)),
          ),
    );
    if (picked != null) setState(() => _range = picked);
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty || _range == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nome e período são obrigatórios.')),
      );
      return;
    }
    if (_countries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleciona pelo menos um país.')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final repo = ref.read(tripRepositoryProvider);
      final trip = await repo.createTrip(
        name: _name.text.trim(),
        countries: _countries,
        cities: _cities,
        startDate: _range!.start,
        endDate: _range!.end,
      );
      if (!mounted) return;
      context.go('/plan/${trip.id}');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('d MMM yyyy', 'pt_PT');
    return Scaffold(
      appBar: AppBar(title: const Text('Nova viagem')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(
              labelText: 'Nome da viagem',
              hintText: 'Ex: Verão na Grécia',
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: _pickRange,
            borderRadius: BorderRadius.circular(12),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Período',
                suffixIcon: Icon(Icons.calendar_month),
              ),
              child: Text(_range == null
                  ? 'Escolhe as datas'
                  : '${df.format(_range!.start)} → ${df.format(_range!.end)}'),
            ),
          ),
          const SizedBox(height: 16),
          CountryPickerField(
            selected: _countries,
            onChanged: (v) => setState(() {
              _countries = v;
              // Keep only cities that still make sense; user can re-add later.
              // We don't hard-block custom cities, but we clear to encourage correct filtering.
              _cities = [];
            }),
          ),
          const SizedBox(height: 16),
          CitiesField(
            selectedCountries: _countries,
            cities: _cities,
            onChanged: (v) => setState(() => _cities = v),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.check),
            label: Text(_saving ? 'A criar…' : 'Criar viagem'),
          ),
        ],
      ),
    );
  }
}
