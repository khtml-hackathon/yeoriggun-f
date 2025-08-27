// lib/ui/widgets/sangin_bottom_nav.dart
import 'package:flutter/material.dart';
import '../screens/home_sangin_screen.dart';
import '../screens/order_sangin.dart';
import '../screens/chat_sangin.dart';
import '../screens/mypage_sangin.dart';
import 'local_svg_icon.dart';

enum SanginTab { home, orders, chat, mypage }

class SanginBottomNav extends StatelessWidget {
  const SanginBottomNav({super.key, required this.current});

  final SanginTab current;

  static const Color accent = Color(0xFFFFA600);

  void _go(BuildContext context, SanginTab target) {
    if (target == current) return;
    Widget screen;
    switch (target) {
      case SanginTab.home:
        screen = const HomeSanginScreen();
        break;
      case SanginTab.orders:
        screen = const OrderSangin();
        break;
      case SanginTab.chat:
        screen = const ChatSangin();
        break;
      case SanginTab.mypage:
        screen = const MyPageSangin();
        break;
    }
    // 스택 꼬임 방지: 동일 스택 레벨에서 교체
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xFFFFFDFB),
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _item(context, icon: 'home', tab: SanginTab.home),
            _item(context, icon: 'schedule', tab: SanginTab.orders),
            _item(context, icon: 'chat', tab: SanginTab.chat),
            _item(context, icon: 'user', tab: SanginTab.mypage),
          ],
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context, {
    required String icon,
    required SanginTab tab,
  }) {
    final bool selected = current == tab;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _go(context, tab),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LocalSvgIcon(
              icon,
              size: 32,
              color: selected ? accent : const Color(0xFF757575),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
