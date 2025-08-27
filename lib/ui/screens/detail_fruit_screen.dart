import 'package:flutter/material.dart';
import 'order_screen.dart'; // ✅ 주문 완료 화면 import
import '../../routes/app_routes.dart';

/// ===== Figma tokens (MCP) =====
const kSurfacePrimary = Color(0xFFFFFDFB); // surface/surface-primary: #fffdfb
const kSurfaceSecondary = Color(0xFFC6007E); // surface/surface-secondary: #c6007e
const kTextPrimary = Color(0xFF281D1B); // text/text-primary: #281d1b
const kTextTertiary = Color(0x9E757575); // text/text-tertiary: #7575759e
const kBorderPrimary = Color(0x80B0B0B0); // border/border-primary: #b0b0b080
const kRadius = 18.0; // radius: 18
const kMarginH = 16.0; // margin_horizontal: 16
const kMarginTop = 50.0; // marigin_top: 50

const kFigmaGradient = LinearGradient(
  colors: [Color(0xFFC6007E), Color(0xFF93328E)],
  begin: Alignment(0.05, -0.00),
  end: Alignment(1.00, 1.22),
);

/// 과일 상세 화면
class DetailFruitScreen extends StatelessWidget {
  static const routeName = '/detail-fruit';

  final String name;
  final String image; // assets path 또는 network url
  final int priceNow;
  final int priceOrigin;
  final String description; // "라벨: 값" 형태 줄들의 모음
  final bool isAsset; // true면 Image.asset, false면 Image.network

  const DetailFruitScreen({
    super.key,
    required this.name,
    required this.image,
    required this.priceNow,
    required this.priceOrigin,
    this.description = '',
    this.isAsset = false,
  });

  @override
  Widget build(BuildContext context) {
    final discount = (1 - (priceNow / (priceOrigin == 0 ? 1 : priceOrigin)))
        .clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: kSurfacePrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: kMarginTop,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: kSurfaceSecondary),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: '뒤로',
        ),
        title: const Text(
          '상품',
          style: TextStyle(
            color: kTextPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 32,
            letterSpacing: -0.64,
          ),
        ),
      ),

      // ===== 본문 =====
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(kMarginH, 0, kMarginH, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 이미지 (height: 250, radius: 18)
            ClipRRect(
              borderRadius: BorderRadius.circular(kRadius),
              child: SizedBox(
                height: 250,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    isAsset
                        ? Image.asset(image, fit: BoxFit.cover)
                        : Image.network(
                            image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Container(color: Colors.grey[200]),
                          ),
                    // Left circular back button over image
                    Positioned(
                      left: 9,
                      top: 9,
                      child: _CircleIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                    // Right circular like button over image
                    Positioned(
                      right: 9,
                      top: 9,
                      child: _CircleIconButton(
                        icon: Icons.favorite_border,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // 타이틀 & 가격 카드
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kRadius),
                border: Border.all(color: kBorderPrimary),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상품명 더 볼드
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.75,
                      color: kTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // 현재가 + (할인율/원가) 같은 라인
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _won(priceNow),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: kTextPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (priceOrigin > priceNow) ...[
                        Text(
                          '${(discount * 100).round()}%',
                          style: const TextStyle(
                            color: kSurfaceSecondary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _won(priceOrigin),
                          style: const TextStyle(
                            color: kTextTertiary,
                            fontSize: 18,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // 상세설명 박스
            SizedBox(
              width: double.infinity,
              height: 200,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(kRadius),
                  border: Border.all(color: kBorderPrimary),
                ),
                child: description.isNotEmpty
                    ? SingleChildScrollView(child: _SpecBox(description: description))
                    : const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '상품 설명이 준비중입니다.',
                          style: TextStyle(fontSize: 16, height: 1.4),
                        ),
                      ),
              ),
            ),

            // footer와 겹치지 않도록 여유
            const SizedBox(height: 100),
          ],
        ),
      ),

      // ===== 하단 고정 Footer 버튼 바 =====
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 74,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          decoration: ShapeDecoration(
            color: const Color(0x3393328E),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0x33C6007E)),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 장바구니 → 업로드(플로우 시작)
                SizedBox(
                  width: 158.7,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.upload);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kSurfaceSecondary,
                      foregroundColor: kSurfacePrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      '사진 업로드',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // 바로 구매하기 (기존 유지)
                SizedBox(
                  width: 158.7,
                  height: 44,
                  child: Material(
                    color:
                        Colors.transparent, // ✅ InkWell이 제대로 동작하도록 Material 추가
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        // 디버깅용 로그 (원하면 지워도 됨)
                        debugPrint('바로 구매하기 탭!');
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const OrderScreen(),
                          ), // ✅ 이동
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: kSurfacePrimary,
                          border: Border.all(
                            color: const Color(0x33C6007E),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            '바로 구매하기',
                            style: TextStyle(
                              color: kSurfaceSecondary,
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
          ),
        ),
      ),
    );
  }
}

/// Circular icon button used on top of the product image (matches Figma)
class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: kBorderPrimary),
        ),
        child: Icon(icon, size: 18, color: kTextPrimary),
      ),
    );
  }
}

/// 통일된 금액 포맷
String _won(int v) {
  final s = v.toString();
  final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  final formatted = s.replaceAllMapped(reg, (m) => '${m[1]},');
  return '$formatted원';
}

/// 설명 문자열에서 필요한 키만 뽑아 “상세설명” 섹션으로 보여주기
/// 노출 순서: 원산지, 품종, 등급, 중량, 수확 시기
class _SpecBox extends StatelessWidget {
  final String description;
  const _SpecBox({required this.description});

  static const _title = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: Color(0xFF281D1B),
  );
  static const _label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: Color(0xFF281D1B),
  );
  static const _value = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: Color(0xFF424242),
  );

  Map<String, String> _parse(String s) {
    final map = <String, String>{};
    for (final raw in s.split('\n')) {
      final line = raw.trim();
      if (line.isEmpty) continue;
      final i = line.indexOf(':');
      if (i <= 0) continue;
      final k = line.substring(0, i).trim();
      final v = line.substring(i + 1).trim();
      if (k.isNotEmpty && v.isNotEmpty) map[k] = v;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final data = _parse(description);
    const order = ['원산지', '품종', '등급', '중량', '수확 시기'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('상세설명', style: _title),
        const SizedBox(height: 10),
        for (final key in order)
          if (data.containsKey(key)) ...[
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '$key: ', style: _label),
                  TextSpan(text: data[key]!, style: _value),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
          ],
      ],
    );
  }
}
