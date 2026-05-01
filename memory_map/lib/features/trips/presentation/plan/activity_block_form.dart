import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/trip_providers.dart';
import '../../domain/activity_block.dart';

class ActivityBlockForm extends ConsumerStatefulWidget {
  const ActivityBlockForm({
    super.key,
    required this.dayId,
    this.existing,
    this.prefillTitle,
    this.prefillNotes,
  });

  final String dayId;
  final ActivityBlock? existing;
  final String? prefillTitle;
  final String? prefillNotes;

  @override
  ConsumerState<ActivityBlockForm> createState() => _ActivityBlockFormState();
}

class _ActivityBlockFormState extends ConsumerState<ActivityBlockForm> {
  late final TextEditingController _title;
  late final TextEditingController _location;
  late final TextEditingController _notes;
  late TimeOfDay _start;
  late TimeOfDay _end;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _title = TextEditingController(
      text: e?.title ?? widget.prefillTitle ?? '',
    );
    _location = TextEditingController(text: e?.locationText ?? '');
    _notes = TextEditingController(
      text: e?.notes ?? widget.prefillNotes ?? '',
    );
    _start = e == null
        ? const TimeOfDay(hour: 9, minute: 0)
        : TimeOfDay(hour: e.startMinutes ~/ 60, minute: e.startMinutes % 60);
    _end = e == null
        ? const TimeOfDay(hour: 11, minute: 0)
        : TimeOfDay(hour: e.endMinutes ~/ 60, minute: e.endMinutes % 60);
  }

  @override
  void dispose() {
    _title.dispose();
    _location.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickStart() async {
    final picked = await _showScrollTimePicker(initial: _start);
    if (picked != null) setState(() => _start = picked);
  }

  Future<void> _pickEnd() async {
    final picked = await _showScrollTimePicker(initial: _end);
    if (picked != null) setState(() => _end = picked);
  }

  Future<TimeOfDay?> _showScrollTimePicker({required TimeOfDay initial}) async {
    return showModalBottomSheet<TimeOfDay>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _ScrollTimePickerSheet(initial: initial),
    );
  }

  Future<void> _delete() async {
    final navigator = Navigator.of(context);
    await ref.read(tripRepositoryProvider).deleteBlock(widget.existing!.id);
    if (mounted) navigator.pop(true);
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O título é obrigatório.')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final repo = ref.read(tripRepositoryProvider);
      final startMin = _start.hour * 60 + _start.minute;
      final endMin = _end.hour * 60 + _end.minute;
      if (widget.existing == null) {
        await repo.createBlock(
          dayId: widget.dayId,
          startMinutes: startMin,
          endMinutes: endMin,
          title: _title.text.trim(),
          locationText:
              _location.text.trim().isEmpty ? null : _location.text.trim(),
          notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
        );
      } else {
        await repo.updateBlock(widget.existing!.copyWith(
          startMinutes: startMin,
          endMinutes: endMin,
          title: _title.text.trim(),
          locationText: _location.text.trim().isEmpty
              ? null
              : _location.text.trim(),
          notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
        ));
      }
      if (mounted) Navigator.of(context).pop(true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isEdit ? 'Editar bloco' : 'Novo bloco',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickStart,
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Início'),
                      child: Text(_start.format(context)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: _pickEnd,
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Fim'),
                      child: Text(_end.format(context)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _title,
              decoration: const InputDecoration(
                labelText: 'Título',
                hintText: 'Ex: Visita ao Coliseu',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _location,
              decoration: const InputDecoration(
                labelText: 'Localização',
                hintText: 'Endereço ou referência',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notes,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Notas',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                if (isEdit)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _saving ? null : _delete,
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Apagar'),
                    ),
                  ),
                if (isEdit) const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _saving ? null : _save,
                    child: Text(_saving ? 'A guardar…' : 'Guardar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _ScrollTimePickerSheet extends StatefulWidget {
  const _ScrollTimePickerSheet({required this.initial});
  final TimeOfDay initial;

  @override
  State<_ScrollTimePickerSheet> createState() => _ScrollTimePickerSheetState();
}

class _ScrollTimePickerSheetState extends State<_ScrollTimePickerSheet> {
  late int _hour = widget.initial.hour;
  late int _minute = widget.initial.minute;

  late final FixedExtentScrollController _hourCtrl =
      FixedExtentScrollController(initialItem: _hour);
  late final FixedExtentScrollController _minCtrl =
      FixedExtentScrollController(initialItem: _minute);

  @override
  void dispose() {
    _hourCtrl.dispose();
    _minCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Selecionar hora',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(
                    TimeOfDay(hour: _hour, minute: _minute),
                  ),
                  child: const Text('OK'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: Row(
                children: [
                  Expanded(
                    child: ListWheelScrollView.useDelegate(
                      controller: _hourCtrl,
                      itemExtent: 40,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (i) => setState(() => _hour = i),
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: 24,
                        builder: (ctx, i) => Center(
                          child: Text(i.toString().padLeft(2, '0')),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    ':',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ListWheelScrollView.useDelegate(
                      controller: _minCtrl,
                      itemExtent: 40,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (i) => setState(() => _minute = i),
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: 60,
                        builder: (ctx, i) => Center(
                          child: Text(i.toString().padLeft(2, '0')),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
