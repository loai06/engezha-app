import 'package:flutter/material.dart';

import '../../../core/widgets/field_label.dart';
import '../../../core/widgets/primary_button.dart';
import '../models/entry_kind.dart';
import '../widgets/info_card.dart';
import '../widgets/time_box.dart';

class PlannerForm extends StatefulWidget {
  const PlannerForm({
    super.key,
    required this.kind,
    this.editing = false,
  });

  final EntryKind kind;
  final bool editing;

  @override
  State<PlannerForm> createState() => _PlannerFormState();
}

class _PlannerFormState extends State<PlannerForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _notesController;

  bool get _isHabit => widget.kind == EntryKind.habit;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.editing
          ? (_isHabit ? 'Drink Water' : 'Read a book')
          : '',
    );
    _notesController = TextEditingController(
      text: widget.editing
          ? (_isHabit
              ? 'Drink 8 glasses of water'
              : 'Read at least 20 pages')
          : '',
    );
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
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        child: Text(
                          _isHabit ? '🔥' : '📚',
                          style: const TextStyle(fontSize: 38),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('Change Emoji'),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                FieldLabel('$noun Name'),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText:
                        _isHabit ? 'e.g. Drink Water' : 'e.g. Read a book',
                  ),
                ),
                const SizedBox(height: 20),
                const FieldLabel('Notes'),
                const SizedBox(height: 8),
                TextField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    hintText: 'Add notes (optional)',
                  ),
                ),
                const SizedBox(height: 20),
                if (!_isHabit)
                  const Row(
                    children: [
                      Expanded(
                        child: TimeBox(
                          label: 'Start Time',
                          value: '09:00 AM',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: TimeBox(
                          label: 'End Time',
                          value: '10:00 AM',
                        ),
                      ),
                    ],
                  )
                else
                  const InfoCard(
                    icon: Icons.restart_alt_rounded,
                    title: 'Habit resets daily',
                    body:
                        'This habit will restart automatically\nat 12:00 AM everyday.',
                  ),
                const SizedBox(height: 28),
                PrimaryButton(
                  label: '${widget.editing ? 'Update' : 'Save'} $noun',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '$noun ${widget.editing ? 'updated' : 'saved'} (UI demo)',
                        ),
                      ),
                    );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
