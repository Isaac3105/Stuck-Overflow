import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/trip_providers.dart';
import '../widgets/cities_field.dart';
import '../widgets/country_picker.dart';
import '../widgets/shake_widget.dart';

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

  final _nameShakeKey = GlobalKey<ShakeWidgetState>();
  final _rangeShakeKey = GlobalKey<ShakeWidgetState>();
  final _countriesShakeKey = GlobalKey<ShakeWidgetState>();
  final _buttonShakeKey = GlobalKey<ShakeWidgetState>();

  String? _nameError;
  String? _rangeError;
  String? _countriesError;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final trips = ref.read(allTripsProvider).valueOrNull ?? [];

    bool isBlocked(DateTime date) {
      final d = DateTime(date.year, date.month, date.day);
      for (final t in trips) {
        final s = DateTime(t.startDate.year, t.startDate.month, t.startDate.day);
        final e = DateTime(t.endDate.year, t.endDate.month, t.endDate.day);
        if (!d.isBefore(s) && !d.isAfter(e)) return true;
      }
      return false;
    }

    // Find the first available start date starting from today
    DateTime initialStart = DateTime(now.year, now.month, now.day);
    while (isBlocked(initialStart)) {
      initialStart = initialStart.add(const Duration(days: 1));
      // Safety break to avoid infinite loop
      if (initialStart.year > now.year + 5) break;
    }

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      initialDateRange: _range ??
          DateTimeRange(
            start: initialStart,
            end: initialStart.add(const Duration(days: 6)),
          ),
      selectableDayPredicate: (day, start, end) {
        if (isBlocked(day)) return false;
        if (start != null && end == null) {
          // We are picking the end date. 
          // Ensure no blocked days exist between start and day.
          DateTime s = start.isBefore(day) ? start : day;
          DateTime e = start.isBefore(day) ? day : start;
          
          DateTime curr = s;
          while (!curr.isAfter(e)) {
            if (isBlocked(curr)) return false;
            curr = curr.add(const Duration(days: 1));
          }
        }
        return true;
      },
    );
    if (picked != null) {
      setState(() {
        _range = picked;
        _rangeError = null;
      });
    }
  }

  Future<void> _save() async {
    bool hasError = false;
    setState(() {
      _nameError = null;
      _rangeError = null;
      _countriesError = null;
    });

    if (_name.text.trim().isEmpty) {
      _nameError = 'Trip name is required';
      _nameShakeKey.currentState?.shake();
      hasError = true;
    }
    if (_range == null) {
      _rangeError = 'Date range is required';
      _rangeShakeKey.currentState?.shake();
      hasError = true;
    }
    if (_countries.isEmpty) {
      _countriesError = 'Select at least one country';
      _countriesShakeKey.currentState?.shake();
      hasError = true;
    }

    if (hasError) {
      _buttonShakeKey.currentState?.shake();
      setState(() {});
      return;
    }

    // Overlap check
    final trips = ref.read(allTripsProvider).valueOrNull ?? [];
    final rangeStart = DateTime(_range!.start.year, _range!.start.month, _range!.start.day);
    final rangeEnd = DateTime(_range!.end.year, _range!.end.month, _range!.end.day);

    for (final t in trips) {
      final tStart = DateTime(t.startDate.year, t.startDate.month, t.startDate.day);
      final tEnd = DateTime(t.endDate.year, t.endDate.month, t.endDate.day);

      // Overlap: (S1 <= E2) && (E1 >= S2)
      if ((!rangeStart.isBefore(tStart) && !rangeEnd.isBefore(tStart)) || (!rangeStart.isAfter(tEnd) && !rangeEnd.isAfter(tEnd))) {
        setState(() => _rangeError = 'This trip overlaps with "${t.name}"');
        _rangeShakeKey.currentState?.shake();
        _buttonShakeKey.currentState?.shake();
        return;
      }
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

  Widget _buildLabel(String label, bool mandatory) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: label),
          if (mandatory)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('d MMM yyyy', 'en');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New trip',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ShakeWidget(
            key: _nameShakeKey,
            child: TextField(
              controller: _name,
              onChanged: (_) {
                if (_nameError != null) setState(() => _nameError = null);
              },
              decoration: InputDecoration(
                label: _buildLabel('Trip name', true),
                hintText: 'e.g. Summer in Greece',
                errorText: _nameError,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ShakeWidget(
            key: _rangeShakeKey,
            child: InkWell(
              onTap: _pickRange,
              borderRadius: BorderRadius.circular(12),
              child: InputDecorator(
                decoration: InputDecoration(
                  label: _buildLabel('Dates', true),
                  suffixIcon: const Icon(Icons.calendar_month),
                  errorText: _rangeError,
                ),
                child: Text(_range == null
                    ? 'Pick dates'
                    : '${df.format(_range!.start)} → ${df.format(_range!.end)}'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ShakeWidget(
            key: _countriesShakeKey,
            child: CountryPickerField(
              selected: _countries,
              mandatory: true,
              errorText: _countriesError,
              onChanged: (v) => setState(() {
                _countries = v;
                _countriesError = null;
                _cities = [];
              }),
            ),
          ),
          const SizedBox(height: 16),
          CitiesField(
            selectedCountries: _countries,
            cities: _cities,
            onChanged: (v) => setState(() => _cities = v),
          ),
          const SizedBox(height: 24),
          ShakeWidget(
            key: _buttonShakeKey,
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: const Icon(Icons.check),
                label: Text(_saving ? 'Creating…' : 'Create trip'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

