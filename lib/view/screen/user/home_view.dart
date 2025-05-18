import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tadreebkomapplication/controller/usercontroller/home_controller.dart';
import 'package:tadreebkomapplication/controller/usercontroller/navbar_controller.dart';
import 'package:tadreebkomapplication/core/constant/color.dart';
import 'package:tadreebkomapplication/view/screen/user/navbar_view.dart';
import 'package:tadreebkomapplication/view/widget/user/appointment_card.dart';
import 'package:tadreebkomapplication/view/widget/user/centers_section.dart';
import 'package:tadreebkomapplication/view/screen/user/search_view.dart';
import 'package:tadreebkomapplication/view/screen/user/settings_view.dart';
import 'package:tadreebkomapplication/view/screen/user/activity_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(NavBarController());
    return Scaffold(
      backgroundColor: AppColor.pagePrimaryColor,
      appBar: AppBar(
        title: const Text("Home Page"),
        centerTitle: true,
        backgroundColor: AppColor.pagePrimaryColor,
      ),
      body: Obx(() {
        final idx = Get.find<NavBarController>().currentIndex.value;
        return IndexedStack(
          index: idx,
          children: const [
            HomeScreen(),
            SearchView(),
            ActivityView(),
            SettingsView(),
          ],
        );
      }),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeC = Get.put(HomeController());

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            if (homeC.isLoading.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (homeC.appointments.isEmpty) {
              return const Center(child: Text("No appointments found."));
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    homeC.appointments.map((appt) {
                      final bookingId = appt['bookingId'] as String;
                      final instructorId = appt['instructorId'] as String;
                      final name = appt['name'] as String;
                      final dateDisplay = appt['date'] as String;
                      final dateRaw = appt['dateRaw'] as String;
                      final timeDisplay = appt['time'] as String;
                      final timeRaw = appt['timeRaw'] as String;

                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: SizedBox(
                          width: 300,
                          child: AppointmentCard(
                            name: name,
                            date: dateDisplay,
                            time: timeDisplay,
                            isPaid: true,
                            isFinished: false,
                            onEdit: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                ),
                                builder:
                                    (_) => SafeArea(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // drag handle
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 8,
                                            ),
                                            width: 40,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),

                                          // header
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical: 8,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Appointment Options',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),

                                          // delete
                                          ListTile(
                                            leading: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            title: const Text(
                                              'Delete Appointment',
                                            ),
                                            onTap: () async {
                                              Navigator.pop(context);
                                              await homeC.deleteAppointment(
                                                bookingId,
                                                instructorId,
                                                dateRaw,
                                                timeRaw,
                                              );
                                            },
                                          ),

                                          const Divider(),

                                          // reschedule (clamp initialDate)
                                          ListTile(
                                            leading: const Icon(
                                              Icons.schedule,
                                              color: Colors.orange,
                                            ),
                                            title: const Text(
                                              'Reschedule Appointment',
                                            ),
                                            onTap: () async {
                                              Navigator.pop(context);

                                              // parse old date and clamp to today if in the past
                                              final parsed =
                                                  DateTime.tryParse(dateRaw) ??
                                                  DateTime.now();
                                              final now = DateTime.now();
                                              final initial =
                                                  parsed.isBefore(now)
                                                      ? now
                                                      : parsed;

                                              // show date picker
                                              final picked =
                                                  await showDatePicker(
                                                    context: context,
                                                    initialDate: initial,
                                                    firstDate: now,
                                                    lastDate: now.add(
                                                      const Duration(days: 30),
                                                    ),
                                                  );
                                              if (picked == null) return;
                                              final newDate = DateFormat(
                                                'yyyy-MM-dd',
                                              ).format(picked);

                                              // load instructor doc
                                              final doc =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('instructors')
                                                      .doc(instructorId)
                                                      .get();
                                              final avail =
                                                  (doc.data()?['availability']
                                                      as List<dynamic>?) ??
                                                  [];
                                              final day = avail.firstWhere(
                                                (d) => d['date'] == newDate,
                                                orElse: () => null,
                                              );
                                              if (day == null) {
                                                Get.snackbar(
                                                  'No slots',
                                                  'No availability on $newDate',
                                                );
                                                return;
                                              }

                                              // pick a time
                                              final slots =
                                                  (day['times']
                                                          as List<dynamic>)
                                                      .where(
                                                        (s) =>
                                                            s['available'] ==
                                                            true,
                                                      )
                                                      .toList();
                                              if (slots.isEmpty) {
                                                Get.snackbar(
                                                  'No slots',
                                                  'No open time slots on $newDate',
                                                );
                                                return;
                                              }
                                              final newTime = await showModalBottomSheet<
                                                String
                                              >(
                                                context: context,
                                                backgroundColor: Colors.white,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                  16,
                                                                ),
                                                          ),
                                                    ),
                                                builder:
                                                    (_) => Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            16,
                                                          ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                            'Select a New Time',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 12,
                                                          ),
                                                          Wrap(
                                                            spacing: 8,
                                                            runSpacing: 8,
                                                            children:
                                                                slots.map<
                                                                  Widget
                                                                >((slot) {
                                                                  final t =
                                                                      slot['time']
                                                                          as String;
                                                                  return ChoiceChip(
                                                                    label: Text(
                                                                      t,
                                                                    ),
                                                                    selected:
                                                                        false,
                                                                    onSelected:
                                                                        (
                                                                          _,
                                                                        ) => Navigator.pop(
                                                                          context,
                                                                          t,
                                                                        ),
                                                                  );
                                                                }).toList(),
                                                          ),
                                                          const SizedBox(
                                                            height: 16,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                              );
                                              if (newTime == null) return;

                                              // call controller
                                              await homeC.postponeAppointment(
                                                bookingId: bookingId,
                                                instructorId: instructorId,
                                                oldDate: dateRaw,
                                                oldTime: timeRaw,
                                                newDate: newDate,
                                                newTime: newTime,
                                              );
                                            },
                                          ),

                                          const SizedBox(height: 16),
                                        ],
                                      ),
                                    ),
                              );
                            },
                          ),
                        ),
                      );
                    }).toList(),
              ),
            );
          }),
          const SizedBox(height: 30),
          const CentersSection(title: 'Nearby Centers'),
          const SizedBox(height: 30),
          const CentersSection(title: 'Top Rated Centers'),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
