import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() => runApp(const SuperPlannerApp());

class SuperPlannerApp extends StatefulWidget {
  const SuperPlannerApp({super.key});

  @override
  State<SuperPlannerApp> createState() => _SuperPlannerAppState();
}

class _SuperPlannerAppState extends State<SuperPlannerApp> {
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF000000);
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Super Planner',
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: _theme(Brightness.light, seed),
      darkTheme: _theme(Brightness.dark, seed),
      home: LoginPage(
        onLogin: () => _replace(const PlannerShell()),
        onSignUp: () =>
            _push(SignUpPage(onDone: () => _replace(const PlannerShell()))),
      ),
      routes: {
        '/task/add': (_) => const PlannerForm(kind: EntryKind.task),
        '/habit/add': (_) => const PlannerForm(kind: EntryKind.habit),
        '/task/edit': (_) =>
            const PlannerForm(kind: EntryKind.task, editing: true),
        '/habit/edit': (_) =>
            const PlannerForm(kind: EntryKind.habit, editing: true),
      },
      builder: (context, child) => ThemeController(
        darkMode: darkMode,
        setDarkMode: (value) => setState(() => darkMode = value),
        child: child!,
      ),
    );
  }

  ThemeData _theme(Brightness brightness, Color seed) {
    final dark = brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
  seedColor: seed,
  brightness: brightness,
).copyWith(
  primary: brightness == Brightness.light
      ? Colors.black
      : Colors.white,
  onPrimary: brightness == Brightness.light
      ? Colors.white
      : Colors.black,
),
      scaffoldBackgroundColor:
          dark ? const Color(0xFF111318) : Colors.white,
      fontFamily: 'Inter',
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? const Color(0xFF1C1F26) : Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: dark ? Colors.white12 : Colors.white)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: dark ? Colors.white : const Color(0xFF111827),
                width: 1.5)),
      ),
    );
  }

  void _push(Widget page) =>
      navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => page));
  void _replace(Widget page) => navigatorKey.currentState
      ?.pushReplacement(MaterialPageRoute(builder: (_) => page));
}

final navigatorKey = GlobalKey<NavigatorState>();

class ThemeController extends InheritedWidget {
  const ThemeController(
      {super.key,
      required this.darkMode,
      required this.setDarkMode,
      required super.child});
  final bool darkMode;
  final ValueChanged<bool> setDarkMode;
  static ThemeController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ThemeController>()!;
  @override
  bool updateShouldNotify(ThemeController oldWidget) =>
      darkMode != oldWidget.darkMode;
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, required this.onLogin, required this.onSignUp});
  final VoidCallback onLogin;
  final VoidCallback onSignUp;

  @override
  Widget build(BuildContext context) => AuthFrame(
        children: [
          const SizedBox(height: 22),
          Text('Engezha',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800, fontSize: 35)),
          const SizedBox(height: 6),
          Image.asset(
            'assets/images/logo.png',
            width: 160,
            height: 160,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 28),
          const FieldLabel('Email'),
          const SizedBox(height: 8),
          const TextField(
              decoration: InputDecoration(
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.mail_outline_rounded))),
           const FieldLabel('Password'),
          const SizedBox(height: 8),
          const TextField(
              decoration: InputDecoration(
                  hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.lock_outline_rounded))),
          const SizedBox(height: 30),
          PrimaryButton(label: 'Login', onPressed: onLogin),
          const Spacer(),
          Center(
              child: TextButton(
                  onPressed: onSignUp,
                  child: const Text("Don't have an account?  Sign Up"))),
        ],
      );
}

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key, required this.onDone});
  final VoidCallback onDone;
  @override
  Widget build(BuildContext context) => AuthFrame(
        children: [
          const SizedBox(height: 25),
          Text('Create Account',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 7),
          const Text("Let's get you started", textAlign: TextAlign.center),
          const SizedBox(height: 34),
          ..._fields(),
          const SizedBox(height: 24),
          PrimaryButton(label: 'Sign Up', onPressed: onDone),
          const Spacer(),
          Center(
              child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Already have an account?  Login'))),
        ],
      );

  List<Widget> _fields() => const [
        FieldLabel('Full Name'),
        SizedBox(height: 8),
        TextField(
            decoration: InputDecoration(
                hintText: 'Enter your full name',
                prefixIcon: Icon(Icons.person_outline_rounded))),
        SizedBox(height: 18),
        FieldLabel('Email'),
        SizedBox(height: 8),
        TextField(
            decoration: InputDecoration(
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.mail_outline_rounded))),
        SizedBox(height: 18),
        FieldLabel('Password'),
        SizedBox(height: 8),
        TextField(
            obscureText: true,
            decoration: InputDecoration(
                hintText: 'Create a password',
                prefixIcon: Icon(Icons.lock_outline_rounded),
                suffixIcon: Icon(Icons.visibility_off_outlined))),
        SizedBox(height: 18),
        FieldLabel('Confirm Password'),
        SizedBox(height: 8),
        TextField(
            obscureText: true,
            decoration: InputDecoration(
                hintText: 'Confirm your password',
                prefixIcon: Icon(Icons.lock_outline_rounded),
                suffixIcon: Icon(Icons.visibility_off_outlined))),
      ];
}

