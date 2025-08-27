import 'package:flutter/material.dart';

/// 간단한 상품 모델 (필요하면 프로젝트의 기존 모델로 대체)
class Product {
  final String id;
  final String name; // 예: "부사 사과 1개"
  final int price; // 현재가 (원)
  final int? originalPrice; // 정상가 (할인 전) - 없으면 null
  final String imageUrl; // 상품 이미지 URL
  final String origin; // 원산지
  final String variety; // 품종
  final String grade; // 등급
  final String weight; // 중량 예: "5kg (대과 1315과)"
  final String harvest; // 수확 시기 예: "2025년 10월"
  final int stock; // 재고 수량

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.origin,
    required this.variety,
    required this.grade,
    required this.weight,
    required this.harvest,
    required this.stock,
    this.originalPrice,
  });

  Product copyWith({
    String? name,
    int? price,
    int? originalPrice,
    String? imageUrl,
    String? origin,
    String? variety,
    String? grade,
    String? weight,
    String? harvest,
    int? stock,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      origin: origin ?? this.origin,
      variety: variety ?? this.variety,
      grade: grade ?? this.grade,
      weight: weight ?? this.weight,
      harvest: harvest ?? this.harvest,
      stock: stock ?? this.stock,
    );
  }
}

/// 수정 화면: 이전 화면에서 전달한 상품(Product)로 화면을 채움
class UpdateSanginPage extends StatefulWidget {
  final Product product;

  const UpdateSanginPage({super.key, required this.product});

  @override
  State<UpdateSanginPage> createState() => _UpdateSanginPageState();
}

class _UpdateSanginPageState extends State<UpdateSanginPage> {
  late final TextEditingController _priceCtrl;
  late final TextEditingController _stockCtrl;

  final _won = NumberFormat('#,###', 'ko_KR');

  @override
  void initState() {
    super.initState();
    _priceCtrl = TextEditingController(text: widget.product.price.toString());
    _stockCtrl = TextEditingController(text: widget.product.stock.toString());
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  int? _parseInt(String s) {
    final trimmed = s.trim();
    if (trimmed.isEmpty) return null;
    return int.tryParse(trimmed.replaceAll(',', ''));
  }

  double? _discountPercent(int price, int? original) {
    if (original == null || original <= 0 || price >= original) return null;
    final p = (1 - price / original) * 100;
    return (p * 10).round() / 10.0; // 소수점 1자리
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final discount = _discountPercent(p.price, p.originalPrice);

    return Scaffold(
      backgroundColor: const Color(0xFFE1EFF8), // 배경 블러 느낌
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 상단 이미지 영역
                  Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 4 / 3,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: Image.network(
                            p.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFFF2F2F2),
                              alignment: Alignment.center,
                              child: const Icon(Icons.image_not_supported),
                            ),
                          ),
                        ),
                      ),
                      // 뒤로가기
                      Positioned(
                        left: 12,
                        top: 12,
                        child: _circleIconButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: () => Navigator.pop(context),
                        ),
                      ),
                      // 하트
                      Positioned(
                        right: 12,
                        top: 12,
                        child: _circleIconButton(
                          icon: Icons.favorite_border_rounded,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),

                  // 상품 타이틀 + 가격 블록 (회색 박스)
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F4EF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE6E0D6)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${_won.format(p.price)}원',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (discount != null) ...[
                              Text(
                                '${discount.toStringAsFixed(discount % 1 == 0 ? 0 : 1)}%',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFFFA600),
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                            if (p.originalPrice != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: Text(
                                  _won.format(p.originalPrice),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF9E9E9E),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 상세 정보 + 수정 입력 폼
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE6E0D6)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 상세 스펙 텍스트
                        _kv('원산지', '대한민국 ${p.origin}'),
                        _kv('품종', p.variety),
                        _kv('등급', p.grade),
                        _kv('중량', p.weight),
                        _kv('수확 시기', p.harvest),
                        const SizedBox(height: 12),

                        // 가격 수정하기
                        const Text(
                          '가격 수정하기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _roundedField(
                          controller: _priceCtrl,
                          hintText: '가격(원)',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 14),

                        // 재고 수정하기
                        const Text(
                          '재고 수정하기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _roundedField(
                          controller: _stockCtrl,
                          hintText: '재고(수량)',
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 수정 완료 버튼
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB31A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 1,
                        ),
                        onPressed: () {
                          final newPrice =
                              _parseInt(_priceCtrl.text) ?? p.price;
                          final newStock =
                              _parseInt(_stockCtrl.text) ?? p.stock;
                          final updated = p.copyWith(
                            price: newPrice,
                            stock: newStock,
                          );
                          Navigator.pop(context, updated);
                        },
                        child: const Text(
                          '✓ 수정 완료',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
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
      ),
    );
  }

  // 회색 라운드 텍스트필드
  Widget _roundedField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        filled: true,
        fillColor: const Color(0xFFF7F4EF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE6E0D6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE6E0D6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFFB31A), width: 1.4),
        ),
      ),
    );
  }

  // key: value 한 줄
  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        '$k: $v',
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
          height: 1.35,
        ),
      ),
    );
  }

  // 동그란 아이콘 버튼
  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.black.withOpacity(0.35),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class NumberFormat {
  NumberFormat(String s, String t);

  format(int? price) {}
}
