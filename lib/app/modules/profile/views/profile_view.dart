import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pets_store/app/modules/profile/controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  void _showPasswordSheet(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final newController = TextEditingController();
    final confirmController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'Change Password',
                  textAlign: TextAlign.center,
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: newController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: colors.primary.withValues(alpha: 0.25),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: colors.primary, width: 1.8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: confirmController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: colors.primary.withValues(alpha: 0.25),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: colors.primary, width: 1.8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      final n = newController.text.trim();
                      final c = confirmController.text.trim();
                      if (n.isEmpty || c.isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(content: Text('Fill all fields')),
                        );
                        return;
                      }
                      if (n != c) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                            content: Text('Passwords do not match'),
                          ),
                        );
                        return;
                      }
                      await controller.changePassword(n);
                      if (Navigator.of(ctx).canPop()) Navigator.of(ctx).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final p = controller.profile.value;
    final initials =
        ((p?.firstName ?? '').isNotEmpty || (p?.lastName ?? '').isNotEmpty)
        ? '${p?.firstName.substring(0, 1)}${p?.lastName.substring(0, 1)}'
              .toUpperCase()
        : (p?.username.substring(0, 2) ?? 'US').toUpperCase();

    return Scaffold(
      backgroundColor: colors.primaryContainer,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    top: 44,
                    child: Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: InkWell(
                          onTap: () => controller.logout(),
                          child: Icon(Icons.logout, color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 44,
                    child: Material(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: Get.back,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    bottom: -34,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 36,
                        backgroundImage: const NetworkImage(
                          'https://i.pravatar.cc/100',
                        ),
                        child: p == null
                            ? Text(
                                initials,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 42),
              // Profile card with Edit Profile pill
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  color: colors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p?.username ?? 'User',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Joined since 2023',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: colors.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Form fields
                        Text(
                          'First Name',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: Colors.grey[800]),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: controller.firstNameController,
                          decoration: _inputDecoration(context, 'John'),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Last Name',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: Colors.grey[800]),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: controller.lastNameController,
                          decoration: _inputDecoration(context, 'Doe'),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'E-Mail',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: Colors.grey[800]),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _inputDecoration(
                            context,
                            'john@example.com',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Mobile',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: Colors.grey[800]),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: _inputDecoration(
                            context,
                            '+91-123456789',
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 48,
                                child: Obx(
                                  () => ElevatedButton(
                                    onPressed: controller.isSaving.value
                                        ? null
                                        : controller.saveProfile,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colors.primary,
                                      foregroundColor: colors.onPrimary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                    child: controller.isSaving.value
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text('Save'),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 48,
                                child: OutlinedButton(
                                  onPressed: () => _showPasswordSheet(context),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: colors.primary),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  child: Text(
                                    'Edit Password',
                                    style: TextStyle(color: colors.primary),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration(BuildContext context, String hint) {
  final colors = Theme.of(context).colorScheme;
  return InputDecoration(
    hintText: hint,
    isDense: true,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colors.primary.withValues(alpha: 0.25)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colors.primary, width: 1.8),
    ),
  );
}