class AuthFrame extends StatelessWidget {
  const AuthFrame({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: children))))),
      );
}

class HeroIllustration extends StatelessWidget {
  const HeroIllustration({super.key});
  @override
  Widget build(BuildContext context) => Container(
        height: 150,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(28)),
        child: const Text('🗒️  🎯  🪴', style: TextStyle(fontSize: 54)),
      );
}

class PlannerShell extends StatefulWidget {
  const PlannerShell({super.key});
  @override
  State<PlannerShell> createState() => _PlannerShellState();
}

class _PlannerShellState extends State<PlannerShell> {
  int index = 0;
  final pages = const [HomePage(), DashboardPage(), ProfilePage()];
  @override
  Widget build(BuildContext context) => Scaffold(
        body: IndexedStack(index: index, children: pages),
        bottomNavigationBar: NavigationBar(
          height: 70,
          selectedIndex: index,
          onDestinationSelected: (value) => setState(() => index = value),
          indicatorColor:
              Theme.of(context).colorScheme.primary.withValues(alpha: .12),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home'),
            NavigationDestination(
                icon: Icon(Icons.insert_chart_outlined_rounded),
                selectedIcon: Icon(Icons.insert_chart_rounded),
                label: 'Dashboard'),
            NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profile'),
          ],
        ),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedDay = 1;
  final completed = <int>{4};
  final items = const [
    ('📚', 'Read a book', '09:00 AM – 10:00 AM'),
    ('📖', 'Journaling', '10:30 AM'),
    ('🎶', 'Listen calming music', '11:00 AM'),
    ('🏃', 'Running', 'Anytime'),
    ('🌅', 'Wake up', '07:00 AM'),
    ('🧘', 'Stretching', '07:30 AM'),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: const Text('Today',
                style: TextStyle(fontWeight: FontWeight.w800)),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none_rounded))
            ]),
        body: SafeArea(
            child: Column(children: [
          _calendar(),
          Expanded(
              child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => TaskTile(
                      emoji: items[i].$1,
                      title: items[i].$2,
                      subtitle: items[i].$3,
                      done: completed.contains(i),
                      onTap: () => setState(() => completed.contains(i)
                          ? completed.remove(i)
                          : completed.add(i)),
                      onEdit: () => Navigator.pushNamed(
                          context, i == 3 ? '/habit/edit' : '/task/edit')))),
        ])),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            onPressed: () => showAddSheet(context),
            child: const Icon(Icons.add_rounded)),
      );

  Widget _calendar() {
    const days = [
      ('Sun', '8'),
      ('Mon', '9'),
      ('Tue', '10'),
      ('Wed', '11'),
      ('Thu', '12'),
      ('Fri', '13'),
      ('Sat', '14')
    ];
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(days.length, (i) {
              final selected = selectedDay == i;
              return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => setState(() => selectedDay = i),
                  child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 42,
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                          color: selected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(children: [
                        Text(days[i].$1,
                            style: TextStyle(
                                fontSize: 11,
                                color: selected ? Colors.white70 : null)),
                        const SizedBox(height: 5),
                        Text(days[i].$2,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: selected ? Colors.white : null))
                      ])));
            })));
  }
}

