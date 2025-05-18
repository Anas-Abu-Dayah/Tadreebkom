import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:tadreebkomapplication/core/constant/color.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';
import 'package:tadreebkomapplication/view/widget/user/custom_list_tile.dart';
import 'package:tadreebkomapplication/view/widget/user/single_selection.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pagePrimaryColor,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColor.pagePrimaryColor,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView(
            children: [
              SingleSection(
                title: 'General',
                children: [
                  CustomListTile(
                    title: 'Notifications',
                    icon: Icons.notifications,
                    onTap: () {},
                  ),
                  CustomListTile(
                    title: 'Security Status',
                    icon: CupertinoIcons.lock_shield_fill,
                    onTap: () {},
                  ),
                ],
              ),
              const Divider(),
              SingleSection(
                title: 'For You',
                children: [
                  CustomListTile(
                    title: 'Profile',
                    icon: Icons.person,
                    onTap: () {
                      Get.toNamed(AppRoute.userProfilePage);
                    },
                  ),
                  CustomListTile(
                    title: 'Instructors',
                    icon: Icons.personal_injury,
                    onTap: () {},
                  ),
                  CustomListTile(
                    title: 'Certification',
                    icon: Icons.paste,
                    onTap: () {},
                  ),
                  CustomListTile(
                    title: 'Calendar',
                    icon: Icons.calendar_month,
                    onTap: () {},
                  ),
                ],
              ),
              const Divider(),
              SingleSection(
                title: 'Need Help?',
                children: [
                  CustomListTile(
                    title: 'Help & Feedback',
                    icon: Icons.help,
                    onTap: () {},
                  ),
                  CustomListTile(
                    title: 'Support',
                    icon: Icons.support_agent,
                    onTap: () {},
                  ),
                  CustomListTile(
                    title: 'About Us',
                    icon: Icons.info,
                    onTap: () {},
                  ),
                  CustomListTile(
                    title: 'Feedback',
                    icon: Icons.star,
                    onTap: () {},
                  ),
                  CustomListTile(
                    title: 'Sign out',
                    icon: Icons.exit_to_app,
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Get.offAllNamed(AppRoute.login);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
