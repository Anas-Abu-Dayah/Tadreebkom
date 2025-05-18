import 'package:flutter/material.dart';

class InstructorCard extends StatelessWidget {
  final String name;
  final dynamic profileImage;
  final String email;
  final VoidCallback onDelete;
  final VoidCallback onProfilepage;

  final VoidCallback onScheduale;

  const InstructorCard({
    super.key,
    required this.name,
    required this.profileImage,
    required this.onDelete,
    required this.email,
    required this.onProfilepage,
    required this.onScheduale,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Color.fromRGBO(250, 248, 248, 0.7),
      elevation: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 2),
          CircleAvatar(
            backgroundColor: Colors.grey[400],
            radius: 30,
            backgroundImage:
                (profileImage is String && profileImage.isNotEmpty)
                    ? NetworkImage(profileImage) // Display image if it's a URL
                    : null, // If no image, backgroundImage remains null
            child:
                profileImage is String && profileImage.isEmpty
                    ? Icon(Icons.person, size: 30, color: Colors.white)
                    : null, // Display icon if profileImage is empty
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3),
          Text(
            email,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 9,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.info_outline, color: Colors.orangeAccent),
                onPressed: onProfilepage,
              ),
              IconButton(
                icon: Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.orangeAccent,
                ),
                onPressed: onScheduale,
              ),

              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.orangeAccent),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
