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
  DateTime? _startDate;
  DateTime? _endDate;
  bool _saving = false;

  final _nameShakeKey = GlobalKey<ShakeWidgetState>();
  final _startShakeKey = GlobalKey<ShakeWidgetState>();
  final _endShakeKey = GlobalKey<ShakeWidgetState>();
  final _countriesShakeKey = GlobalKey<ShakeWidgetState>();
  final _buttonShakeKey = GlobalKey<ShakeWidgetState>();

  String? _nameError;
  String? _startError;
  String? _endError;
  String? _countriesError;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  bool _isBlocked(DateTime date) {
    final trips = ref.read(allTripsProvider).valueOrNull ?? [];
    final d = DateTime(date.year, date.month, date.day);
    for (final t in trips) {
      final s = DateTime(t.startDate.year, t.startDate.month, t.startDate.day);
      final e = DateTime(t.endDate.year, t.endDate.month, t.endDate.day);
      if (!d.isBefore(s) && !d.isAfter(e)) return true;
    }
    return false;
  }

  Future<void> _pickStart() async {
    final now = DateTime.now();
    
    // Find a valid initial date
    DateTime initial = DateTime(now.year, now.month, now.day);
    while (_isBlocked(initial)) {
      initial = initial.add(const Duration(days: 1));
      if (initial.year > now.year + 5) break;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? initial,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      selectableDayPredicate: (day) => !_isBlocked(day),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        _startError = null;
        // Reset end date if it's now invalid
        if (_endDate != null && (_endDate!.isBefore(_startDate!) || _isRangeBlocked(_startDate!, _endDate!))) {
          _endDate = null;
        }
      });
    }
  }

  bool _isRangeBlocked(DateTime start, DateTime end) {
    final trips = ref.read(allTripsProvider).valueOrNull ?? [];
    final s1 = DateTime(start.year, start.month, start.day);
    final e1 = DateTime(end.year, end.month, end.day);
    for (final t in trips) {
      final s2 = DateTime(t.startDate.year, t.startDate.month, t.startDate.day);
      final e2 = DateTime(t.endDate.year, t.endDate.month, t.endDate.day);
      if (!s1.isAfter(e2) && !e1.isBefore(s2)) return true;
    }
    return false;
  }

  Future<void> _pickEnd() async {
    if (_startDate == null) {
      setState(() => _startError = 'Select start date first');
      _startShakeKey.currentState?.shake();
      return;
    }

    final now = DateTime.now();
    final trips = ref.read(allTripsProvider).valueOrNull ?? [];
    
    // Find the first blocked date after start
    DateTime? firstBlocked;
    for (final t in trips) {
      final s = DateTime(t.startDate.year, t.startDate.month, t.startDate.day);
      if (s.isAfter(_startDate!)) {
        if (firstBlocked == null || s.isBefore(firstBlocked)) {
          firstBlocked = s;
        }
      }
    }

    final last = firstBlocked?.subtract(const Duration(days: 1)) ?? DateTime(now.year + 5);
    final initial = _endDate ?? _startDate!;
    
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isAfter(last) ? last : initial,
      firstDate: _startDate!,
      lastDate: last,
      selectableDayPredicate: (day) => !_isBlocked(day),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
        _endError = null;
      });
    }
  }

  Future<void> _save() async {
    bool hasError = false;
    setState(() {
      _nameError = null;
      _startError = null;
      _endError = null;
      _countriesError = null;
    });

    if (_name.text.trim().isEmpty) {
      _nameError = 'Trip name is required';
      _nameShakeKey.currentState?.shake();
      hasError = true;
    }
    if (_startDate == null) {
      _startError = 'Required';
      _startShakeKey.currentState?.shake();
      hasError = true;
    }
    if (_endDate == null) {
      _endError = 'Required';
      _endShakeKey.currentState?.shake();
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

    // Final overlap check
    if (_isRangeBlocked(_startDate!, _endDate!)) {
      setState(() => _endError = 'Range overlaps with another trip');
      _endShakeKey.currentState?.shake();
      return;
    }

    setState(() => _saving = true);
    try {
      final repo = ref.read(tripRepositoryProvider);
      final trip = await repo.createTrip(
        name: _name.text.trim(),
        countries: _countries,
        cities: _cities,
        startDate: _startDate!,
        endDate: _endDate!,
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
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ShakeWidget(
                    key: _startShakeKey,
                    child: GestureDetector(
                      onTap: _pickStart,
                      behavior: HitTestBehavior.opaque,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          label: _buildLabel('Start', true),
                          errorText: _startError,
                          prefixIcon: const Icon(Icons.calendar_today, size: 20),
                        ),
                        child: Text(
                          _startDate == null ? 'Date' : df.format(_startDate!),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 13,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ShakeWidget(
                    key: _endShakeKey,
                    child: GestureDetector(
                      onTap: _pickEnd,
                      behavior: HitTestBehavior.opaque,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          label: _buildLabel('End', true),
                          errorText: _endError,
                          prefixIcon: const Icon(Icons.event, size: 20),
                        ),
                        child: Text(
                          _endDate == null ? 'Date' : df.format(_endDate!),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 13,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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

