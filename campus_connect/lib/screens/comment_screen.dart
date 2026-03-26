import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/event_viewmodel.dart';

class CommentScreen extends StatefulWidget {
  final String eventId;

  const CommentScreen({super.key, required this.eventId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final user = Provider.of<AuthViewModel>(context, listen: false).user;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in first.')),
      );
      return;
    }

    final comment = Comment(
      userId: user.uid,
      userName: user.email ?? 'User',
      text: text,
      timestamp: DateTime.now(),
    );

    await Provider.of<EventViewModel>(context, listen: false)
        .addComment(widget.eventId, comment);

    if (!mounted) return;
    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final eventViewModel = Provider.of<EventViewModel>(context);

    Event? event;
    for (final item in eventViewModel.events) {
      if (item.id == widget.eventId) {
        event = item;
        break;
      }
    }

    final selectedEvent = event;

    return Scaffold(
      appBar: AppBar(title: const Text('Comments')),
      body: selectedEvent == null
          ? const Center(child: Text('Event not found.'))
          : Column(
              children: [
                Expanded(
                  child: selectedEvent.comments.isEmpty
                      ? const Center(child: Text('No comments yet.'))
                      : ListView.builder(
                          itemCount: selectedEvent.comments.length,
                          itemBuilder: (context, index) {
                            final comment = selectedEvent.comments[index];
                            return ListTile(
                              leading: const Icon(Icons.person_outline_rounded),
                              title: Text(comment.userName),
                              subtitle: Text(comment.text),
                              trailing: Text(
                                DateFormat('HH:mm').format(comment.timestamp),
                              ),
                            );
                          },
                        ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            decoration: const InputDecoration(
                              hintText: 'Add a comment...',
                              prefixIcon: Icon(Icons.chat_bubble_outline_rounded),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: _addComment,
                          icon: const Icon(Icons.send_rounded),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
