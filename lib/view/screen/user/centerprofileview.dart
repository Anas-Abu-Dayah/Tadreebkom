// lib/view/screen/user/center_profile_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/controller/usercontroller/centerprofileviewcontroller.dart';
import 'package:tadreebkomapplication/core/functions/alertexitapp.dart';
import 'package:tadreebkomapplication/core/constant/color.dart';
import 'package:tadreebkomapplication/view/widget/center/profileratingdisplay.dart';
import 'package:tadreebkomapplication/view/widget/center/profilesectionheader.dart';
import 'package:tadreebkomapplication/view/widget/center/profilereviewcard.dart';
import 'package:tadreebkomapplication/view/widget/user/state_box.dart';

class CenterProfileView extends StatelessWidget {
  CenterProfileView({super.key});
  final CenterProfController controller = Get.put(CenterProfController());

  @override
  Widget build(BuildContext context) {
    controller.fetchCenterData();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.pagePrimaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: AppColor.pagePrimaryColor,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) {
            final shouldPop = await alertExitApp();
            if (shouldPop) Get.back();
          }
        },
        child: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return CustomScrollView(
              slivers: [
                // ── HEADER SLIVER ─────────────────────────────────────────────────────────
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Avatar & Name
                      Center(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[200],
                          backgroundImage:
                              controller.centerImage.value.isNotEmpty
                                  ? NetworkImage(controller.centerImage.value)
                                  : null,
                          child:
                              controller.centerImage.value.isEmpty
                                  ? const Icon(
                                    Icons.image,
                                    size: 40,
                                    color: Colors.grey,
                                  )
                                  : null,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        controller.centerName.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          StatBox(
                            label: 'Instructors',
                            count: controller.instructorCount.value,
                          ),
                          StatBox(
                            label: 'Students',
                            count: controller.studentCount.value,
                          ),
                          StatBox(
                            label: 'Lessons',
                            count: controller.lessonCount.value,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // About Us
                      const ProfileSectionHeader(title: 'About Us'),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          controller.aboutUs.value.isEmpty
                              ? 'No description provided.'
                              : controller.aboutUs.value,
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                controller.aboutUs.value.isEmpty
                                    ? Colors.grey
                                    : Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Rating & Reviews header
                      const ProfileSectionHeader(title: 'Rating & Reviews'),
                      const SizedBox(height: 8),

                      // Overall Rating Display
                      ProfileRatingDisplay(rating: controller.rating.value),
                      const SizedBox(height: 16),

                      // ← NEW: Add Comment button right here
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.comment, color: Colors.white),
                          label: const Text(
                            'Add Comment',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () => _showAddCommentDialog(context),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ]),
                  ),
                ),

                // ── REVIEWS LIST ──────────────────────────────────────────────────────────
                if (controller.reviews.isEmpty)
                  SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'No reviews yet',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (ctx, idx) =>
                            ProfileReviewCard(review: controller.reviews[idx]),
                        childCount: controller.reviews.length,
                      ),
                    ),
                  ),

                // bottom padding
                const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
              ],
            );
          }),
        ),
      ),
    );
  }

  void _showAddCommentDialog(BuildContext context) {
    final commentCtrl = TextEditingController();
    double rating = 0.0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text('Leave a Review'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    itemCount: 5,
                    itemSize: 32,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder:
                        (context, _) =>
                            const Icon(Icons.star, color: Colors.orange),
                    onRatingUpdate: (value) => rating = value,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: commentCtrl,
                    decoration: InputDecoration(
                      labelText: 'Your comment',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    maxLines: 4,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {
                  final text = commentCtrl.text.trim();
                  if (text.isEmpty || rating == 0.0) {
                    Get.snackbar(
                      'Error',
                      'Please enter a comment and select a rating.',
                    );
                    return;
                  }
                  controller.addReview(text, rating);
                  Navigator.of(context).pop();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
    );
  }
}
