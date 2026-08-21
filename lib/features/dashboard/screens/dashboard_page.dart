import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/services/firestore_service.dart';
import '../../planner/models/planner_entry.dart';
import '../widgets/metric_row.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: StreamBuilder<List<PlannerEntry>>(
        stream: FirestoreService.instance.watchAllEntries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Could not load progress: ${snapshot.error}'));
          }

          final entries = snapshot.data ?? const <PlannerEntry>[];
          final today = _dateOnly(DateTime.now());
          final weekStart = today.subtract(Duration(days: today.weekday % 7));
          final days =
              List.generate(7, (index) => weekStart.add(Duration(days: index)));
          final totals = <int>[];
          final completed = <int>[];

          for (final day in days) {
            final applicable =
                entries.where((entry) => entry.appliesTo(day)).toList();
            totals.add(applicable.length);
            completed.add(
                applicable.where((entry) => entry.isCompletedFor(day)).length);
          }

          final todayEntries =
              entries.where((entry) => entry.appliesTo(today)).toList();
          final todayCompleted =
              todayEntries.where((entry) => entry.isCompletedFor(today)).length;
          final totalToday = todayEntries.length;
          final remaining = totalToday - todayCompleted;
          final todayPercent =
              totalToday == 0 ? 0.0 : todayCompleted / totalToday;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Weekly Progress',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const Chip(label: Text('This Week')),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 190,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(7, (index) {
                    final percent = totals[index] == 0
                        ? 0.0
                        : completed[index] / totals[index];
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${completed[index]}/${totals[index]}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 11),
                          ),
                          const SizedBox(height: 7),
                          Container(
                            height: 110 * percent + 8,
                            width: 16,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            '${(percent * 100).round()}%',
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w700),
                          ),
                          Text(_weekday(days[index].weekday),
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 34),
              Text(
                "Today's Progress",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          MetricRow(label: 'Total', value: '$totalToday'),
                          const SizedBox(height: 12),
                          MetricRow(
                              label: 'Completed', value: '$todayCompleted'),
                          const SizedBox(height: 12),
                          MetricRow(label: 'Remaining', value: '$remaining'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 80),
                    SizedBox.square(
                      dimension: 130,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SemiCircleProgress(
                            value: todayPercent,
                            strokeWidth: 15,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static String _weekday(int weekday) =>
      const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][weekday - 1];
}

class SemiCircleProgress extends StatelessWidget {
  const SemiCircleProgress({
    super.key,
    required this.value,
    this.strokeWidth = 10,
    required this.backgroundColor,
  });

  final double value;
  final double strokeWidth;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final percentage = (value.clamp(0.0, 1.0) * 100).round();

    return SizedBox(
      width: 220,
      height: 135,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Transform.translate(
            offset: const Offset(0, -50),
            child: CustomPaint(
              size: const Size(220, 115),
              painter: SemiCirclePainter(
                progress: value,
                strokeWidth: strokeWidth,
                progressColor: colors.primary,
                backgroundColor: backgroundColor,
              ),
            ),
          ),
          Positioned(
            bottom: 25,
            child: Column(
              children: [
                Text(
                  '$percentage%',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Progress',
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.65),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SemiCirclePainter extends CustomPainter {
  const SemiCirclePainter({
    required this.progress,
    required this.strokeWidth,
    required this.progressColor,
    required this.backgroundColor,
  });

  final double progress;
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final safeProgress = progress.clamp(0.0, 1.0);

    final center = Offset(
      size.width / 2,
      size.height,
    );

    final radius = math.min(
      size.width / 2 - strokeWidth,
      size.height - strokeWidth,
    );

    final arcRectangle = Rect.fromCircle(
      center: center,
      radius: radius,
    );

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      arcRectangle,
      math.pi,
      math.pi,
      false,
      backgroundPaint,
    );

    canvas.drawArc(
      arcRectangle,
      math.pi,
      math.pi * safeProgress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant SemiCirclePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
