// 유저용 과일 상세 화면

import 'package:flutter/material.dart';
import 'order_screen.dart'; // ✅ 주문 완료 화면 import

/// ===== Design tokens =====
const kPink = Color(0xFFC7007D);
const kPurple = Color(0xFF94338F);

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
      backgroundColor: const Color(0xFFFFFDFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF281D1B),
      ),

      // ===== 본문 =====
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 이미지
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 11,
                    child: isAsset
                        ? Image.asset(image, fit: BoxFit.cover)
                        : Image.network(
                            image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Container(color: Colors.grey[200]),
                          ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Color(0x8C0E0D0D),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 타이틀 & 가격 카드
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상품명 더 볼드
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // 현재가 + (할인율/원가) 같은 라인
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _won(priceNow),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A281B),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (priceOrigin > priceNow) ...[
                        Text(
                          '${(discount * 100).round()}%',
                          style: const TextStyle(
                            color: kPurple,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _won(priceOrigin),
                          style: const TextStyle(
                            color: Color(0x9E132E15),
                            fontSize: 16,
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF0F0F0)),
              ),
              child: description.isNotEmpty
                  ? _SpecBox(description: description)
                  : const Text(
                      '상품 설명이 준비중입니다.',
                      style: TextStyle(fontSize: 13, height: 1.4),
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
          height: 70,
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
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
                // 장바구니
                SizedBox(
                  width: 150,
                  height: 45,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: kFigmaGradient,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.6),
                        width: 2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        '장바구니',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // 바로 구매하기 (onTap 추가됨 ✅)
                SizedBox(
                  width: 150,
                  height: 45,
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
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0x33C6007E),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            '바로 구매하기',
                            style: TextStyle(
                              color: Color(0xFFC6007E),
                              fontWeight: FontWeight.w700,
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
