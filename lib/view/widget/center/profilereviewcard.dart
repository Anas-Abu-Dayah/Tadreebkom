// lib/view/widget/center/profilereviewcard.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class ProfileReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;

  const ProfileReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    // Reviewer name
    final String username = review['reviewerName'] as String? ?? 'Anonymous';

    // Raw createdAt could be Timestamp, DateTime, or String
    final rawDate = review['createdAt'];
    DateTime? dt;
    if (rawDate is Timestamp) {
      dt = rawDate.toDate();
    } else if (rawDate is DateTime) {
      dt = rawDate;
    } else if (rawDate is String) {
      dt = DateTime.tryParse(rawDate);
    }
    final String date =
        dt != null ? DateFormat('MMM d, yyyy').format(dt) : 'Unknown date';

    // Comment and rating
    final String comment = review['comment'] as String? ?? '';
    final double rating = (review['rating'] as num?)?.toDouble() ?? 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(128, 128, 128, 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name & Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                username,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                date,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Star rating
          RatingBarIndicator(
            rating: rating,
            itemBuilder:
                (context, index) =>
                    const Icon(Icons.star, color: Colors.orange),
            itemCount: 5,
            itemSize: 20.0,
            direction: Axis.horizontal,
          ),
          const SizedBox(height: 8),

          // Comment
          Text(
            comment.isNotEmpty ? comment : "No comment provided.",
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
