import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../widgets/add_entry_sheet.dart';
import '../widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedDay = 1;
  final Set<int> _completed = {4};

  static const _items = [
    ('📚', 'Read a book', '09:00 AM – 10:00 AM'),
    ('📖', 'Journaling', '10:30 AM'),
    ('🎶', 'Listen calming music', '11:00 AM'),
    ('🏃', 'Running', 'Anytime'),
    ('🌅', 'Wake up', '07:00 AM'),
    ('🧘', 'Stretching', '07:30 AM'),
  ];

  static const _days = [
    ('Sun', '8'),
    ('Mon', '9'),
    ('Tue', '10'),
    ('Wed', '11'),
    ('Thu', '12'),
    ('Fri', '13'),
    ('Sat', '14'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Today',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildCalendar(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                itemCount: _items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, index) {
                  final item = _items[index];
                  return TaskTile(
                    emoji: item.$1,
                    title: item.$2,
                    subtitle: item.$3,
                    done: _completed.contains(index),
                    onTap: () => setState(() {
                      _completed.contains(index)
                          ? _completed.remove(index)
                          : _completed.add(index);
                    }),
                    onEdit: () => Navigator.pushNamed(
                      context,
                      index == 3 ? AppRoutes.editHabit : AppRoutes.editTask,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () => showAddEntrySheet(context),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildCalendar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_days.length, (index) {
          final selected = _selectedDay == index;
          final day = _days[index];

          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _selectedDay = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 42,
              padding: const EdgeInsets.symmetric(vertical: 9),
              decoration: BoxDecoration(
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    day.$1,
                    style: TextStyle(
                      fontSize: 11,
                      color: selected ? Colors.white70 : null,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    day.$2,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
