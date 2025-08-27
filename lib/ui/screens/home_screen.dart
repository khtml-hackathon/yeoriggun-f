// lib/screens/home_screen.dart
import 'package:flutter/material.dart';

import 'detail_screen.dart';
import 'reservation_screen.dart';

// widgets
import '../widgets/store_card.dart';
import '../widgets/category_icons.dart';
import '../widgets/local_svg_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // 홈 선택

  // 피그마 스타일: 가게명 텍스트
  static const TextStyle kStoreTitleStyle = TextStyle(
    color: Color(0xFF271C1A),
    fontSize: 17,
    fontFamily: 'Public Sans', // pubspec에 등록되어 있어야 적용됨
    fontWeight: FontWeight.w700,
    letterSpacing: -0.34,
  );

  // 샘플 스토어 데이터 (상태를 여기서 관리)
  final List<Map<String, dynamic>> _stores = [
    {
      'name': '청과원',
      'category': '과일',
      'rating': 4.2,
      'priceRange': '₩29,700',
      'pickupTime': '픽업시간: 6~7시',
      'imageUrl':
          'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400&h=300&fit=crop',
    },
    {
      'name': '영원유과',
      'category': '가공식품',
      'rating': 4.8,
      'priceRange': '₩29,700',
      'pickupTime': '픽업시간: 6~7시',
      'imageUrl':
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&h=300&fit=crop',
    },
    {
      'name': '김씨네 채소 가게',
      'category': '채소',
      'rating': 4.5,
      'priceRange': '₩29,700',
      'pickupTime': '픽업시간: 6~7시',
      'imageUrl':
          'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400&h=300&fit=crop',
    },
  ];

  // 즐겨찾기 상태 (각 카드마다)
  late List<bool> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = List<bool>.filled(_stores.length, false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFB),

      // ===== AppBar =====
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFDFB),
        elevation: 0,
        toolbarHeight: 60,
        title: Row(
          children: [
            const LocalSvgIcon('location', size: 24, color: Color(0xFF757575)),
            const SizedBox(width: 8),
            Text(
              '위치를 선택해주세요',
              style: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF757575),
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: const [
          IconButton(
            onPressed: null,
            icon: LocalSvgIcon('alarm', size: 24, color: Color(0xFF757575)),
          ),
          IconButton(
            onPressed: null,
            icon: LocalSvgIcon('heart', size: 24, color: Color(0xFF757575)),
          ),
        ],
      ),

      // ===== Body =====
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(const [
                SizedBox(height: 8), // 검색창 위 간격 20 -> 8
                _SearchField(),
                SizedBox(height: 20),
                _CategoryButtons(),
                SizedBox(height: 20),
                _FilterHeader(),
                SizedBox(height: 20),
              ]),
            ),
          ),
          // 스토어 리스트
          _StoreListSliver(
            stores: _stores,
            favorites: _favorites,
            onToggleFavorite: (index) {
              setState(() => _favorites[index] = !_favorites[index]);
            },
            titleStyle: kStoreTitleStyle,
          ),
        ],
      ),

      // ===== Bottom Nav =====
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (i) {
          setState(() => _selectedIndex = i);
          if (i == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReservationScreen()),
            );
          }
        },
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF757575).withOpacity(0.09),
            const Color(0xFFB0B0B0).withOpacity(0.09),
          ],
        ),
        borderRadius: BorderRadius.circular(360),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for stores',
          hintStyle: TextStyle(
            color: const Color(0xFF757575).withOpacity(0.62),
            fontSize: 17,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF757575),
            size: 18,
          ),
          suffixIcon: const Icon(Icons.mic, color: Color(0xFF757575), size: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(360),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10.5,
          ),
        ),
      ),
    );
  }
}

class _CategoryButtons extends StatelessWidget {
  const _CategoryButtons();

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': '전체', 'isActive': true, 'iconWidget': null},
      {'name': '해산물', 'isActive': false, 'iconWidget': const SeafoodIcon()},
      {'name': '조리식품', 'isActive': false, 'iconWidget': const CookedIcon()},
      {'name': '채소 · 과일', 'isActive': false, 'iconWidget': const VegieIcon()},
      {
        'name': '장류 · 양념',
        'isActive': false,
        'iconWidget': const SeasoningIcon(),
      },
      {'name': '한방', 'isActive': false, 'iconWidget': const HealthIcon()},
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: categories.map((category) {
        final isActive = category['isActive'] as bool;
        final iconWidget = category['iconWidget'] as Widget?;
        final name = category['name'] as String;

        return Container(
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFC6007E), Color(0xFF93328E)],
                  )
                : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFFB0B0B0).withOpacity(0.5),
                      const Color(0xFF281D1B).withOpacity(0.5),
                    ],
                  ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: const Color(0xFFA7B6C2), width: 0.5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (iconWidget != null) ...[
                  iconWidget,
                  const SizedBox(width: 4),
                ],
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFFFFFDFB),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Color(0x40000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _FilterHeader extends StatelessWidget {
  const _FilterHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Padding(
          padding: EdgeInsets.only(left: 16), // ← 카드 시작점에 맞추기
          child: Text(
            '현재 위치에서 가까운 가게들을 만나보세요',
            style: TextStyle(
              color: Color(0xFF757575),
              fontSize: 17,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ),
        Icon(Icons.tune, color: Color(0xFF757575), size: 24),
      ],
    );
  }
}

class _StoreListSliver extends StatelessWidget {
  const _StoreListSliver({
    required this.stores,
    required this.favorites,
    required this.onToggleFavorite,
    required this.titleStyle,
  });

  final List<Map<String, dynamic>> stores;
  final List<bool> favorites;
  final ValueChanged<int> onToggleFavorite;
  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final store = stores[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == stores.length - 1 ? 20 : 12,
            ),
            child: StoreCard(
              storeName: store['name'] as String,
              category: store['category'] as String,
              rating: store['rating'] as double,
              priceRange: store['priceRange'] as String,
              pickupTime: store['pickupTime'] as String,
              imageUrl: store['imageUrl'] as String?,
              titleStyle: titleStyle,
              titleMaxWidth: 310,
              isFavorite: favorites[index],
              onFavoritePressed: () => onToggleFavorite(index),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StoreDetailScreen(
                      storeName: store['name'] as String,
                      heroImageUrl: store['imageUrl'] as String? ?? '',
                    ),
                  ),
                );
              },
            ),
          );
        }, childCount: stores.length),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final ValueChanged<int> onTap;

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
              iconName: 'map',
              isSelected: selectedIndex == 2,
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
          color: isSelected ? const Color(0xFFC6007E) : const Color(0xFF757575),
        ),
      ),
    );
  }
}
