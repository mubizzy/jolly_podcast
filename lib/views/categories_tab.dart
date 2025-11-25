import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_header.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/category_card.dart';
import '../controllers/categories_controller.dart';
import 'category_detail_screen.dart';

class CategoriesTab extends StatefulWidget {
  const CategoriesTab({super.key});

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  // Default colors for each category
  static const Map<String, Color> categoryColors = {
    'ARTS': Color(0xFFE8B55D),
    'BUSINESS': Color(0xFF4A9FE8),
    'COMEDY': Color(0xFFE84A4A),
    'EDUCATION': Color(0xFFE8E4C8),
    'FICTION': Color(0xFF9B59B6),
    'GOVERNMENT': Color(0xFF34495E),
    'HEALTH & FITNESS': Color(0xFF6BCFB8),
    'HISTORY': Color(0xFFD35400),
    'KIDS & FAMILY': Color(0xFFF39C12),
    'LEISURE': Color(0xFF16A085),
    'MUSIC': Color(0xFFE8E8E8),
    'NEWS': Color(0xFFC0392B),
    'RELIGION & SPIRITUALITY': Color(0xFF8E44AD),
    'SCIENCE': Color(0xFF2980B9),
    'SOCIETY & CULTURE': Color(0xFF27AE60),
    'SPORTS': Color(0xFFE74C3C),
    'TECHNOLOGY': Color(0xFF3498DB),
    'TRUE CRIME': Color(0xFF7F8C8D),
    'TV & FILM': Color(0xFFE91E63),
  };

  @override
  void initState() {
    super.initState();
    // Fetch categories when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoriesController>().fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1F1F),
      body: SafeArea(
        child: Column(
          children: [
            // Header - Fixed
            const AppHeader(),

            // Title - Fixed
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'All podcast categories',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Search Bar - Fixed
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: SearchBarWidget(),
            ),
            const SizedBox(height: 16),

            // Categories Grid - Scrollable Only
            Expanded(
              child: Consumer<CategoriesController>(
                builder: (context, controller, child) {
                  // Loading state
                  if (controller.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00D9C1),
                      ),
                    );
                  }

                  // Error state
                  if (controller.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red[300],
                              size: 64,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              controller.errorMessage,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () => controller.retry(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00D9C1),
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Empty state
                  if (controller.isEmpty) {
                    return const Center(
                      child: Text(
                        'No categories available',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  // Loaded state - display categories
                  final categories = controller.categoryGroups;

                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      // Get the first image from the category's images array
                      final imageUrl = category.images.isNotEmpty
                          ? category.images.first
                          : '';
                      // Get color for this category or use a default
                      final backgroundColor = categoryColors[category.name] ??
                          const Color(0xFF6BCFB8);

                      return CategoryCard(
                        title: category.name,
                        imagePath: imageUrl,
                        backgroundColor: backgroundColor,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryDetailScreen(
                                categoryName: category.name,
                                categoryColor: backgroundColor,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
