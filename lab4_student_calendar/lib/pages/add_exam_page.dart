import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:lab4_student_calendar/providers/user_provider.dart';
import 'package:lab4_student_calendar/services/location_service.dart';
import 'package:provider/provider.dart';

import '../domain/exam_schedule.dart'; // Import for date formatting

class AddExamPage extends StatefulWidget {
  final DateTime selectedDate;

  AddExamPage({required this.selectedDate});

  @override
  _AddExamPageState createState() => _AddExamPageState();
}

class _AddExamPageState extends State<AddExamPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  late DateTime _selectedDate;
  TimeOfDay _selectedTime = TimeOfDay.now();
  //Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    //_getLocation();
  }

  // void _getLocation() async {
  //   Position position = await LocationService().getCurrentLocation();
  //   setState(() {
  //     _currentPosition = position;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // Format the date
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedDate = formatter.format(_selectedDate);
    final String formattedTime = _selectedTime.format(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Exam'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // Exam Name Input
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Exam Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the exam name';
                  }
                  return null;
                },
              ),
              // Location Input
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
              ),
              // Date Picker
              Row(
                children: <Widget>[
                  Text('Date: $formattedDate'),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != _selectedDate) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Text('Select date'),
                  ),
                ],
              ),
              // Time Picker
              Row(
                children: <Widget>[
                  Text('Time: $formattedTime'),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (pickedTime != null && pickedTime != _selectedTime) {
                        setState(() {
                          _selectedTime = pickedTime;
                        });
                      }
                    },
                    child: Text('Select time'),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final DateTime dateTime = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                      _selectedTime.hour,
                      _selectedTime.minute,
                    );
                    final newSchedule = ExamSchedule(
                      examName: _nameController.text,
                      dateTime: dateTime,
                      location: _locationController.text,
                    );
                    userProvider.addExamSchedule(newSchedule);
                    Navigator.pop(context); // Close the form after adding
                  }
                },
                child: Text('Submit'),
              ),
              // _currentPosition == null
              //     ? CircularProgressIndicator()
              //     : Text(
              //         'Current Location: Lat: ${_currentPosition!.latitude}, Lon:${_currentPosition!.longitude}',
              //       ),
            ],
          ),
        ),
      ),
    );
  }
}
