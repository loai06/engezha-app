import 'package:flutter/material.dart';

import '../../planner/models/entry_kind.dart';
import '../../planner/screens/planner_form.dart';
import 'add_choice.dart';

Future<void> showAddEntrySheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add New',
              style: Theme.of(sheetContext)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text('What do you want to add?'),
            const SizedBox(height: 20),
            AddChoice(
              emoji: '📚',
              title: 'Task',
              subtitle: 'Add a new task',
              onTap: () {
                Navigator.pop(sheetContext);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PlannerForm(kind: EntryKind.task),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            AddChoice(
              emoji: '🔥',
              title: 'Habit',
              subtitle: 'Add a daily habit',
              onTap: () {
                Navigator.pop(sheetContext);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PlannerForm(kind: EntryKind.habit),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(sheetContext),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    ),
  );
}
