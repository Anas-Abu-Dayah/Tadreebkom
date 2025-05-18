import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/controller/centercontroller/centerprofilecontroller.dart';
import 'package:tadreebkomapplication/core/constant/color.dart';
import 'package:tadreebkomapplication/core/functions/alertexitapp.dart';
import 'package:tadreebkomapplication/view/widget/center/profileratingdisplay.dart';
import 'package:tadreebkomapplication/view/widget/center/profilereviewcard.dart';
import 'package:tadreebkomapplication/view/widget/center/profilesectionheader.dart';
import 'package:tadreebkomapplication/view/widget/center/profilestatbox.dart';
import 'package:tadreebkomapplication/view/widget/center/profiletabbutton.dart';

class CenterProfilePage extends StatelessWidget {
  final controller = Get.put(CenterProfileController());
  final RxString selectedTab = 'Home'.obs;
  final _logoutFabTag = 'logoutFab';

  CenterProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        heroTag: _logoutFabTag,
        onPressed: controller.logOut,
        backgroundColor: Colors.red,
        child: const Icon(Icons.logout, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: AppColor.pagePrimaryColor,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) {
            final shouldPop = await alertExitApp();
            if (shouldPop) {
              Get.back(); // Pop manually if confirmed
            }
          }
        },
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (!didPop) {
              final shouldPop = await alertExitApp();
              if (shouldPop) {
                Get.back(); // Pop manually if confirmed
              }
            }
          },
          child: SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return RefreshIndicator(
                onRefresh: () async => controller.fetchCenterData(),
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Top Tabs
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ProfileTabButton(
                                  label: "Home",
                                  isActive: selectedTab.value == "Home",
                                  selectedTab: selectedTab,
                                ),
                                ProfileTabButton(
                                  label: "Instructors",
                                  isActive: selectedTab.value == "Instructors",
                                  selectedTab: selectedTab,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Profile Image with Upload Button
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              GestureDetector(
                                onTap: controller.showImageOptions,
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage:
                                      controller.centerImage.value.isNotEmpty
                                          ? NetworkImage(
                                            controller.centerImage.value,
                                          )
                                          : null,
                                  onBackgroundImageError:
                                      controller.centerImage.value.isNotEmpty
                                          ? (e, stack) {
                                            controller.centerImage.value = '';
                                            Get.snackbar(
                                              "Error",
                                              "Failed to load image",
                                            );
                                          }
                                          : null,
                                  child:
                                      controller.centerImage.value.isEmpty
                                          ? const Icon(Icons.image, size: 40)
                                          : null,
                                ),
                              ),
                              Positioned(
                                top: 70,
                                left: 200,
                                child:
                                    controller.isLoading.value
                                        ? const CircularProgressIndicator()
                                        : FloatingActionButton.small(
                                          backgroundColor: Colors.orange,
                                          onPressed:
                                              controller.showImageOptions,
                                          child: const Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,
                                          ),
                                        ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.centerName.value,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () => _showEditNameDialog(context),
                                child: const Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          // Stats
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ProfileStatBox(
                                label: "Instructors",
                                count: controller.instructorCount.value,
                              ),
                              ProfileStatBox(
                                label: "Students",
                                count: controller.studentCount.value,
                              ),
                              ProfileStatBox(
                                label: "Lessons",
                                count: controller.lessonCount.value,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // About Us Section
                          const ProfileSectionHeader(title: "About Us"),
                          GestureDetector(
                            onTap: controller.editAboutUs,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.orangeAccent),
                              ),
                              child: Text(
                                controller.aboutUs.value.isEmpty
                                    ? "Tap to add information about your center..."
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
                          ),
                          const SizedBox(height: 20),

                          // Rating & Review Section
                          const ProfileSectionHeader(title: "Rating & Review"),
                          const SizedBox(height: 10),
                          ProfileRatingDisplay(rating: controller.rating.value),
                          const SizedBox(height: 20),
                        ]),
                      ),
                    ),

                    // Reviews List with SliverList for better performance
                    if (controller.reviews.isEmpty)
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverToBoxAdapter(
                          child: Center(
                            child: Text(
                              "No reviews yet",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final review = controller.reviews[index];
                            return ProfileReviewCard(review: review);
                          }, childCount: controller.reviews.length),
                        ),
                      ),

                    // Add bottom padding for the FAB
                    const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  void _showEditNameDialog(BuildContext context) {
    final nameController = TextEditingController(
      text: controller.centerName.value,
    );
    Get.defaultDialog(
      title: "Edit Center Name",
      content: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Center Name",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {
                  if (nameController.text.trim().isNotEmpty) {
                    controller.updateCenterName(nameController.text.trim());
                    Get.back();
                  }
                },
                child: const Text("Save"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
