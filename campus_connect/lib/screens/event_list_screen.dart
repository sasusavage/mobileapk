import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/event_viewmodel.dart';
import '../widgets/loading_indicator.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      final eventViewModel = Provider.of<EventViewModel>(context, listen: false);
      final userId =
          Provider.of<AuthViewModel>(context, listen: false).user?.uid ?? '';
      eventViewModel.initialize();
      eventViewModel.seedSampleEventsIfEmpty(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventViewModel = Provider.of<EventViewModel>(context);
    final userId = Provider.of<AuthViewModel>(context, listen: false).user?.uid ?? '';
    final filteredEvents = eventViewModel.events.where((event) {
      if (_searchQuery.trim().isEmpty) return true;
      final query = _searchQuery.toLowerCase().trim();
      final dateText = DateFormat('EEE, d MMM yyyy').format(event.date).toLowerCase();
      return event.title.toLowerCase().contains(query) ||
          event.description.toLowerCase().contains(query) ||
          dateText.contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Campus Events')),
      body: eventViewModel.isLoading
          ? const LoadingIndicator()
          : eventViewModel.errorMessage != null
              ? Center(child: Text(eventViewModel.errorMessage!))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Search by title, description or date',
                          prefixIcon: Icon(Icons.search_rounded),
                        ),
                      ),
                    ),
                    Expanded(
                      child: filteredEvents.isEmpty
                          ? const Center(child: Text('No matching events found.'))
                          : ListView.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount: filteredEvents.length,
                              itemBuilder: (context, index) {
                                final event = filteredEvents[index];
                                final isLiked =
                                    eventViewModel.isEventLikedByUser(event, userId);
                                final isCreator = event.createdBy == userId;

                                return Card(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          event.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(event.description),
                                        const SizedBox(height: 6),
                                        Text(
                                          DateFormat('EEE, d MMM yyyy')
                                              .format(event.date),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        if (event.latitude != null &&
                                            event.longitude != null)
                                          Text(
                                            'Location: ${event.latitude!.toStringAsFixed(4)}, ${event.longitude!.toStringAsFixed(4)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: userId.isEmpty
                                                  ? null
                                                  : () => eventViewModel
                                                      .toggleLike(event.id, userId),
                                              icon: Icon(
                                                isLiked
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: Colors.red,
                                              ),
                                            ),
                                            Text('${event.likes.length}'),
                                            const SizedBox(width: 8),
                                            IconButton(
                                              onPressed: () => Navigator.pushNamed(
                                                context,
                                                '/comments',
                                                arguments: event.id,
                                              ),
                                              icon: const Icon(
                                                Icons.comment_outlined,
                                              ),
                                            ),
                                            const Spacer(),
                                            if (isCreator)
                                              IconButton(
                                                onPressed: () =>
                                                    _showEditEventDialog(event),
                                                icon: const Icon(
                                                  Icons.edit_outlined,
                                                ),
                                              ),
                                            if (isCreator)
                                              IconButton(
                                                onPressed: () =>
                                                    _confirmDeleteEvent(event.id),
                                                icon: const Icon(
                                                  Icons.delete_outline,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add-event'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showEditEventDialog(Event event) async {
    final titleController = TextEditingController(text: event.title);
    final descriptionController = TextEditingController(text: event.description);
    DateTime selectedDate = event.date;

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Event'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descriptionController,
                      minLines: 2,
                      maxLines: 4,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            DateFormat('d MMM yyyy').format(selectedDate),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 365)),
                              lastDate: DateTime(2035),
                            );
                            if (pickedDate != null) {
                              setDialogState(() {
                                selectedDate = pickedDate;
                              });
                            }
                          },
                          child: const Text('Change Date'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (shouldSave == true) {
      final updatedEvent = Event(
        id: event.id,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        date: selectedDate,
        imageUrl: event.imageUrl,
        latitude: event.latitude,
        longitude: event.longitude,
        createdBy: event.createdBy,
        likes: event.likes,
        comments: event.comments,
      );

      await Provider.of<EventViewModel>(context, listen: false)
          .updateEvent(updatedEvent);
    }
  }

  Future<void> _confirmDeleteEvent(String eventId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
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

    if (shouldDelete == true) {
      await Provider.of<EventViewModel>(context, listen: false)
          .deleteEvent(eventId);
    }
  }
}
