import 'package:flutter/material.dart';
import 'detail_fruit_screen.dart';

// ===== Figma style constants =====
const kPink = Color(0xFFC7007D);
const kPurple = Color(0xFF94338F);
const kFigmaGradient = LinearGradient(
  colors: [kPink, kPurple],
  begin: Alignment(-0.9, -1.0),
  end: Alignment(1.0, 1.22),
);

class StoreDetailScreen extends StatefulWidget {
  static const routeName = '/store-detail';

  final String storeName;
  final String heroImageUrl;

  const StoreDetailScreen({
    super.key,
    required this.storeName,
    required this.heroImageUrl,
  });

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFDFB),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            _buildHeroAppBar(context),
            SliverToBoxAdapter(child: _buildHeader(context)),
            const SliverToBoxAdapter(child: SizedBox(height: 3)),
            const SliverToBoxAdapter(child: _StoreInfoBlock()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(const _PinnedTabBar(), height: 50),
            ),
          ],
          body: const TabBarView(
            children: [_ProductGrid(), _ReviewsPlaceholder()],
          ),
        ),
      ),
    );
  }

  // ===== HERO APP BAR =====
  SliverAppBar _buildHeroAppBar(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    return SliverAppBar(
      pinned: false,
      floating: false,
      snap: false,
      stretch: false,
      expandedHeight: 208,
      backgroundColor: const Color(0xFFFFFDFB),
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.fromLTRB(16, topInset + 10, 16, 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  widget.heroImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: Colors.grey[200]),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: _circleIcon(
                    context,
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.maybePop(context),
                  ),
                ),
                Positioned(
                  right: 54,
                  top: 10,
                  child: _circleIcon(context, icon: Icons.share, onTap: () {}),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: _circleIcon(
                    context,
                    icon: Icons.bookmark_border,
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===== HEADER =====
  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.storeName,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF281D1B),
            ),
          ),
          const SizedBox(height: 6),
          const Row(
            children: [
              Icon(Icons.star, size: 18, color: kPink),
              SizedBox(width: 4),
              Text(
                '4.2 (리뷰 8개) >',
                style: TextStyle(
                  color: Color(0xFF757575),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===== 공용 원형 아이콘 =====
  Widget _circleIcon(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFF757575), size: 20),
      ),
    );
  }
}

/// TabBar
class _PinnedTabBar extends StatelessWidget {
  const _PinnedTabBar();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFFDFB),
      elevation: 0,
      child: SizedBox(
        height: 52,
        child: TabBar(
          dividerColor: Colors.transparent,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(width: 6, color: Color(0xFFC6007E)),
            insets: EdgeInsets.symmetric(horizontal: 16),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: const Color(0xFF281D1B),
          unselectedLabelColor: const Color(0xFF757575),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
          labelPadding: const EdgeInsets.symmetric(vertical: 12),
          tabs: const [
            Tab(text: '상품 관리'),
            Tab(text: '리뷰'),
          ],
        ),
      ),
    );
  }
}

/// SliverPersistentHeader delegate
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;
  const _TabBarDelegate(this.child, {this.height = 50});

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      elevation: overlapsContent ? 1.5 : 0,
      color: const Color(0xFFFFFDFB),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) =>
      oldDelegate.height != height || oldDelegate.child != child;
}

