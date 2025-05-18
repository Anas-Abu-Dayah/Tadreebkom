// lib/view/screen/center/instructor_profile_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/controller/centercontroller/viewinstructorprofile.dart';
import 'package:tadreebkomapplication/core/constant/color.dart';
import 'package:tadreebkomapplication/core/functions/alertexitapp.dart';
import 'package:tadreebkomapplication/view/widget/center/profilesectionheader.dart';
import 'package:tadreebkomapplication/view/widget/center/profilestatbox.dart';
import 'package:tadreebkomapplication/view/widget/center/profileratingdisplay.dart';
import 'package:tadreebkomapplication/view/widget/center/profilereviewcard.dart';

class InstructorProfilePageView extends StatelessWidget {
  const InstructorProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final instructorId = args?['instructorId'] as String?;
    if (instructorId == null) {
      return Scaffold(
        body: Center(child: Text("❌ Missing instructorId in arguments")),
      );
    }

    final ctrl = Get.put(ViewInstructorProfileController(instructorId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.pagePrimaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: AppColor.pagePrimaryColor,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (!didPop && await alertExitApp()) Get.back();
        },
        child: SafeArea(
          child: Obx(() {
            if (ctrl.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return CustomScrollView(
              slivers: [
                // — Profile header —
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Center(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  ctrl.instructorImage.value.isNotEmpty
                                      ? NetworkImage(ctrl.instructorImage.value)
                                      : null,
                              child:
                                  ctrl.instructorImage.value.isEmpty
                                      ? const Icon(Icons.person, size: 40)
                                      : null,
                            ),
                            FloatingActionButton.small(
                              backgroundColor: Colors.orange,
                              onPressed: ctrl.changeProfilePicture,
                              child: const Icon(Icons.camera_alt, size: 18),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Name + edit
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(
                            () => Text(
                              ctrl.instructorName.value,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _showEditNameDialog(context, ctrl),
                            child: const Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Stats row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ProfileStatBox(
                            label: 'Students',
                            count: ctrl.studentCount.value,
                          ),
                          ProfileStatBox(
                            label: 'Lessons',
                            count: ctrl.lessonCount.value,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Bio
                      const ProfileSectionHeader(title: 'About You'),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _showEditBioDialog(context, ctrl),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orangeAccent),
                          ),
                          child: Obx(
                            () => Text(
                              ctrl.bio.value.isEmpty
                                  ? 'Tap to add your bio…'
                                  : ctrl.bio.value,
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    ctrl.bio.value.isEmpty
                                        ? Colors.grey
                                        : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Rating & Reviews header
                      const ProfileSectionHeader(title: 'Rating & Reviews'),
                      const SizedBox(height: 8),
                      ProfileRatingDisplay(rating: ctrl.rating.value),
                      const SizedBox(height: 20),
                    ]),
                  ),
                ),

                // — Reviews list —
                if (ctrl.reviews.isEmpty)
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
                        (ctx, idx) => ProfileReviewCard(
                          review: {
                            'rating': ctrl.reviews[idx]['rating'],
                            'comment': ctrl.reviews[idx]['comment'],
                            'createdAt': ctrl.reviews[idx]['createdAt'],
                          },
                        ),
                        childCount: ctrl.reviews.length,
                      ),
                    ),
                  ),

                const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
              ],
            );
          }),
        ),
      ),
    );
  }

  void _showEditNameDialog(
    BuildContext context,
    ViewInstructorProfileController ctrl,
  ) {
    final tc = TextEditingController(text: ctrl.instructorName.value);
    Get.defaultDialog(
      title: 'Edit Your Name',
      content: Column(
        children: [
          TextField(
            controller: tc,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () => ctrl.updateInstructorName(tc.text.trim()),
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditBioDialog(
    BuildContext context,
    ViewInstructorProfileController ctrl,
  ) {
    final tc = TextEditingController(text: ctrl.bio.value);
    Get.defaultDialog(
      title: 'Edit Your Bio',
      content: Column(
        children: [
          TextField(
            controller: tc,
            minLines: 2,
            maxLines: 5,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () => ctrl.updateBio(tc.text.trim()),
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
