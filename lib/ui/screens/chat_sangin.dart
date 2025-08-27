import 'package:flutter/material.dart';
import 'package:my_app/ui/widgets/local_svg_icon.dart';

class ChatSangin extends StatefulWidget {
  const ChatSangin({super.key});

  @override
  State<ChatSangin> createState() => _ChatSanginState();
}

class _ChatSanginState extends State<ChatSangin> {
  int _selectedIndex = 2; // 채팅 탭 선택

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 상단 헤더 (뒤로가기 + 가운데 큰 타이틀)
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            SizedBox(
              height: 56,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 가운데 타이틀
                  const Text(
                    '채팅창',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                    ),
                  ),
                  // 좌측 뒤로가기
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: _BottomNavBar.accent,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // 채팅 리스트
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: _dummyChats.length,
                separatorBuilder: (_, __) => Container(
                  margin: const EdgeInsets.only(left: 72),
                  height: 1,
                  color: const Color(0xFFE5E5E5),
                ),
                itemBuilder: (context, i) {
                  final c = _dummyChats[i];
                  return _ChatRow(
                    name: c.name,
                    lastMessage: c.lastMessage,
                    avatarUrl: c.avatarUrl,
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // 하단 네비게이션 바 (4개 탭)
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }
}

/// 단일 채팅 행
class _ChatRow extends StatelessWidget {
  const _ChatRow({
    required this.name,
    required this.lastMessage,
    required this.avatarUrl,
  });

  final String name;
  final String lastMessage;
  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 동그란 아바타
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.network(
              avatarUrl,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 44,
                height: 44,
                color: const Color(0xFFEDE7E0),
                child: const Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // 이름 + 마지막 메시지
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lastMessage,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 하단 네비게이션 (홈/문서/채팅/내정보)
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final ValueChanged<int> onTap;
  static const Color accent = Color(0xFFFFA600);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xFFFFFDFB),
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 0.5)),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navItem(
              index: 0,
              iconName: 'home',
              isSelected: selectedIndex == 0,
              onTap: onTap,
            ),
            _navItem(
              index: 1,
              iconName: 'schedule',
              isSelected: selectedIndex == 1,
              onTap: onTap,
            ),
            _navItem(
              index: 3,
              iconName: 'chat',
              isSelected: selectedIndex == 3,
              onTap: onTap,
            ),
            _navItem(
              index: 4,
              iconName: 'user',
              isSelected: selectedIndex == 4,
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required int index,
    required String iconName,
    required bool isSelected,
    required ValueChanged<int> onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
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
          color: isSelected ? const Color(0xFFFFA600) : const Color(0xFF757575),
        ),
      ),
    );
  }
}

Widget _navItem({
  required int index,
  required IconData iconData,
  required String label,
  required bool isSelected,
  required ValueChanged<int> onTap,
}) {
  final Color iconColor = isSelected
      ? _BottomNavBar.accent
      : const Color(0xFF8A8A8A);

  return InkWell(
    onTap: () => onTap(index),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, size: 28, color: iconColor),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: iconColor,
            ),
          ),
        ],
      ),
    ),
  );
}

/// 더미 데이터
class _ChatItem {
  final String name;
  final String lastMessage;
  final String avatarUrl;

  const _ChatItem(this.name, this.lastMessage, this.avatarUrl);
}

const _dummyChats = <_ChatItem>[
  _ChatItem('홍길동', '감사합니다', 'https://i.pravatar.cc/100?img=32'),
  _ChatItem('김철수', '좋은 하루 되세요!', 'https://i.pravatar.cc/100?img=12'),
  _ChatItem('이영희', '안녕하세요', 'https://i.pravatar.cc/100?img=5'),
  _ChatItem('日奈森あむ', '넵 좋은 하루 보내세요', 'https://i.pravatar.cc/100?img=28'),
];
