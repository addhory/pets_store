import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pets_store/app/data/models/pet_model.dart';
import 'package:pets_store/app/data/providers/pet_api_provider.dart';
import 'package:pets_store/app/data/services/storage_services.dart';
import 'package:pets_store/app/routes/app_routes.dart';

class HomeController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final PetApiProvider _petApiProvider;

  HomeController(this._petApiProvider);

  RxString token = ''.obs;

  static const String tokenKey = 'token';
  var counter = 0.obs;

  // Search / filter state
  final TextEditingController searchController = TextEditingController();
  final isLoading = false.obs;
  final pets = <PetModel>[].obs;
  final selectedStatus = PetStatus.available.obs;

  void increment() {
    counter++;
  }

  void logout() async {
    await _storageService.clearAll();
    Get.offAllNamed(Routes.login);
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize controller
    token.value = _storageService.read<String>(tokenKey) ?? '';

    // Load default pets by status
    fetchByStatus(selectedStatus.value);
  }

  @override
  void onClose() {
    // Clean up resources
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchByTags(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      pets.clear();
      return;
    }
    isLoading.value = true;
    try {
      final results = await _petApiProvider.findByTags([trimmed]);
      pets.assignAll(results);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load pets by tags');
    } finally {
      await _ensureMinimalLoadingDelay();
    }
  }

  Future<void> fetchByStatus(PetStatus status) async {
    selectedStatus.value = status;
    isLoading.value = true;
    try {
      searchController.clear();
      final results = await _petApiProvider.findByStatus(status);
      pets.assignAll(results);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load pets by status');
    } finally {
      await _ensureMinimalLoadingDelay();
    }
  }

  void resetFilters() {
    searchController.clear();
    fetchByStatus(PetStatus.available);
  }

  void navigateToProfile() {
    Get.toNamed(Routes.profile);
  }

  // Ensure spinner is visible briefly for smoother perceived loading
  Future<void> _ensureMinimalLoadingDelay() async {
    // If the API returns too quickly, keep loading for ~300ms
    await Future.delayed(const Duration(milliseconds: 500));
    isLoading.value = false;
  }
}
