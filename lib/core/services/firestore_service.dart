import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/planner/models/planner_entry.dart';
import '../../features/profile/models/user_profile.dart';
import 'auth_service.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _uid {
    final uid = AuthService.instance.currentUser?.uid;
    if (uid == null) {
      throw StateError('No signed-in user.');
    }
    return uid;
  }

  CollectionReference<Map<String, dynamic>> get _entries =>
      _firestore.collection('users').doc(_uid).collection('entries');

  DocumentReference<Map<String, dynamic>> get _profile =>
      _firestore.collection('users').doc(_uid);

  Stream<List<PlannerEntry>> watchAllEntries() {
    return _entries
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(PlannerEntry.fromDocument)
            .toList(growable: false));
  }

  Stream<UserProfile> watchProfile() {
    return _profile.snapshots().map((doc) {
      final authUser = AuthService.instance.currentUser;
      final data = doc.data() ?? const <String, dynamic>{};
      return UserProfile(
        uid: doc.id,
        name: (data['name'] as String?)?.trim().isNotEmpty == true
            ? data['name'] as String
            : (authUser?.displayName ?? 'Engezha User'),
        email: (data['email'] as String?) ?? authUser?.email ?? '',
      );
    });
  }

  Future<void> addEntry(PlannerEntry entry) async {
    await _entries.add(entry.toFirestore(isNew: true));
  }

  Future<void> updateEntry(PlannerEntry entry) async {
    if (entry.id == null) {
      throw ArgumentError('Entry id is required for update.');
    }
    await _entries.doc(entry.id).update(entry.toFirestore(isNew: false));
  }

  Future<void> deleteEntry(String id) => _entries.doc(id).delete();

  Future<void> toggleCompletion(PlannerEntry entry, DateTime date) async {
    if (entry.id == null) return;

    final key = PlannerEntry.dateKey(date);
    final completed = entry.completedDates.contains(key);

    await _entries.doc(entry.id).update({
      'completedDates': completed
          ? FieldValue.arrayRemove([key])
          : FieldValue.arrayUnion([key]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
