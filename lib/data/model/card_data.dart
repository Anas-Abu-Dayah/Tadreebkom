class CardData {
  final String cardNumber;
  final String expiryDate;
  final String cardholderName;
  final String cvv;

  const CardData({
    required this.cardNumber,
    required this.expiryDate,
    required this.cardholderName,
    required this.cvv,
  });

  // Method to format the card number for display
  String getFormattedCardNumber() {
    if (cardNumber.length != 19) {
      // 16 digits + 3 spaces = 19 characters
      return cardNumber; // Return as-is if not in expected format
    }
    // Extract the last 4 digits
    final lastFour = cardNumber.substring(15, 19); // Last 4 digits after spaces
    return '**** **** **** $lastFour';
  }

  // Factory constructor to create an instance from Firestore document data
  factory CardData.fromMap(Map<String, dynamic> data) {
    return CardData(
      cardholderName: data['cardholderName'] ?? '',
      cardNumber: data['cardNumber'] ?? '',
      expiryDate: data['expiryDate'] ?? '',
      cvv: data['cvv'] ?? '',
    );
  }

  // Method to convert the CardData instance to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'cardholderName': cardholderName,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvv': cvv,
    };
  }
}
