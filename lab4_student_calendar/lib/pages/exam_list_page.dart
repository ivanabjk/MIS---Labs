import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lab4_student_calendar/providers/user_provider.dart';

import '../domain/exam_schedule.dart';

class ExamListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Exam Schedules')),
      body: FutureBuilder<List<ExamSchedule>>(
        future: userProvider.getExamSchedules(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No exam schedules found.');
          } else {
            final exams = snapshot.data!;
            return ListView.builder(
              itemCount: exams.length,
              itemBuilder: (context, index) {
                final exam = exams[index];
                return ListTile(
                  title: Text(exam.examName),
                  subtitle: Text('${exam.dateTime} at ${exam.location}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      userProvider.deleteExamSchedule(exam.id);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
