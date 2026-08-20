import 'package:flutter/material.dart';

import '../../../core/services/firestore_service.dart';
import '../../../core/widgets/field_label.dart';
import '../../../core/widgets/primary_button.dart';
import '../models/entry_kind.dart';
import '../models/planner_entry.dart';
import '../widgets/info_card.dart';

class PlannerForm extends StatefulWidget {
  const PlannerForm({
    super.key,
    required this.kind,
    this.entry,
  });

  final EntryKind kind;
  final PlannerEntry? entry;

  bool get editing => entry != null;

  @override
  State<PlannerForm> createState() => _PlannerFormState();
}

class _PlannerFormState extends State<PlannerForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _notesController;
  late DateTime _date;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  late String _emoji;
  bool _saving = false;

  bool get _isHabit => widget.kind == EntryKind.habit;

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    _nameController = TextEditingController(text: entry?.title ?? '');
    _notesController = TextEditingController(text: entry?.notes ?? '');
    _date = entry?.date ?? DateTime.now();
    _emoji = entry?.emoji ?? (_isHabit ? '🔥' : '📚');
    _startTime = _minutesToTime(entry?.startMinutes);
    _endTime = _minutesToTime(entry?.endMinutes);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noun = _isHabit ? 'Habit' : 'Task';
    final title = '${widget.editing ? 'Edit' : 'Add'} $noun';

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  Center(
                    child: Column(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: _pickEmoji,
                          child: Container(
                            width: 72,
                            height: 72,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              shape: BoxShape.circle,
                              border: Border.all(color: Theme.of(context).dividerColor),
                            ),
                            child: Text(_emoji, style: const TextStyle(fontSize: 38)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(onPressed: _pickEmoji, child: const Text('Change Emoji')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  FieldLabel('$noun Name'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    validator: (value) => (value?.trim().isEmpty ?? true)
                        ? '$noun name is required'
                        : null,
                    decoration: InputDecoration(
                      hintText: _isHabit ? 'e.g. Drink Water' : 'e.g. Read a book',
                    ),
                  ),
                  const SizedBox(height: 20),
                  const FieldLabel('Notes'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _notesController,
                    minLines: 1,
                    maxLines: 4,
                    decoration: const InputDecoration(hintText: 'Add notes (optional)'),
                  ),
                  const SizedBox(height: 20),
                  const FieldLabel('Date'),
                  const SizedBox(height: 8),
                  _PickerBox(
                    icon: Icons.calendar_today_rounded,
                    value: _formatDate(_date),
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 20),
                  if (!_isHabit) ...[
                    const FieldLabel('Time'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _PickerBox(
                            icon: Icons.schedule_rounded,
                            value: _startTime?.format(context) ?? 'Start time',
                            onTap: () => _pickTime(start: true),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _PickerBox(
                            icon: Icons.schedule_rounded,
                            value: _endTime?.format(context) ?? 'End time',
                            onTap: () => _pickTime(start: false),
                          ),
                        ),
                      ],
                    ),
                  ] else
                    const InfoCard(
                      icon: Icons.restart_alt_rounded,
                      title: 'Habit repeats daily',
                      body: 'The habit appears every day starting from the selected date.',
                    ),
                  const SizedBox(height: 28),
                  PrimaryButton(
                    label: _saving
                        ? 'Saving...'
                        : '${widget.editing ? 'Update' : 'Save'} $noun',
                    onPressed: _saving ? () {} : _save,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isHabit && _startTime != null && _endTime != null) {
      if (_timeToMinutes(_endTime!) <= _timeToMinutes(_startTime!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('End time must be after start time.')),
        );
        return;
      }
    }

    setState(() => _saving = true);
    final old = widget.entry;
    final entry = PlannerEntry(
      id: old?.id,
      title: _nameController.text.trim(),
      notes: _notesController.text.trim(),
      kind: widget.kind,
      emoji: _emoji,
      date: DateTime(_date.year, _date.month, _date.day),
      startMinutes: _isHabit || _startTime == null ? null : _timeToMinutes(_startTime!),
      endMinutes: _isHabit || _endTime == null ? null : _timeToMinutes(_endTime!),
      completedDates: old?.completedDates ?? const [],
    );

    try {
      if (widget.editing) {
        await FirestoreService.instance.updateEntry(entry);
      } else {
        await FirestoreService.instance.addEntry(entry);
      }
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save. $error')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (result != null) setState(() => _date = result);
  }

  Future<void> _pickTime({required bool start}) async {
    final initial = start
        ? (_startTime ?? const TimeOfDay(hour: 9, minute: 0))
        : (_endTime ?? const TimeOfDay(hour: 10, minute: 0));
    final result = await showTimePicker(context: context, initialTime: initial);
    if (result == null) return;
    setState(() {
      if (start) {
        _startTime = result;
      } else {
        _endTime = result;
      }
    });
  }

  Future<void> _pickEmoji() async {
    const options = ['📚', '✅', '💼', '🎓', '🏃', '🔥', '💧', '🧘', '💪', '🎯', '📝', '🌅'];
    final result = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
          child: Wrap(
            spacing: 14,
            runSpacing: 14,
            children: options.map((emoji) {
              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => Navigator.pop(context, emoji),
                child: Container(
                  width: 58,
                  height: 58,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 30)),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
    if (result != null) setState(() => _emoji = result);
  }

  static int _timeToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

  static TimeOfDay? _minutesToTime(int? value) => value == null
      ? null
      : TimeOfDay(hour: value ~/ 60, minute: value % 60);

  static String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

class _PickerBox extends StatelessWidget {
  const _PickerBox({
    required this.icon,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(value)),
          ],
        ),
      ),
    );
  }
}
