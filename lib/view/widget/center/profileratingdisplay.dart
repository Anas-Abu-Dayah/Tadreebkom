import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProfileRatingDisplay extends StatelessWidget {
  final double rating;

  const ProfileRatingDisplay({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              rating.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(width: 8),
            Text(
              _getRatingText(rating),
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
        SizedBox(height: 8),
        RatingBarIndicator(
          rating: rating,
          itemBuilder:
              (context, index) => Icon(Icons.star, color: Colors.orange),
          itemCount: 5,
          itemSize: 30,
          unratedColor: Colors.grey[300],
        ),
      ],
    );
  }

  String _getRatingText(double rating) {
    if (rating >= 4.5) return 'Excellent';
    if (rating >= 3.5) return 'Very Good';
    if (rating >= 2.5) return 'Good';
    if (rating >= 1.5) return 'Fair';
    return 'Poor';
  }
}
