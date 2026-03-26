import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event.dart';
import '../services/event_service.dart';

class EventViewModel extends ChangeNotifier {
  final EventService _eventService = EventService();

  List<Event> _events = [];
  bool _isLoading = true;
  String? _errorMessage;
  final Set<String> _locallyLikedEventIds = <String>{};

  StreamSubscription<List<Event>>? _eventsSubscription;
  bool _initialized = false;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    await _loadLikedEventIds();
    listenToEvents();
  }

  Future<void> seedSampleEventsIfEmpty(String userId) async {
    if (userId.isEmpty) return;
    try {
      await _eventService.seedSampleEventsIfEmpty(userId);
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }
  }

  Future<void> _loadLikedEventIds() async {
    final preferences = await SharedPreferences.getInstance();
    final likedIds = preferences.getStringList('liked_event_ids') ?? [];
    _locallyLikedEventIds
      ..clear()
      ..addAll(likedIds);
  }

  Future<void> _saveLikedEventIds() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      'liked_event_ids',
      _locallyLikedEventIds.toList(),
    );
  }

  void listenToEvents() {
    _eventsSubscription?.cancel();
    _eventsSubscription = _eventService.getEvents().listen(
      (eventList) {
        _events = eventList;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        _errorMessage = error.toString();
        notifyListeners();
      },
    );
  }

  bool isEventLikedByUser(Event event, String userId) {
    if (event.likes.contains(userId)) return true;
    return _locallyLikedEventIds.contains(event.id);
  }

  Future<void> addEvent(Event event) async {
    try {
      await _eventService.addEvent(event);
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      await _eventService.updateEvent(event);
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _eventService.deleteEvent(eventId);
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }
  }

  Future<void> toggleLike(String eventId, String userId) async {
    if (_locallyLikedEventIds.contains(eventId)) {
      _locallyLikedEventIds.remove(eventId);
    } else {
      _locallyLikedEventIds.add(eventId);
    }

    await _saveLikedEventIds();
    notifyListeners();

    try {
      await _eventService.toggleLike(eventId, userId);
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }
  }

  Future<void> addComment(String eventId, Comment comment) async {
    try {
      await _eventService.addComment(eventId, comment);
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _eventsSubscription?.cancel();
    super.dispose();
  }
}