class TaskTile extends StatelessWidget {
  const TaskTile(
      {super.key,
      required this.emoji,
      required this.title,
      required this.subtitle,
      required this.done,
      required this.onTap,
      required this.onEdit});
  final String emoji, title, subtitle;
  final bool done;
  final VoidCallback onTap, onEdit;
  @override
  Widget build(BuildContext context) => Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
            onLongPress: onEdit,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  Text(emoji, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 13),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(title,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                decoration:
                                    done ? TextDecoration.lineThrough : null)),
                        const SizedBox(height: 4),
                        Text(subtitle,
                            style: Theme.of(context).textTheme.bodySmall)
                      ])),
                  IconButton(
                      onPressed: onTap,
                      icon: Icon(
                          done
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          color: done
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey)),
                ]))),
      );
}

Future<void> showAddSheet(BuildContext context) => showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Add New',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    const Text('What do you want to add?'),
                    const SizedBox(height: 20),
                    AddChoice(
                        emoji: '⚖️',
                        title: 'Task',
                        subtitle: 'Add a new task',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/task/add');
                        }),
                    const SizedBox(height: 12),
                    AddChoice(
                        emoji: '🔥',
                        title: 'Habit',
                        subtitle: 'Add a new habit',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/habit/add');
                        }),
                    const SizedBox(height: 12),
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel')),
                  ]))),
    );

class AddChoice extends StatelessWidget {
  const AddChoice(
      {super.key,
      required this.emoji,
      required this.title,
      required this.subtitle,
      required this.onTap});
  final String emoji, title, subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(14)),
      child: ListTile(
          onTap: onTap,
          leading: Text(emoji, style: const TextStyle(fontSize: 27)),
          title:
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right_rounded)));
}

enum EntryKind { task, habit }

class PlannerForm extends StatefulWidget {
  const PlannerForm({super.key, required this.kind, this.editing = false});
  final EntryKind kind;
  final bool editing;
  @override
  State<PlannerForm> createState() => _PlannerFormState();
}

class _PlannerFormState extends State<PlannerForm> {
  late final TextEditingController name;
  late final TextEditingController notes;
  bool get habit => widget.kind == EntryKind.habit;
  @override
  void initState() {
    super.initState();
    name = TextEditingController(
        text: widget.editing ? (habit ? 'Drink Water' : 'Read a book') : '');
    notes = TextEditingController(
        text: widget.editing
            ? (habit ? 'Drink 8 glasses of water' : 'Read at least 20 pages')
            : '');
  }

  @override
  void dispose() {
    name.dispose();
    notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noun = habit ? 'Habit' : 'Task';
    final title = '${widget.editing ? 'Edit' : 'Add'} $noun';
    return Scaffold(
      appBar: AppBar(
          title:
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800))),
      body: SafeArea(
          child: Center(
              child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      children: [
                        Center(
                            child: Column(children: [
                          Container(
                              width: 72,
                              height: 72,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Theme.of(context).dividerColor)),
                              child: Text(habit ? '🔥' : '📚',
                                  style: const TextStyle(fontSize: 38))),
                          const SizedBox(height: 8),
                          const Text('Change Emoji')
                        ])),
                        const SizedBox(height: 26),
                        FieldLabel('$noun Name'),
                        const SizedBox(height: 8),
                        TextField(
                            controller: name,
                            decoration: InputDecoration(
                                hintText: habit
                                    ? 'e.g. Drink Water'
                                    : 'e.g. Read a book')),
                        const SizedBox(height: 20),
                        const FieldLabel('Notes'),
                        const SizedBox(height: 8),
                        TextField(
                            controller: notes,
                            decoration: const InputDecoration(
                                hintText: 'Add notes (optional)')),
                        const SizedBox(height: 20),
                        if (!habit)
                          Row(children: const [
                            Expanded(
                                child: TimeBox(
                                    label: 'Start Time', value: '09:00 AM')),
                            SizedBox(width: 12),
                            Expanded(
                                child: TimeBox(
                                    label: 'End Time', value: '10:00 AM'))
                          ])
                        else
                          InfoCard(
                              icon: Icons.restart_alt_rounded,
                              title: 'Habit resets daily',
                              body:
                                  'This habit will restart automatically\nat 12:00 AM everyday.'),
                        const SizedBox(height: 28),
                        PrimaryButton(
                            label:
                                '${widget.editing ? 'Update' : 'Save'} $noun',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      '$noun ${widget.editing ? 'updated' : 'saved'} (UI demo)')));
                              Navigator.pop(context);
                            }),
                      ])))),
    );
  }
}

