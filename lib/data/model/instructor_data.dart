import 'package:cloud_firestore/cloud_firestore.dart';

class InstructorData {
  final String id; // The instructor's unique ID
  final String name; // The instructor's name
  final String imageUrl; // The URL of the instructor's profile image
  final List<Availability>
  availability; // List of availability for this instructor

  InstructorData({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.availability,
  });

  // Factory constructor to create an instance from Firestore document data
  factory InstructorData.fromMap(Map<String, dynamic> data, String docId) {
    var availabilityList =
        (data['availability'] as List<dynamic>?)
            ?.map((e) => Availability.fromMap(e))
            .toList() ??
        [];

    return InstructorData(
      id: docId,
      name: data['username'] ?? '',
      imageUrl: data['photoURL'] ?? '',
      availability: availabilityList, // Initialize availability
    );
  }

  // Method to convert to Map for Firestore writing
  Map<String, dynamic> toMap() {
    return {
      'username': name,
      'photoURL': imageUrl,
      'availability': availability.map((avail) => avail.toMap()).toList(),
    };
  }
}

class Availability {
  final String date; // The date for which the instructor is available
  final List<TimeSlot> times; // List of available times on that date

  Availability({required this.date, required this.times});

  // Factory constructor to create an instance from Firestore document data
  factory Availability.fromMap(Map<String, dynamic> map) {
    var timesList =
        (map['times'] as List<dynamic>?)
            ?.map((e) => TimeSlot.fromMap(e))
            .toList() ??
        [];

    return Availability(date: map['date'] ?? '', times: timesList);
  }

  // Method to convert to Map for Firestore writing
  Map<String, dynamic> toMap() {
    return {'date': date, 'times': times.map((time) => time.toMap()).toList()};
  }
}

class TimeSlot {
  final String time; // Time slot (e.g., "09:00")
  final bool available; // Whether the instructor is available at this time

  TimeSlot({required this.time, required this.available});

  // Factory constructor to create an instance from Firestore document data
  factory TimeSlot.fromMap(Map<String, dynamic> map) {
    return TimeSlot(
      time: map['time'] ?? '',
      available: map['available'] ?? false,
    );
  }

  // Method to convert to Map for Firestore writing
  Map<String, dynamic> toMap() {
    return {'time': time, 'available': available};
  }
}

class Appointment {
  final DateTime dateTime; // The date and time of the appointment

  Appointment({required this.dateTime});

  // Factory constructor to create an instance from Firestore document data
  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(dateTime: (map['dateTime'] as Timestamp).toDate());
  }

  // Method to convert to Map for Firestore writing
  Map<String, dynamic> toMap() {
    return {'dateTime': Timestamp.fromDate(dateTime)};
  }

  // Check if this appointment conflicts with the given date and time
  bool conflictsWith(DateTime dateTime) {
    return this.dateTime.isAtSameMomentAs(dateTime);
  }
}
