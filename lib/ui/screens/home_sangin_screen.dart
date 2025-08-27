/// 상인 홈(도매가) 화면

import 'package:flutter/material.dart';

import 'order_sangin.dart';
import 'chat_sangin.dart';
import 'mypage_sangin.dart';

// widgets
import '../widgets/store_card.dart';
import '../widgets/category_icons.dart';
import '../widgets/local_svg_icon.dart';
import '../widgets/sangin_bottom_nav.dart';

class HomeSanginScreen extends StatefulWidget {
  const HomeSanginScreen({super.key});

  @override
  State<HomeSanginScreen> createState() => _HomeSanginScreenState();
}

class _HomeSanginScreenState extends State<HomeSanginScreen> {
  static const Color accent = Color(0xFFFFA600);
  static const Color bg = Color(0xFFFFFDFB);

  int _selectedIndex = 0;

  // 샘플 데이터 (스샷과 유사한 품목/가격/변동률)
  final List<_Item> items = [
    _Item(
      name: '참외',
      price: 150,
      change: 1.5,
      series: [16, 15, 16, 17, 16, 16, 17, 18, 17, 22],
    ),
    _Item(
      name: '복숭아',
      price: 700,
      change: 2.3,
      series: [12, 14, 13, 15, 16, 17, 16, 18, 17, 18],
    ),
    _Item(
      name: '사과',
      price: 3200,
      change: 0.8,
      series: [10, 12, 13, 16, 15, 15, 14, 14, 14, 14],
    ),
    _Item(
      name: '자두',
      price: 500,
      change: -0.5,
      series: [18, 16, 14, 16, 15, 16, 15, 16, 15, 15],
    ),
    _Item(
      name: '포도',
      price: 150,
      change: 1.5,
      series: [16, 15, 16, 17, 16, 16, 17, 18, 17, 22],
    ),
    _Item(
      name: '수박',
      price: 700,
      change: 2.3,
      series: [12, 14, 13, 15, 16, 17, 16, 18, 17, 18],
    ),
    _Item(
      name: '샤인머스켓',
      price: 3200,
      change: 0.8,
      series: [10, 12, 13, 16, 15, 15, 14, 14, 14, 14],
    ),
    _Item(
      name: '바나나',
      price: 500,
      change: -0.5,
      series: [18, 16, 14, 16, 15, 16, 15, 16, 15, 15],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFFFDFB);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFB),
      body: _buildBody(),
      bottomNavigationBar: const SanginBottomNav(current: SanginTab.home),
    );
  }

  Widget _buildBody() {
    if (_selectedIndex != 0) {
      // 다른 탭은 간단한 플레이스홀더
      final titles = ['홈', '내역', '채팅', '내 정보'];
      return SafeArea(
        child: Center(
          child: Text(
            '${titles[_selectedIndex]} 화면 (준비중)',
            style: const TextStyle(fontSize: 18, color: Colors.black54),
          ),
        ),
      );
    }

    // 홈 탭
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          // 상단 아이콘 행
          Row(
            children: [
              const LocalSvgIcon(
                'location',
                size: 24,
                color: Color(0xFF757575),
              ),

              IconButton(
                icon: const Icon(Icons.menu_rounded, color: Colors.black87),
                onPressed: () {},
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.black87,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.favorite_border_rounded,
                  color: Colors.black87,
                ),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Search
          _SearchBar(),
          const SizedBox(height: 20),

          // 타이틀
          const Text(
            '청량리 시장 도매가',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 16),

          // 그리드 카드
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.20, // 카드 비율 (스샷 유사)
            ),
            itemBuilder: (_, i) => _CommodityCard(item: items[i]),
          ),
        ],
      ),
    );
  }
}

/// 검색바
class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDE7E0)),
      ),
      child: const Row(
        children: [
          Icon(Icons.search_rounded, color: Colors.black54),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Search',
              style: TextStyle(color: Colors.black38, fontSize: 14),
            ),
          ),
          Icon(Icons.mic_none_rounded, color: _BottomNavBar.accent),
        ],
      ),
    );
  }
}

/// 품목 카드
class _CommodityCard extends StatelessWidget {
  const _CommodityCard({required this.item});
  final _Item item;

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFFEDE7E0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이름 + 가격
          Text(
            item.name,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            '\$${item.price.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 10),

          // 스파크라인
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFFAF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEDE7E0)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              constraints: const BoxConstraints.expand(), // ⬅️ 컨테이너를 꽉 채우게
              child: SizedBox.expand(
                // ⬅️ 페인터도 꽉 채우게
                child: CustomPaint(
                  painter: _SparklinePainter(
                    series: item.series,
                    color: _BottomNavBar.accent,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),

          // 변동률
          Text(
            '${item.change >= 0 ? '+' : ''}${item.change.toStringAsFixed(1)}%',
            style: const TextStyle(
              fontSize: 12,
              color: _BottomNavBar.accent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// 스파크라인 페인터 (패키지 없이 가벼움)
class _SparklinePainter extends CustomPainter {
  _SparklinePainter({required this.series, required this.color});
  final List<num> series;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (series.isEmpty) return;

    // normalize
    double minV = series.first.toDouble();
    double maxV = series.first.toDouble();
    for (final v in series) {
      final d = v.toDouble();
      if (d < minV) minV = d;
      if (d > maxV) maxV = d;
    }
    final range = (maxV - minV).clamp(1e-6, double.infinity);

    // 그리드(연한 라인)
    final grid = Paint()
      ..color = const Color(0xFFEDE7E0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final gridY = size.height * 0.70;
    canvas.drawLine(Offset(0, gridY), Offset(size.width, gridY), grid);

    // 라인
    final p = Path();
    for (int i = 0; i < series.length; i++) {
      final x = size.width * (i / (series.length - 1));
      final y =
          size.height - ((series[i].toDouble() - minV) / range) * size.height;
      if (i == 0) {
        p.moveTo(x, y);
      } else {
        p.lineTo(x, y);
      }
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(p, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) =>
      oldDelegate.series != series || oldDelegate.color != color;
}

/// 하단 커스텀 네비게이션 (SafeArea + Row)
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final ValueChanged<int> onTap;

  static const Color accent = Color(0xFFFFA600);
  static const Color borderColor = Color(0xFFEDE7E0);

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
              index: 2,
              iconName: 'chat',
              isSelected: selectedIndex == 2,
              onTap: onTap,
            ),
            _navItem(
              index: 3,
              iconName: 'user',
              isSelected: selectedIndex == 3,
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

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.index,
    required this.icon,
    required this.label,
    super.key,
  });

  final int index;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// 내부용 데이터 모델
class _Item {
  final String name;
  final double price;
  final double change; // %
  final List<num> series;

  const _Item({
    required this.name,
    required this.price,
    required this.change,
    required this.series,
  });
}
