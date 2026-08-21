import 'package:flutter/material.dart';

import '../../../core/services/firestore_service.dart';
import '../../planner/models/planner_entry.dart';
import '../../planner/screens/planner_form.dart';
import '../widgets/add_entry_sheet.dart';
import '../widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DateTime _selectedDate;
  late DateTime _weekStart;

  @override
  void initState() {
    super.initState();
    _selectedDate = _dateOnly(DateTime.now());
    _weekStart = _startOfWeek(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isToday(_selectedDate) ? 'Today' : _formatDate(_selectedDate),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildCalendar(),
            Expanded(
              child: StreamBuilder<List<PlannerEntry>>(
                stream: FirestoreService.instance.watchAllEntries(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return _MessageState(
                      icon: Icons.cloud_off_rounded,
                      title: 'Could not load your planner',
                      body: '${snapshot.error}',
                    );
                  }

                  final entries = (snapshot.data ?? const <PlannerEntry>[])
                      .where((entry) => entry.appliesTo(_selectedDate))
                      .toList()
                    ..sort((a, b) => (a.startMinutes ?? 9999)
                        .compareTo(b.startMinutes ?? 9999));

                  if (entries.isEmpty) {
                    return const _MessageState(
                      icon: Icons.event_note_rounded,
                      title: 'Nothing planned yet',
                      body: 'Tap + to add your first task or habit.',
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, index) {
                      final entry = entries[index];
                      return TaskTile(
                        emoji: entry.emoji,
                        title: entry.title,
                        subtitle: entry.subtitleFor(_selectedDate),
                        done: entry.isCompletedFor(_selectedDate),
                        onToggle: () => FirestoreService.instance
                            .toggleCompletion(entry, _selectedDate),
                        onEdit: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlannerForm(
                              kind: entry.kind,
                              entry: entry,
                            ),
                          ),
                        ),
                        onDelete: () => _confirmDelete(entry),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: const CircleBorder(),
        onPressed: () => showAddEntrySheet(context),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Future<void> _confirmDelete(PlannerEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete entry?'),
        content: Text('Delete “${entry.title}”? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && entry.id != null) {
      await FirestoreService.instance.deleteEntry(entry.id!);
    }
  }

  Widget _buildCalendar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    final selectedBackground =
    isDark ? const Color(0xFF343434) : Colors.black;

    const selectedTextColor = Colors.white;

    final dates =
    List.generate(7, (index) => _weekStart.add(Duration(days: index)));

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: IconButton(
              padding: EdgeInsets.zero,
              tooltip: 'Previous week',
              onPressed: () => setState(() {
                _weekStart =
                    _weekStart.subtract(const Duration(days: 7));
                _selectedDate = _weekStart;
              }),
              icon: const Icon(Icons.chevron_left_rounded),
            ),
          ),

          Expanded(
            child: Row(
              children: dates.map((date) {
                final selected = _sameDate(_selectedDate, date);

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () =>
                          setState(() => _selectedDate = date),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding:
                        const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                          color: selected
                              ? selectedBackground
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _weekday(date.weekday),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 9,
                                color: selected
                                    ? selectedTextColor.withValues(
                                  alpha: 0.7,
                                )
                                    : colors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${date.day}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: selected
                                    ? selectedTextColor
                                    : colors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(
            width: 36,
            child: IconButton(
              padding: EdgeInsets.zero,
              tooltip: 'Next week',
              onPressed: () => setState(() {
                _weekStart =
                    _weekStart.add(const Duration(days: 7));
                _selectedDate = _weekStart;
              }),
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ),
        ],
      ),
    );
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime _startOfWeek(DateTime date) =>
      _dateOnly(date).subtract(Duration(days: date.weekday % 7));

  static bool _sameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static bool _isToday(DateTime date) => _sameDate(date, DateTime.now());

  static String _weekday(int weekday) =>
      const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][weekday - 1];

  static String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 54,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(height: 14),
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(body, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
