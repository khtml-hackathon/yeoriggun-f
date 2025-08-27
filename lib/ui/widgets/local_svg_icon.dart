import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LocalSvgIcon extends StatelessWidget {
  final String name; // 예: 'home' (확장자 제외)
  final double size;
  final Color? color;

  const LocalSvgIcon(this.name, {super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    final iconColor =
        color ?? Theme.of(context).iconTheme.color ?? Colors.black;

    return SvgPicture.asset(
      'assets/icons/$name.svg',
      width: size,
      height: size,
      // 핵심: 내부 fill/stroke를 우리가 넘긴 색으로 강제
      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      // 로컬 에셋이라 placeholder는 생략 권장
      errorBuilder: (context, error, stackTrace) =>
          _fallbackIcon(name, size, iconColor),
    );
  }

  Widget _fallbackIcon(String name, double size, Color color) {
    IconData iconData;
    switch (name) {
      case 'home':
        iconData = Icons.home;
        break;
      case 'schedule':
        iconData = Icons.schedule;
        break;
      case 'map':
        iconData = Icons.location_on;
        break;
      case 'chat':
        iconData = Icons.chat_bubble_outline;
        break;
      case 'user':
        iconData = Icons.person_outline;
        break;
      case 'location':
        iconData = Icons.location_on_outlined;
        break;
      case 'alarm':
        iconData = Icons.notifications_outlined;
        break;
      case 'heart':
        iconData = Icons.favorite_border;
        break;
      case 'seafood':
        iconData = Icons.set_meal;
        break;
      case 'cooked':
        iconData = Icons.restaurant;
        break;
      case 'vegetable':
        iconData = Icons.eco;
        break;
      case 'seasoning':
        iconData = Icons.local_grocery_store;
        break;
      case 'health':
        iconData = Icons.healing;
        break;
      default:
        iconData = Icons.help_outline;
    }
    return Icon(iconData, size: size, color: color);
  }
}
