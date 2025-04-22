import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminCalendar extends StatefulWidget {
  const AdminCalendar({super.key});

  @override
  State<AdminCalendar> createState() => _AdminCalendarState();
}

class _AdminCalendarState extends State<AdminCalendar> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eventController = TextEditingController();
  DateTime? selectedDate;

  Future<List<Map<String, dynamic>>> fetchEvents() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('AcademicCalander').get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'Event': data['Event'] ?? '',
          'Date': data['Date'] != null ? DateTime.parse(data['Date']) : null,
        };
      }).toList();
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  Future<void> addEvent() async {
    if (_formKey.currentState!.validate() && selectedDate != null) {
      try {
        await _firestore.collection('AcademicCalander').add({
          'Date': selectedDate!.toIso8601String(),
          'Event': _eventController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Event added successfully!')));
        _eventController.clear();
        setState(() {});
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add event: $e')));
      }
    }
  }

  Future<void> updateEvent(String docId) async {
    if (_formKey.currentState!.validate() && selectedDate != null) {
      try {
        await _firestore.collection('AcademicCalander').doc(docId).update({
          'Date': selectedDate!.toIso8601String(),
          'Event': _eventController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Event updated successfully!')));
        setState(() {});
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update event: $e')));
      }
    }
  }

  void _showAddOrUpdateDialog({String? docId, String? currentEvent, DateTime? currentDate}) {
    _eventController.text = currentEvent ?? '';
    selectedDate = currentDate;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(docId == null ? 'Add Event' : 'Update Event'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _eventController,
                      decoration: InputDecoration(labelText: 'Event Name'),
                      validator: (value) => value!.trim().isEmpty ? 'Please enter an event name' : null,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() => selectedDate = pickedDate);
                        }
                      },
                      child: Text(selectedDate != null ? 'Date: ${selectedDate!.toLocal()}'.split(' ')[0] : 'Pick a Date'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (docId == null) {
                        addEvent();
                      } else {
                        updateEvent(docId);
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(docId == null ? 'Add' : 'Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Academic Calendar")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No events found.'));
          } else {
            final events = snapshot.data!;
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final item = events[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.asset(
                      "assets/image/Attendance/google-calendar.png",
                      height: 30,
                      width: 30,
                    ),
                    title: Text('Date: ${item['Date'] != null ? item['Date'].toString().split(' ')[0] : 'N/A'}'),
                    subtitle: Text('Event: ${item['Event']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () => _showAddOrUpdateDialog(
                        docId: item['id'],
                        currentEvent: item['Event'],
                        currentDate: item['Date'],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOrUpdateDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
