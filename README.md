# Super Planner

A UI-only Flutter implementation of the supplied Super Planner design.

## Included

- Login and sign-up screens
- Home schedule with selectable days and completion states
- Add Task / Add Habit bottom sheet and forms
- Edit Task / Edit Habit forms
- Dashboard progress screen
- Profile screen and working light/dark theme switch
- Responsive phone-width layout

There is no backend or persistent storage. Interactions are intentionally local UI demonstrations.

## Run

```bash
flutter pub get
flutter run
```

If you want to generate native Android, iOS, Windows, macOS, and Linux runner
folders too, run `flutter create .` once inside this folder. It keeps the custom
`lib/main.dart` intact and adds the platform boilerplate for your installed SDK.
