import 'package:flutter/material.dart';
import 'add_sangin.dart';
import '../widgets/sangin_bottom_nav.dart';

class MyPageSangin extends StatefulWidget {
  const MyPageSangin({super.key});

  @override
  State<MyPageSangin> createState() => _MyPageSanginState();
}

class _MyPageSanginState extends State<MyPageSangin> {
  static const kAccent = Color(0xFFFFA600);
  static const kBg = Color(0xFFFFFDFB);
  int _tabIndex = 0; // 0: 상품 관리, 1: 리뷰 관리

  // 샘플 상품 데이터 (progress와 연동)
  final List<_Product> products = [
    _Product(
      name: '고당도 하우스 수박',
      img:
          'https://images.unsplash.com/photo-1629265824943-b0a19b32c7a0?q=80&w=1080&auto=format&fit=crop',
      soldPercent: 90,
      leftQty: 1,
      price: '3,500원',
      originPrice: '7,000원',
    ),
    _Product(
      name: '부사 사과',
      img:
          'https://images.unsplash.com/photo-1602729998322-d751e18d7146?q=80&w=1080&auto=format&fit=crop',
      soldPercent: 90,
      leftQty: 1,
      price: '3,500원',
      originPrice: '7,000원',
    ),
    _Product(
      name: '당도최고 딸기',
      img:
          'https://images.unsplash.com/photo-1576403186148-9c2f7e5d0c22?q=80&w=1080&auto=format&fit=crop',
      soldPercent: 90,
      leftQty: 1,
      price: '3,500원',
      originPrice: '7,000원',
    ),
    _Product(
      name: '꿀참외',
      img:
          'https://images.unsplash.com/photo-1601004890684-d8cbf643f5f2?q=80&w=1080&auto=format&fit=crop',
      soldPercent: 90,
      leftQty: 1,
      price: '3,500원',
      originPrice: '7,000원',
    ),
    _Product(
      name: '맛있는 멜론',
      img:
          'https://images.unsplash.com/photo-1591238377894-3abf0b572163?q=80&w=1080&auto=format&fit=crop',
      soldPercent: 90,
      leftQty: 1,
      price: '3,500원',
      originPrice: '7,000원',
    ),
    _Product(
      name: '씨없는 포도',
      img:
          'https://images.unsplash.com/photo-1600271886742-f049cd451bba?q=80&w=1080&auto=format&fit=crop',
      soldPercent: 90,
      leftQty: 1,
      price: '3,500원',
      originPrice: '7,000원',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // 상단 큰 가게 이미지 + 좌/우 상단 아이콘
              _StoreHeader(),

              const SizedBox(height: 16),

              // 가게명 + 평점
              const Text('청과원',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Row(
                children: const [
                  Icon(Icons.star_rounded, size: 18, color: Color(0xFFFFC107)),
                  SizedBox(width: 4),
                  Text('4.2(리뷰 8개) >',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),

              const SizedBox(height: 16),

              // 가게 정보 pill 버튼
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: kAccent,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: kAccent.withOpacity(0.28),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    '가게 정보',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 가게 정보 카드
              _StoreInfoCard(),

              const SizedBox(height: 18),

              // 탭바 (상품 관리 / 리뷰 관리)
              _TabHeader(
                index: _tabIndex,
                onChanged: (i) => setState(() => _tabIndex = i),
              ),

              const SizedBox(height: 12),

              // 탭 콘텐츠
              if (_tabIndex == 0) _ProductGrid(products: products) else _ReviewPlaceholder(),

              const SizedBox(height: 18),

              // 하단 버튼
              Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    icon: const Text('✓',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w900)),
                    label: const Text('상품 추가하기',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccent,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddSangin()),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),

      // 하단 네비게이터 4개 (디자인만 반영)
      bottomNavigationBar: BottomNavBar(
        currentTab: SanginTab.mypage,   // ✅ 현재 탭을 지정
        onTap: (tab) {
          // TODO: 탭 이동 로직
          switch (tab) {
            case SanginTab.home:
              // Navigator.pushReplacementNamed(context, '/home');
              break;
            case SanginTab.orders:
              // Navigator.pushReplacementNamed(context, '/orders');
              break;
            case SanginTab.chat:
              // Navigator.pushReplacementNamed(context, '/chat');
              break;
            case SanginTab.mypage:
              // 이미 마이페이지
              break;
          }
        },
      ),
    );
  }
}

// -------------------- 하단 네비 --------------------

enum _BottomTab { home, orders, chat, mypage }

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.selected, required this.onTap});

  final _BottomTab selected;
  final ValueChanged<_BottomTab> onTap;

  static const kSelected = Color(0xFFFFA600);
  static const kUnselected = Color(0xFF757575);

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
            _item(_BottomTab.home, Icons.home_rounded),
            _item(_BottomTab.orders, Icons.receipt_long_rounded),
            _item(_BottomTab.chat, Icons.chat_bubble_rounded),
            _item(_BottomTab.mypage, Icons.person_rounded),
          ],
        ),
      ),
    );
  }

  Widget _item(_BottomTab tab, IconData icon) {
    final isSel = tab == selected;
    return GestureDetector(
      onTap: () => onTap(tab),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 22, color: isSel ? kSelected : kUnselected),
      ),
    );
  }
}

