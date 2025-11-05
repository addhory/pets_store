import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pets_store/app/data/models/user_model.dart';
import 'package:pets_store/app/data/repositories/user_repository.dart';
import 'package:pets_store/app/data/services/storage_services.dart';
import 'package:pets_store/app/routes/app_routes.dart';

class ProfileController extends GetxController {
  final UserRepository _userRepository;
  final StorageService _storageService;

  ProfileController(this._userRepository, this._storageService);

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final isSaving = false.obs;
  final profile = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    final Map<String, dynamic>? json =
        _storageService.read<Map<String, dynamic>>('profile');
    if (json != null) {
      profile.value = UserModel.fromJson(json);
      firstNameController.text = profile.value?.firstName ?? '';
      lastNameController.text = profile.value?.lastName ?? '';
      emailController.text = profile.value?.email ?? '';
      phoneController.text = profile.value?.phone ?? '';
    }
  }

  Future<void> saveProfile() async {
    final current = profile.value;
    if (current == null) return;
    final updated = UserModel(
      id: current.id,
      username: current.username,
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      password: current.password,
      phone: phoneController.text.trim(),
      userStatus: current.userStatus,
    );

    isSaving.value = true;
    try {
      // Try API update if available, otherwise fall back to local persistence
      try {
        await _userRepository.updateProfile(updated);
      } catch (_) {
        // Ignore if API not reachable or mocked; still update local
      }
      // Always update local storage.
      await _storageService.write('profile', updated.toJson());
      profile.value = updated;
      Get.snackbar('Saved', 'Profile updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> changePassword(String newPassword) async {
    final current = profile.value;
    if (current == null) return;
    final updated = UserModel(
      id: current.id,
      username: current.username,
      firstName: current.firstName,
      lastName: current.lastName,
      email: current.email,
      password: newPassword.trim(),
      phone: current.phone,
      userStatus: current.userStatus,
    );
    await _storageService.write('profile', updated.toJson());
    profile.value = updated;
    Get.snackbar('Success', 'Password updated');
  }

  Future<void> logout() async {
    await _storageService.clearAll();
    Get.offAllNamed(Routes.login);
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}