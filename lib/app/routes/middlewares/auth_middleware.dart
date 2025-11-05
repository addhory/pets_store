import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pets_store/app/data/services/storage_services.dart';
import 'package:pets_store/app/routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final hasProfileAndToken = Get.find<StorageService>().hasProfileAndToken();
    if (hasProfileAndToken) {
      return const RouteSettings(name: Routes.home);
    }
    return null;
  }
}
