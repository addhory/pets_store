import 'package:get/get.dart';

import 'package:pets_store/app/modules/auth/bindings/login_binding.dart';
import 'package:pets_store/app/modules/auth/bindings/register_binding.dart';
import 'package:pets_store/app/modules/home/bindings/home_binding.dart';
import 'package:pets_store/app/modules/home/views/home_view.dart';
import 'package:pets_store/app/modules/auth/views/login_view.dart';
import 'package:pets_store/app/modules/auth/views/register_view.dart';
import 'package:pets_store/app/modules/splash/bindings/splash_binding.dart';
import 'package:pets_store/app/modules/splash/views/splash_view.dart';
import 'package:pets_store/app/modules/profile/bindings/profile_binding.dart';
import 'package:pets_store/app/modules/profile/views/profile_view.dart';
import 'package:pets_store/app/routes/middlewares/auth_middleware.dart';
import 'package:pets_store/app/routes/middlewares/guard_middleware.dart';

import 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      middlewares: [GuardMiddleware()],
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      middlewares: [GuardMiddleware()],
    ),
  ];
}
