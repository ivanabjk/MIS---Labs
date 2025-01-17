import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:lab4_student_calendar/providers/user_provider.dart';
import 'package:lab4_student_calendar/domain/exam_schedule.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  void _loadMarkers() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.getExamSchedules().then((examSchedules) {
      setState(() {
        _markers = examSchedules.map((exam) {
          final latLng = exam.location.split(',');
          return Marker(
            markerId: MarkerId(exam.id!),
            position: LatLng(double.parse(latLng[0]), double.parse(latLng[1])),
            infoWindow: InfoWindow(
              title: exam.examName,
              snippet: 'Time: ${exam.dateTime}\nLocation: ${exam.location}',
            ),
          );
        }).toSet();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0),
          zoom: 2,
        ),
        markers: _markers,
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
