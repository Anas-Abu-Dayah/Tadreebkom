import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/controller/centercontroller/centercontrollerhomepage.dart';
import 'package:tadreebkomapplication/controller/eventcontroller.dart';
import 'package:tadreebkomapplication/core/constant/color.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';
import 'package:tadreebkomapplication/core/functions/alertexitapp.dart';
import 'package:tadreebkomapplication/view/widget/center/instructor_card.dart';
import 'package:tadreebkomapplication/view/widget/center/profiletabbutton.dart';

class CenterHomePage extends StatelessWidget {
  final InstructorController instructorController = Get.put(
    InstructorController(),
  );
  final RxString selectedTab = 'Instructors'.obs;
  final EventController eventController = Get.put(EventController());

  CenterHomePage({super.key}) {
    ever(eventController.shouldRefreshInstructors, (refresh) {
      if (refresh) {
        _refreshInstructors();
        eventController.shouldRefreshInstructors.value =
            false; // Reset the flag
      }
    });
  }

  Future<void> _refreshInstructors() async {
    await instructorController.loadInstructors(); // Use public method
  }

  @override
  Widget build(BuildContext context) {
    // Set up the event listener

    return Scaffold(
      backgroundColor: AppColor.pagePrimaryColor,
      resizeToAvoidBottomInset: true,
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
            child: Column(
              children: [
                const SizedBox(height: 10),

                // Top Tabs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
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
                  ),
                ),
                const SizedBox(height: 10),
                // Add below the tabs and before Expanded
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.orangeAccent),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              instructorController.searchQuery.value = value;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Search instructors...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Instructors Grid with RefreshIndicator
                Expanded(
                  child: Obx(() {
                    return RefreshIndicator(
                      onRefresh: _refreshInstructors,
                      child: _buildInstructorsContent(),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: Obx(() {
        final isVerified = instructorController.isCenterVerified.value;

        return FloatingActionButton(
          shape: const CircleBorder(),
          onPressed:
              isVerified
                  ? () {
                    Get.toNamed(AppRoute.instructorsignup);
                  }
                  : null, // disables the button if not verified
          backgroundColor:
              isVerified
                  ? const Color.fromRGBO(255, 165, 0, 0.8)
                  : Colors.grey, // show disabled color
          child: const Icon(Icons.add, color: Colors.white),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildInstructorsContent() {
    if (instructorController.filteredInstructors.isEmpty) {
      return const Center(child: Text("No instructors found."));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 100),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemCount: instructorController.filteredInstructors.length,
        itemBuilder: (context, index) {
          final instructor = instructorController.filteredInstructors[index];
          String? profileImage = instructor["profileImage"];

          // If profileImage is null or empty, use the icon, otherwise load the image
          return InstructorCard(
            name: instructor["username"],
            profileImage: profileImage ?? "",
            email: instructor["email"],
            onDelete: () async {
              final confirmed = await Get.dialog<bool>(
                AlertDialog(
                  title: const Text("Confirm Delete"),
                  content: const Text(
                    "Are you sure you want to delete this instructor?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(result: false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Get.back(result: true),
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                final email = instructor["email"];
                if (email != null && email.toString().isNotEmpty) {
                  await instructorController.deleteInstructor(email);
                }
              } else {
                Get.snackbar(
                  snackPosition: SnackPosition.BOTTOM,
                  "Error",
                  "canit delete instrctor email is missing",
                );
              }
            },
            onProfilepage: () {
              Get.toNamed(
                AppRoute.instructorProfilePageView,
                arguments: {'instructorId': instructor['uid']},
              );
            },
            onScheduale: () {
              Get.toNamed(
                AppRoute.centerSchedulePageView,
                arguments: {'instructorId': instructor['uid']},
              );
            },
          );
        },
      ),
    );
  }
}
