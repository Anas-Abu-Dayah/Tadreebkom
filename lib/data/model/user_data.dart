class UserData {
  String fullname;
  String bdate;
  String city;
  String country;
  String email;
  bool emailVerified;
  String gender;
  double latitude;
  double longitude;
  String phone;
  String state;
  String street;
  String timestamp;

  UserData({
    required this.fullname,
    required this.bdate,
    required this.city,
    required this.country,
    required this.email,
    required this.emailVerified,
    required this.gender,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.state,
    required this.street,
    required this.timestamp,
  });

  // Convert Firestore data to UserData object
  factory UserData.fromFirestore(Map<String, dynamic> data) {
    return UserData(
      fullname: data['fullname'],
      bdate: data['Bdate'],
      city: data['city'],
      country: data['country'],
      email: data['email'],
      emailVerified: data['emailVerified'],
      gender: data['gender'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      phone: data['phone'],
      state: data['state'],
      street: data['street'],
      timestamp: data['timestamp'],
    );
  }
}
