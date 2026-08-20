import 'package:cloud_firestore/cloud_firestore.dart';

import 'entry_kind.dart';

class PlannerEntry {
  const PlannerEntry({
    this.id,
    required this.title,
    required this.notes,
    required this.kind,
    required this.emoji,
    required this.date,
    this.startMinutes,
    this.endMinutes,
    this.completedDates = const [],
  });

  final String? id;
  final String title;
  final String notes;
  final EntryKind kind;
  final String emoji;
  final DateTime date;
  final int? startMinutes;
  final int? endMinutes;
  final List<String> completedDates;

  bool get isHabit => kind == EntryKind.habit;

  bool isCompletedFor(DateTime target) => completedDates.contains(dateKey(target));

  bool appliesTo(DateTime target) {
    final normalizedTarget = DateTime(target.year, target.month, target.day);
    final normalizedStart = DateTime(date.year, date.month, date.day);
    if (isHabit) return !normalizedStart.isAfter(normalizedTarget);
    return _sameDate(normalizedStart, normalizedTarget);
  }

  String subtitleFor(DateTime target) {
    if (isHabit) return 'Daily habit';
    if (startMinutes == null) return 'Anytime';
    final start = _formatMinutes(startMinutes!);
    if (endMinutes == null) return start;
    return '$start – ${_formatMinutes(endMinutes!)}';
  }

  PlannerEntry copyWith({
    String? id,
    String? title,
    String? notes,
    EntryKind? kind,
    String? emoji,
    DateTime? date,
    int? startMinutes,
    int? endMinutes,
    List<String>? completedDates,
  }) {
    return PlannerEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      kind: kind ?? this.kind,
      emoji: emoji ?? this.emoji,
      date: date ?? this.date,
      startMinutes: startMinutes ?? this.startMinutes,
      endMinutes: endMinutes ?? this.endMinutes,
      completedDates: completedDates ?? this.completedDates,
    );
  }

  Map<String, dynamic> toFirestore({required bool isNew}) {
    final data = <String, dynamic>{
      'title': title.trim(),
      'notes': notes.trim(),
      'kind': kind.name,
      'emoji': emoji,
      'date': Timestamp.fromDate(DateTime(date.year, date.month, date.day)),
      'startMinutes': startMinutes,
      'endMinutes': endMinutes,
      'completedDates': completedDates,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (isNew) data['createdAt'] = FieldValue.serverTimestamp();
    return data;
  }

  factory PlannerEntry.fromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    final kindName = data['kind'] as String? ?? EntryKind.task.name;
    final timestamp = data['date'] as Timestamp?;
    return PlannerEntry(
      id: doc.id,
      title: data['title'] as String? ?? 'Untitled',
      notes: data['notes'] as String? ?? '',
      kind: kindName == EntryKind.habit.name ? EntryKind.habit : EntryKind.task,
      emoji: data['emoji'] as String? ??
          (kindName == EntryKind.habit.name ? '🔥' : '📚'),
      date: timestamp?.toDate() ?? DateTime.now(),
      startMinutes: (data['startMinutes'] as num?)?.toInt(),
      endMinutes: (data['endMinutes'] as num?)?.toInt(),
      completedDates: List<String>.from(
        (data['completedDates'] as List<dynamic>?) ?? const [],
      ),
    );
  }

  static String dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  static bool _sameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static String _formatMinutes(int value) {
    final hour24 = value ~/ 60;
    final minute = value % 60;
    final period = hour24 >= 12 ? 'PM' : 'AM';
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    return '${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }
}
