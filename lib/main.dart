import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pets_store/app/core/styles/app_themes.dart';
import 'package:pets_store/app/routes/app_binding.dart';
import 'package:pets_store/app/routes/app_pages.dart';

import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pets Store',
      debugShowCheckedModeBanner: false,
      initialBinding: AppBinding(),
      theme: AppThemes.lightTheme,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