// -------------------- 상단 헤더 --------------------

class _StoreHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                'https://images.unsplash.com/photo-1560472355-536de3962603?q=80&w=1600&auto=format&fit=crop',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: 10,
            top: 10,
            child: _roundIcon(Icons.arrow_back_rounded),
          ),
          Positioned(
            right: 54,
            top: 10,
            child: _roundIcon(Icons.notifications_none_rounded),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: _roundIcon(Icons.bookmark_border_rounded),
          ),
        ],
      ),
    );
  }

  Widget _roundIcon(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Icon(icon, size: 20),
    );
  }
}

// -------------------- 가게 정보 카드 --------------------

class _StoreInfoCard extends StatelessWidget {
  static const kAccent = Color(0xFFFFA600);

  const _StoreInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDE7E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: const [
          _InfoRow(label: '카테고리', value: '채소·과일', icon: Icons.apple_rounded),
          SizedBox(height: 10),
          _InfoRow(
              label: '운영 시간',
              value: '매일 · 오전 11:00 ~ 오후 5:50',
              icon: Icons.schedule_rounded),
          SizedBox(height: 10),
          _InfoRow(
              label: '영업 시간', value: '1111-2222-3333', icon: Icons.call_rounded),
          SizedBox(height: 10),
          _InfoRow(
              label: '주소', value: '경동시장 3번 출구에서 100m 앞', icon: Icons.place_rounded),
          SizedBox(height: 10),
          _InfoRow(
              label: '픽업 존 주소',
              value: '경동시장 3번 출구에서 100m 앞',
              icon: Icons.pin_drop_rounded),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(
      {required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: 72,
            child: Text(label,
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
        const SizedBox(width: 8),
        Icon(icon, size: 18, color: _StoreInfoCard.kAccent),
        const SizedBox(width: 6),
        Expanded(
          child: Text(value,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

// -------------------- 탭 헤더 --------------------

class _TabHeader extends StatelessWidget {
  const _TabHeader({required this.index, required this.onChanged});
  final int index;
  final ValueChanged<int> onChanged;

  static const kAccent = Color(0xFFFFA600);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _tab('상품 관리', 0),
            const SizedBox(width: 24),
            _tab('리뷰 관리', 1),
          ],
        ),
        const SizedBox(height: 8),
        // 하이라이트 바
        Stack(
          children: [
            Container(height: 2, color: const Color(0xFFEDE7E0)),
            AnimatedAlign(
              alignment: index == 0 ? Alignment.centerLeft : Alignment.center,
              duration: const Duration(milliseconds: 200),
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Container(height: 3, color: kAccent),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _tab(String title, int i) {
    final sel = i == index;
    return GestureDetector(
      onTap: () => onChanged(i),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: sel ? FontWeight.w800 : FontWeight.w700,
        ),
      ),
    );
  }
}

// -------------------- 상품 그리드 --------------------

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.products});
  final List<_Product> products;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: products.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 18,
        crossAxisSpacing: 18,
        // 카드 비율 조정 (이미지+텍스트)
        childAspectRatio: 0.72,
      ),
      itemBuilder: (_, i) => _ProductCard(p: products[i]),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.p});
  final _Product p;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 이미지
        AspectRatio(
          aspectRatio: 1.2,
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(p.img, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 6,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  child: const Icon(Icons.open_in_new_rounded, size: 16),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // 제목
        Align(
          alignment: Alignment.centerLeft,
          child: Text(p.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
        ),
        const SizedBox(height: 4),
        // 판매율 + 남은수량
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '${p.soldPercent}% 판매완료, 남은 수량: ${p.leftQty}',
            style: const TextStyle(fontSize: 11, color: Color(0xFF777777)),
          ),
        ),
        const SizedBox(height: 4),
        // 프로그레스바 (퍼센트 연동)
        _ProgressBar(percent: p.soldPercent / 100.0),
        const SizedBox(height: 6),
        // 가격
        Row(
          children: [
            Text(p.price,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(width: 8),
            Text(
              p.originPrice,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF9E9E9E),
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.percent});
  final double percent; // 0.0 ~ 1.0

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 4,
        child: LinearProgressIndicator(
          value: percent.clamp(0, 1),
          backgroundColor: const Color(0xFFEDE7E0),
          color: const Color(0xFFFFA600),
          minHeight: 4,
        ),
      ),
    );
  }
}

// -------------------- 리뷰 탭 자리 --------------------

class _ReviewPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      alignment: Alignment.center,
      child: const Text('리뷰 관리 화면 준비 중',
          style: TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}

// -------------------- 모델 --------------------

class _Product {
  final String name;
  final String img;
  final int soldPercent; // 0~100
  final int leftQty;
  final String price;
  final String originPrice;

  const _Product({
    required this.name,
    required this.img,
    required this.soldPercent,
    required this.leftQty,
    required this.price,
    required this.originPrice,
  });
}
