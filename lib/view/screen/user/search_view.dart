// lib/view/widget/user/search_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/controller/usercontroller/search_controller.dart'
    as my_search;
import 'package:tadreebkomapplication/core/constant/app_theme.dart';
import 'package:tadreebkomapplication/core/constant/color.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';
import 'package:tadreebkomapplication/view/widget/user/custom_chips.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put<my_search.SearchController>(my_search.SearchController());

    return Scaffold(
      backgroundColor: AppColor.pagePrimaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildFilterChips(),
              const SizedBox(height: 16),
              Expanded(child: _buildCentersGrid()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    final c = Get.find<my_search.SearchController>();
    return TextField(
      controller: c.searchTextController,
      onChanged: c.updateSearchQuery,
      decoration: InputDecoration(
        hintText: 'Search centers...',
        prefixIcon: const Icon(Icons.search, color: Colors.orange),
        suffixIcon: Obx(
          () =>
              c.searchQuery.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.orange),
                    onPressed: c.clearSearch,
                  )
                  : const SizedBox.shrink(),
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final c = Get.find<my_search.SearchController>();
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              c.filterCategories.map((filter) {
                final sel = c.selectedFilters.contains(filter);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: CustomChip(
                    isSelected: sel,
                    onTap: () => c.toggleFilter(filter),
                    child: Text(
                      filter,
                      style: TextStyle(
                        fontSize: 16,
                        color: sel ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildCentersGrid() {
    final c = Get.find<my_search.SearchController>();
    return Obx(() {
      final list = c.displayedCenters;
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: list.length,
        itemBuilder: (ctx, i) {
          final center = list[i];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: AppTheme.cardDecoration,

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.grey.shade200,
                  // only load a NetworkImage if there's a URL
                  backgroundImage:
                      center.imageUrl.isNotEmpty
                          ? NetworkImage(center.imageUrl)
                          : null,
                  // if there's no image URL, show a default icon
                  child:
                      center.imageUrl.isEmpty
                          ? Icon(Icons.image, size: 36, color: Colors.grey)
                          : null,
                ),
                const SizedBox(height: 8),

                // Name
                Text(
                  center.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const Divider(height: 8, thickness: 1),

                const Spacer(),

                // Button row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Select
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          AppRoute.booking,
                          arguments: {'center': center},
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.orange.shade100,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 20,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text('Select', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    // Profile
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          AppRoute.centerProfileView,
                          arguments: {'centerId': center.id},
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueGrey.shade50,
                            ),
                            child: const Icon(
                              Icons.info_outline,
                              size: 20,
                              color: Colors.blueGrey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text('Profile', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
