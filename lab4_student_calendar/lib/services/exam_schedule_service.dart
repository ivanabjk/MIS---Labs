import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/exam_schedule.dart';

class ExamScheduleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addExamSchedule(ExamSchedule examSchedule) async {
    DocumentReference docRef =
        await _firestore.collection('examSchedules').add(examSchedule.toMap());
    examSchedule.id = docRef.id;
  }

  Future<void> updateExamSchedule(ExamSchedule examSchedule) async {
    await _firestore
        .collection('examSchedules')
        .doc(examSchedule.id)
        .update(examSchedule.toMap());
  }

  Future<List<ExamSchedule>> getExamSchedules() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('examSchedules').get();
    return querySnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return ExamSchedule.fromMap({...data, 'id': doc.id});
    }).toList();
  }

  Future<void> deleteExamSchedule(String id) async {
    await _firestore.collection('examSchedules').doc(id).delete();
  }
}
