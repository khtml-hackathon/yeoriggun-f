import 'package:flutter/material.dart';

// 각 화면 import
import 'home_sangin_screen.dart';
import 'order_sangin.dart';
import 'chat_sangin.dart';
import 'mypage_sangin.dart';
import 'local_svg_icon.dart'; // LocalSvgIcon 위젯 경로에 맞게 수정하세요

/// 탭 enum 정의
enum SanginTab { home, orders, chat, mypage }

/// 하단 네비게이터
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTap,
  });

  final SanginTab currentTab;
  final ValueChanged<SanginTab> onTap;

  static const Color kBg = Color(0xFFFFFDFB);
  static const Color kBorder = Color(0xFFE0E0E0);
  static const Color kSelected = Color(0xFFFFA600);
  static const Color kUnselected = Color(0xFF757575);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: kBg,
        border: Border(top: BorderSide(color: kBorder, width: 0.5)),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navItem(
              tab: SanginTab.home,
              iconName: 'home',
              isSelected: currentTab == SanginTab.home,
              onTap: onTap,
            ),
            _navItem(
              tab: SanginTab.orders,
              iconName: 'schedule',
              isSelected: currentTab == SanginTab.orders,
              onTap: onTap,
            ),
            _navItem(
              tab: SanginTab.chat,
              iconName: 'chat',
              isSelected: currentTab == SanginTab.chat,
              onTap: onTap,
            ),
            _navItem(
              tab: SanginTab.mypage,
              iconName: 'user',
              isSelected: currentTab == SanginTab.mypage,
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required SanginTab tab,
    required String iconName,
    required bool isSelected,
    required ValueChanged<SanginTab> onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap(tab),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: LocalSvgIcon(
          iconName,
          size: 14,
          color: isSelected ? kSelected : kUnselected,
        ),
      ),
    );
  }
}

/// 현재 탭에 맞는 화면 리턴
Widget buildSanginScreen(SanginTab target) {
  switch (target) {
    case SanginTab.home:
      return const HomeSanginScreen();
    case SanginTab.orders:
      return const OrderSangin();
    case SanginTab.chat:
      return const ChatSangin();
    case SanginTab.mypage:
      return const MyPageSangin();
  }
}
