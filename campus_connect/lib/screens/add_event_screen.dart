import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/event_viewmodel.dart';
import '../widgets/custom_button.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _imagePath;
  Position? _currentLocation;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _pickLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enable location services first.')),
      );
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission denied.')),
      );
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = position;
    });
  }

  Future<void> _saveEvent() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and description are required.')),
      );
      return;
    }

    final userId = Provider.of<AuthViewModel>(context, listen: false).user?.uid ?? '';
    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in first.')),
      );
      return;
    }

    final event = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      date: _selectedDate,
      imageUrl: _imagePath ?? '',
      latitude: _currentLocation?.latitude,
      longitude: _currentLocation?.longitude,
      createdBy: userId,
    );

    await Provider.of<EventViewModel>(context, listen: false).addEvent(event);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Event')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              prefixIcon: Icon(Icons.title_rounded),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _descriptionController,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Description',
              prefixIcon: Icon(Icons.description_outlined),
            ),
          ),
          const SizedBox(height: 14),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today_outlined),
            title: Text('Date: ${DateFormat('d MMM yyyy').format(_selectedDate)}'),
            trailing: TextButton(
              onPressed: _pickDate,
              child: const Text('Pick'),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.camera_alt_outlined),
            title: Text(_imagePath == null ? 'No image selected' : 'Image selected'),
            trailing: TextButton(
              onPressed: _pickImage,
              child: const Text('Capture'),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.my_location_outlined),
            title: Text(
              _currentLocation == null
                  ? 'No location selected'
                  : 'Location: ${_currentLocation!.latitude.toStringAsFixed(4)}, ${_currentLocation!.longitude.toStringAsFixed(4)}',
            ),
            trailing: TextButton(
              onPressed: _pickLocation,
              child: const Text('Use GPS'),
            ),
          ),
          const SizedBox(height: 16),
          CustomButton(
            label: 'Save Event',
            icon: Icons.save_outlined,
            onPressed: _saveEvent,
          ),
        ],
      ),
    );
  }
}
