import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pets_store/app/modules/home/controllers/home_controller.dart';
import 'package:pets_store/app/data/providers/pet_api_provider.dart';
import 'widgets/pet_card.dart';
import 'package:pets_store/app/routes/app_routes.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header card with gradient and rounded corners
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryBlue.withValues(alpha: 0.18),
                      primaryBlue.withValues(alpha: 0.06),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => controller.navigateToProfile(),
                          child: const CircleAvatar(
                            radius: 22,
                            backgroundImage: NetworkImage(
                              'https://i.pravatar.cc/100',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(color: Colors.black87),
                        children: const [
                          TextSpan(text: "Let's Find a\n"),
                          TextSpan(
                            text: 'Cute Friend',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 34,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Search bar row with filter button (uniform background)
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.searchController,
                            onSubmitted: controller.fetchByTags,
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              hintText: 'Search by tag (e.g., tag1)',
                              isDense: true,
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),

                              suffixIcon: IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () => controller.fetchByTags(
                                  controller.searchController.text,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(28),
                                borderSide: BorderSide(
                                  color: primaryBlue.withValues(alpha: 0.35),
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(28),
                                borderSide: BorderSide(
                                  color: primaryBlue,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Filter button will open a dropdown menu
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: primaryBlue,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: primaryBlue.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: PopupMenuButton<String>(
                            tooltip: 'Filter status',
                            offset: const Offset(0, 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            icon: const Icon(Icons.tune, color: Colors.white),
                            onSelected: (value) {
                              switch (value) {
                                case 'available':
                                  controller.fetchByStatus(PetStatus.available);
                                  break;
                                case 'pending':
                                  controller.fetchByStatus(PetStatus.pending);
                                  break;
                                case 'sold':
                                  controller.fetchByStatus(PetStatus.sold);
                                  break;
                                case 'reset':
                                  controller.resetFilters();
                                  break;
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'available',
                                child: Text('Available'),
                              ),
                              const PopupMenuItem(
                                value: 'pending',
                                child: Text('Pending'),
                              ),
                              const PopupMenuItem(
                                value: 'sold',
                                child: Text('Sold'),
                              ),
                              const PopupMenuDivider(),
                              const PopupMenuItem(
                                value: 'reset',
                                child: Text('Reset filters'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Pets list with animated state transitions
              Expanded(
                child: Obx(() {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: controller.isLoading.value
                        ? const Center(
                            key: ValueKey('loading'),
                            child: CircularProgressIndicator(),
                          )
                        : controller.pets.isEmpty
                        ? Center(
                            key: const ValueKey('empty'),
                            child: Text(
                              'No pets found',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[700]),
                            ),
                          )
                        : ListView.builder(
                            key: const ValueKey('list'),
                            itemCount: controller.pets.length,
                            itemBuilder: (context, index) {
                              final pet = controller.pets[index];
                              return PetCard(pet: pet);
                            },
                          ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
