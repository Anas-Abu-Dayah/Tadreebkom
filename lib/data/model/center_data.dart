import 'package:cloud_firestore/cloud_firestore.dart';

class CenterData {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> tags; // Optional, based on your tags field
  final String about;
  final String address;
  final String city;
  final String country;
  final String email;
  final bool emailVerified;
  final String drivingCenterName;
  final double latitude;
  final double longitude;
  final String phone;
  final double rating;
  final String state;
  final String street;
  final DateTime timestamp;

  const CenterData({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.tags, // Assuming you have a tag list in Firestore
    required this.about,
    required this.address,
    required this.city,
    required this.country,
    required this.email,
    required this.emailVerified,
    required this.drivingCenterName,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.rating,
    required this.state,
    required this.street,
    required this.timestamp,
  });

  // Convert Firestore data to CenterData object
  factory CenterData.fromFirestore(Map<String, dynamic> data) {
    return CenterData(
      id: data['id'] ?? '',
      name: data['drivingCenterName'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      about: data['about'] ?? '',
      address: data['address'] ?? '',
      city: data['city'] ?? '',
      country: data['country'] ?? '',
      email: data['email'] ?? '',
      emailVerified: data['emailVerified'] ?? false,
      drivingCenterName: data['drivingCenterName'] ?? '',
      latitude: data['latitude'] ?? 0.0,
      longitude: data['longitude'] ?? 0.0,
      phone: data['phone'] ?? '',
      rating: data['rating'] ?? 0.0,
      state: data['state'] ?? '',
      street: data['street'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  // Add fromMap method to convert Firestore data to CenterData
  factory CenterData.fromMap(Map<String, dynamic> data, [String? id]) {
    return CenterData(
      id: data['id'] ?? '',
      name: data['drivingCenterName'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      about: data['about'] ?? '',
      address: data['address'] ?? '',
      city: data['city'] ?? '',
      country: data['country'] ?? '',
      email: data['email'] ?? '',
      emailVerified: data['emailVerified'] ?? false,
      drivingCenterName: data['drivingCenterName'] ?? '',
      latitude: data['latitude'] ?? 0.0,
      longitude: data['longitude'] ?? 0.0,
      phone: data['phone'] ?? '',
      rating: data['rating'] ?? 0.0,
      state: data['state'] ?? '',
      street: data['street'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