class TimeBox extends StatelessWidget {
  const TimeBox({super.key, required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        FieldLabel(label),
        const SizedBox(height: 8),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Expanded(
                  child: Text(value,
                      style: const TextStyle(fontWeight: FontWeight.w600))),
              const Icon(Icons.schedule_rounded, size: 19)
            ]))
      ]);
}

class InfoCard extends StatelessWidget {
  const InfoCard(
      {super.key, required this.icon, required this.title, required this.body});
  final IconData icon;
  final String title, body;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14)),
      child: Row(children: [
        Icon(icon),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(body, style: Theme.of(context).textTheme.bodySmall)
        ])
      ]));
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    const values = [40, 60, 30, 45, 35, 35, 50];
    const tasks = [6, 9, 7, 9, 6, 7, 9];
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Scaffold(
        appBar: AppBar(
          title: const Text('Progress',
              style: TextStyle(fontWeight: FontWeight.w800)),
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.settings_outlined))
          ],
        ),
        body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Weekly Progress',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const Chip(label: Text('This Week')),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 180,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(
                    7,
                    (i) => Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('${tasks[i]}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 7),
                          Container(
                            height: values[i] * 1.35,
                            width: 16,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text('${values[i]}%',
                              style: const TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w700)),
                          Text(days[i],
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 34),
              Text("Today's Progress",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        children: [
                          MetricRow(label: 'Total Tasks', value: '07'),
                          SizedBox(height: 12),
                          MetricRow(label: 'Completed', value: '05'),
                          SizedBox(height: 12),
                          MetricRow(label: 'Remaining', value: '02'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    SizedBox.square(
                      dimension: 112,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: .85,
                            strokeWidth: 10,
                            backgroundColor: Theme.of(context).dividerColor,
                          ),
                          const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('85%',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800)),
                              Text('Completed', style: TextStyle(fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]));
  }
}

class MetricRow extends StatelessWidget {
  const MetricRow({super.key, required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800))
      ]);
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = ThemeController.of(context);
    return Scaffold(
      appBar: AppBar(
          title: const Text('Profile',
              style: TextStyle(fontWeight: FontWeight.w800))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        children: [
          const CircleAvatar(
              radius: 48, child: Icon(Icons.person_rounded, size: 58)),
          const SizedBox(height: 24),
          const ProfileData(label: 'Name', value: 'John Doe'),
          const Divider(height: 28),
          const ProfileData(label: 'Email', value: 'johndoe@email.com'),
          const SizedBox(height: 20),
          ProfileItem(
            icon: Icons.lock_outline_rounded,
            title: 'Edit Password',
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          ProfileItem(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Theme',
            trailing: Switch(
                value: controller.darkMode, onChanged: controller.setDarkMode),
            onTap: () => controller.setDarkMode(!controller.darkMode),
          ),
          ProfileItem(
            icon: Icons.language_rounded,
            title: 'Language',
            trailing: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text('English'), Icon(Icons.chevron_right_rounded)],
            ),
            onTap: () {},
          ),
          const SizedBox(height: 28),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => LoginPage(
                    onLogin: () => navigatorKey.currentState?.pushReplacement(
                      MaterialPageRoute(builder: (_) => const PlannerShell()),
                    ),
                    onSignUp: () => navigatorKey.currentState?.push(
                      MaterialPageRoute(
                          builder: (_) => SignUpPage(
                                onDone: () =>
                                    navigatorKey.currentState?.pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) => const PlannerShell()),
                                ),
                              )),
                    ),
                  ),
                ),
                (route) => false,
              );
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

class ProfileData extends StatelessWidget {
  const ProfileData({super.key, required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Row(children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const Spacer(),
        Text(value)
      ]);
}

class ProfileItem extends StatelessWidget {
  const ProfileItem(
      {super.key,
      required this.icon,
      required this.title,
      required this.trailing,
      required this.onTap});
  final IconData icon;
  final String title;
  final Widget trailing;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing);
}

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700));
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {super.key, required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => SizedBox(
      height: 54,
      child: FilledButton(
          style: FilledButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          onPressed: onPressed,
          child: Text(label,
              style: const TextStyle(fontWeight: FontWeight.w700))));
}
