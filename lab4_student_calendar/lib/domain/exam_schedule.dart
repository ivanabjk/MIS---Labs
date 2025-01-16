import 'package:cloud_firestore/cloud_firestore.dart';

class ExamSchedule {
  String id;
  final String examName;
  final DateTime dateTime; // Combining date and time
  final String location;

  ExamSchedule({this.id = "", required this.examName, required this.dateTime, required this.location});

  Map<String, dynamic> toMap() {
    return {
      //'id': id,
      'examName': examName,
      'dateTime': Timestamp.fromDate(dateTime),
      'location': location,
    };
  }

  factory ExamSchedule.fromMap(Map<String, dynamic> map) {
    return ExamSchedule(
      id: map['id'],
      examName: map['examName'],
      dateTime: (map['dateTime'] as Timestamp).toDate(),
      location: map['location'],
    );
  }
}