/// 버튼 + 정보카드
class _StoreInfoBlock extends StatelessWidget {
  const _StoreInfoBlock();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 16),
            constraints: const BoxConstraints(minHeight: 130),
            decoration: BoxDecoration(
              color: const Color(0xFFF8EAF2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kPink, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 18,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(16, 26, 16, 15),
              child: StoreInfoTable(),
            ),
          ),
          Positioned(
            top: -4,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 130,
                height: 40,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: kFigmaGradient,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 2,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '가게 정보',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== 가게 정보 테이블 =====
class StoreInfoTable extends StatelessWidget {
  const StoreInfoTable({super.key});

  static const _labelStyle = TextStyle(
    color: Color(0xFF281D1B),
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.0,
  );
  static const _valueStyle = TextStyle(
    color: Color(0xFF757575),
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.0,
  );

  TableRow _row(
    String label,
    Widget value, {
    Widget? trailing,
    double vPad = 1,
  }) {
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.only(top: vPad, bottom: vPad),
          child: Text(label, style: _labelStyle),
        ),
        Padding(
          padding: EdgeInsets.only(top: vPad, bottom: vPad),
          child: value,
        ),
        Padding(
          padding: EdgeInsets.only(top: vPad, bottom: vPad),
          child: trailing ?? const SizedBox.shrink(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FixedColumnWidth(72),
        1: FlexColumnWidth(),
        2: IntrinsicColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        _row(
          '카테고리',
          Row(
            children: const [
              Icon(Icons.eco, size: 18, color: kPink),
              SizedBox(width: 6),
              Text('채소·과일', style: _valueStyle),
            ],
          ),
        ),
        _row(
          '운영 시간',
          const Text(
            '매일 · 오전 11:00 ~ 오후 5:50',
            style: _valueStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
        _row('가게 번호', const Text('1111-2222-3333', style: _valueStyle)),
        _row(
          '가게 주소',
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Flexible(
                child: Text(
                  '경동시장 3번 출구에서 100m 앞',
                  style: _valueStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.map_outlined, size: 18, color: Color(0xFF757575)),
              SizedBox(width: 2),
              Icon(
                Icons.navigation_outlined,
                size: 18,
                color: Color(0xFF757575),
              ),
            ],
          ),
          trailing: const SizedBox.shrink(),
          vPad: 2,
        ),
      ],
    );
  }
}

// ====== 탭 컨텐츠: 상품 그리드 ======
class _ProductGrid extends StatelessWidget {
  const _ProductGrid();

  @override
  Widget build(BuildContext context) {
    final products = [
      _P(
        '고당도 하우스 수박',
        'assets/img/fruit/watermelon.jpg',
        7000,
        13000,
        0.9,
        1,
        '''상품명: 고당도 하우스 수박
  원산지: 대한민국 경남 함안
  품종: 하우스 수박
  등급: 특
  중량: 6kg 내외
  수확 시기: 2025년 6월
  보관 방법: 서늘한 곳에서 보관, 절단 후 냉장 보관 시 2~3일
  판매자: 함안농원 박○○
  전화 문의: 010-2222-3333
  상품 설명:
  “하우스에서 정성껏 키운 고당도 수박입니다. 아삭한 식감과 12Brix 이상의 높은 당도를 자랑합니다. 소과종이라 혼자 먹기에도 적당해요.”''',
        isAsset: true,
      ),
      _P(
        '부사 사과',
        'assets/img/fruit/apple.jpg',
        3500,
        7000,
        0.8,
        2,
        '''상품명: 부사 사과 5kg (대과)
  원산지: 대한민국 경북 청송군
  품종: 부사
  등급: 특
  중량: 5kg (대과 13~15과)
  수확 시기: 2025년 10월
  보관 방법: 서늘하고 통풍이 잘 되는 곳, 냉장 보관 시 2~3주
  판매자: 청송농원 김○○
  전화 문의: 010-1234-5678
  상품 설명:
  “청송의 맑은 공기와 일교차 큰 기후에서 자란 달콤하고 아삭한 부사 사과입니다. 당도 14Brix 이상, 껍질까지 맛있고 신선합니다.”''',
        isAsset: true,
      ),
      _P(
        '당도최고 딸기',
        'assets/img/fruit/strawberry.jpg',
        3500,
        7000,
        0.9,
        1,
        '''상품명: 당도최고 딸기 (설향)
  원산지: 대한민국 충남 논산
  품종: 설향
  등급: 특
  중량: 500g (팩)
  수확 시기: 2025년 2월
  보관 방법: 냉장 보관, 구매 후 3일 이내 섭취 권장
  판매자: 논산딸기농원 이○○
  전화 문의: 010-3456-7890
  상품 설명:
  “논산에서 수확한 신선한 설향 딸기입니다. 입안 가득 퍼지는 달콤함과 풍부한 과즙이 특징으로 아이들 간식으로도 인기 만점입니다.”''',
        isAsset: true,
      ),
      _P(
        '꿀참외',
        'assets/img/fruit/oriental_melon.jpg',
        3500,
        7000,
        0.9,
        1,
        '''상품명: 꿀참외
  원산지: 대한민국 성주
  품종: 성주참외
  등급: 특
  중량: 1박스 (5kg, 10~12과)
  수확 시기: 2025년 7월
  보관 방법: 서늘한 곳에서 보관, 냉장 보관 시 1주일
  판매자: 성주참외농원 김○○
  전화 문의: 010-5678-1234
  상품 설명:
  “성주의 햇살과 맑은 물로 자란 꿀참외입니다. 아삭한 식감과 향긋한 단맛이 조화를 이루며, 비타민과 수분이 풍부합니다.”''',
        isAsset: true,
      ),
      _P(
        '맛있는 멜론',
        'assets/img/fruit/melon.png',
        3500,
        7000,
        0.9,
        1,
        '''상품명: 머스크 멜론
  원산지: 대한민국 전북 익산
  품종: 머스크
  등급: 특
  중량: 2kg 내외
  수확 시기: 2025년 8월
  보관 방법: 서늘한 곳에서 2~3일 후 숙성, 이후 냉장 보관
  판매자: 익산멜론농원 최○○
  전화 문의: 010-1111-4444
  상품 설명:
  “당도 높은 머스크 멜론으로 껍질 무늬가 곱고 향이 진합니다. 시원하게 냉장 보관 후 드시면 더욱 달콤하고 부드러운 과육을 맛보실 수 있습니다.”''',
        isAsset: true,
      ),
      _P(
        '씨없는 포도',
        'https://images.unsplash.com/photo-1506806732259-39c2d0268443?w=800',
        3500,
        7000,
        0.9,
        1,
        '''상품명: 씨없는 캠벨 포도
  원산지: 대한민국 충북 영동
  품종: 캠벨얼리 (씨제거)
  등급: 특
  중량: 2kg
  수확 시기: 2025년 9월
  보관 방법: 비닐 포장 제거 후 냉장 보관, 5일 이내 섭취
  판매자: 영동포도농원 박○○
  전화 문의: 010-9876-5432
  상품 설명:
  “씨가 없어 먹기 편리한 캠벨 포도입니다. 진한 향과 달콤한 맛으로 아이들 간식이나 디저트용으로 제격입니다.”''',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (_, i) => _ProductCard(p: products[i]),
      ),
    );
  }
}

class _P {
  final String name, image, description;
  final int priceNow, priceOrigin;
  final double soldRatio;
  final int leftQty;
  final bool isAsset;

  _P(
    this.name,
    this.image,
    this.priceNow,
    this.priceOrigin,
    this.soldRatio,
    this.leftQty,
    this.description, {
    this.isAsset = false,
  });
}

class _ProductCard extends StatelessWidget {
  final _P p;
  const _ProductCard({required this.p});

  @override
  Widget build(BuildContext context) {
    final progress = p.soldRatio.clamp(0.0, 1.0);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailFruitScreen(
              name: p.name,
              image: p.image,
              isAsset: p.isAsset,
              priceNow: p.priceNow,
              priceOrigin: p.priceOrigin,
              description: p.description,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: const Color(0xFFF0F0F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 11,
                    child: p.isAsset
                        ? Image.asset(p.image, fit: BoxFit.cover)
                        : Image.network(p.image, fit: BoxFit.cover),
                  ),
                  const Positioned(
                    top: 8,
                    right: 8,
                    child: _SmallIcon(icon: Icons.open_in_new),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // 이름
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                p.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF281D1B),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // 진행바
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: const Color(0xFFEAEAEA),
                  valueColor: const AlwaysStoppedAnimation(Color(0xFFC6007E)),
                ),
              ),
            ),
            const SizedBox(height: 6),

            // 상태 텍스트
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '${(progress * 100).toStringAsFixed(0)}% 판매완료, 남은 수량: ${p.leftQty}',
                style: const TextStyle(
                  color: Color(0xFF757575),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 6),

            // 가격
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _won(p.priceNow),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF281D1B),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _won(p.priceOrigin),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF9E9E9E),
                      decoration: TextDecoration.lineThrough,
                      decorationColor: Color(0xFF9E9E9E),
                      decorationThickness: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _won(int v) =>
      '${v.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}원';
}

class _SmallIcon extends StatelessWidget {
  final IconData icon;
  const _SmallIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(icon, size: 16, color: const Color(0xFF757575)),
    );
  }
}

// ====== 탭 컨텐츠: 리뷰 ======
class _ReviewsPlaceholder extends StatelessWidget {
  const _ReviewsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF0F0F0)),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.person, color: Color(0xFF757575)),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('사용자', style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(height: 6),
                  Text(
                    '신선하고 가격이 좋아요. 다음에 또 살게요!',
                    style: TextStyle(color: Color(0xFF424242)),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.star, size: 18, color: kPink),
          ],
        ),
      ),
    );
  }
}
