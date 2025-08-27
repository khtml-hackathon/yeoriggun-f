import 'package:flutter/material.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/login_screen.dart';
import '../ui/screens/cart_screen.dart';
import '../ui/screens/upload_photo_screen.dart';
import '../ui/screens/record_audio_screen.dart';
import '../ui/screens/result_screen.dart';
import '../config/api_config.dart';

class AppRoutes {
  static const String initial = '/login';
  static const String home = '/home';
  static const String cart = '/cart';
  static const String upload = '/upload';
  static const String record = '/record';
  static const String result = '/result';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case upload:
        return MaterialPageRoute(
          builder: (_) => UploadPhotoScreen(apiBase: ApiConfig.currentBaseUrl),
        );
      case record:
        return MaterialPageRoute(
          builder: (_) => const RecordAudioScreen(
            apiBase: ApiConfig.localBaseUrl,
          ),
        );
      case result:
        return MaterialPageRoute(builder: (_) => ResultScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
