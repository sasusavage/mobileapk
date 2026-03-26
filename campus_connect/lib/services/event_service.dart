import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class EventService {
  final CollectionReference _eventsCollection =
      FirebaseFirestore.instance.collection('events');

  Future<void> seedSampleEventsIfEmpty(String createdBy) async {
    final snapshot = await _eventsCollection.limit(1).get();
    if (snapshot.docs.isNotEmpty) return;

    final now = DateTime.now();
    final sampleEvents = [
      Event(
        id: 'seed_${now.millisecondsSinceEpoch}_1',
        title: 'Campus Worship Night',
        description:
            'Join students at the main chapel for worship, prayer, and fellowship.',
        date: now.add(const Duration(days: 2)),
        createdBy: createdBy,
      ),
      Event(
        id: 'seed_${now.millisecondsSinceEpoch}_2',
        title: 'Flutter Study Jam',
        description:
            'Practical coding session for INFT 425 students. Bring your laptop.',
        date: now.add(const Duration(days: 4)),
        createdBy: createdBy,
      ),
      Event(
        id: 'seed_${now.millisecondsSinceEpoch}_3',
        title: 'Career Mentorship Meetup',
        description:
            'Connect with alumni and mentors for internship and career guidance.',
        date: now.add(const Duration(days: 7)),
        createdBy: createdBy,
      ),
    ];

    final batch = FirebaseFirestore.instance.batch();
    for (final event in sampleEvents) {
      final docRef = _eventsCollection.doc(event.id);
      batch.set(docRef, event.toMap());
    }
    await batch.commit();
  }

  Stream<List<Event>> getEvents() {
    return _eventsCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(
              (doc) => Event.fromMap(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ),
            )
            .toList());
  }

  Future<void> addEvent(Event event) async {
    await _eventsCollection.doc(event.id).set(event.toMap());
  }

  Future<void> updateEvent(Event event) async {
    await _eventsCollection.doc(event.id).update(event.toMap());
  }

  Future<void> deleteEvent(String eventId) async {
    await _eventsCollection.doc(eventId).delete();
  }

  Future<void> toggleLike(String eventId, String userId) async {
    final docRef = _eventsCollection.doc(eventId);
    final doc = await docRef.get();

    if (!doc.exists) return;

    final data = doc.data() as Map<String, dynamic>?;
    final likes = List<String>.from(data?['likes'] ?? []);

    if (likes.contains(userId)) {
      likes.remove(userId);
    } else {
      likes.add(userId);
    }

    await docRef.update({'likes': likes});
  }

  Future<void> addComment(String eventId, Comment comment) async {
    final docRef = _eventsCollection.doc(eventId);
    await docRef.update({
      'comments': FieldValue.arrayUnion([comment.toMap()]),
    });
  }
}
