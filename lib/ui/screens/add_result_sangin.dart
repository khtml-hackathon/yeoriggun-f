import 'package:flutter/material.dart';
import 'home_sangin_screen.dart';

class AddResultSangin extends StatefulWidget {
  const AddResultSangin({super.key});

  @override
  State<AddResultSangin> createState() => _AddResultSanginState();
}

class _AddResultSanginState extends State<AddResultSangin> {
  // Accent color
  static const Color kAccent = Color(0xFFFFA600);
  static const Color kBg = Color(0xFFFFFDFB);
  static const double kRadius = 14;

  // Controllers
  final nameCtrl = TextEditingController(text: '사과');
  final priceCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();
  final descCtrl = TextEditingController(
    text: '원산지: 대한민국 경북 청송군\n'
        '품종: 부사\n'
        '등급: 특\n'
        '중량: 5kg (대과 1315과)\n'
        '수확 시기: 2025년 10월',
  );

  @override
  void dispose() {
    nameCtrl.dispose();
    priceCtrl.dispose();
    qtyCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 앱바
            _TopBar(
              title: '상품 추가',
              onBack: () => Navigator.of(context).maybePop(),
            ),

            // 본문
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionLabel('상품 사진 등록'),
                    const SizedBox(height: 10),
                    // 사진 박스 (고정 이미지로 표시)
                    _PhotoBox(
                      imageUrl:
                          'https://images.unsplash.com/photo-1576186726115-76e92f3c7d70?q=80&w=1200&auto=format&fit=crop',
                    ),
                    const SizedBox(height: 28),

                    const _SectionLabel('상품이름'),
                    const SizedBox(height: 8),
                    _InputBox(
                      controller: nameCtrl,
                      hintText: '사과',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 18),

                    const _SectionLabel('가격'),
                    const SizedBox(height: 8),
                    _InputBox(
                      controller: priceCtrl,
                      hintText: '',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 18),

                    const _SectionLabel('수량'),
                    const SizedBox(height: 8),
                    _InputBox(
                      controller: qtyCtrl,
                      hintText: '',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 18),

                    const _SectionLabel('설명'),
                    const SizedBox(height: 8),
                    _MultilineInputBox(controller: descCtrl),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // 하단 버튼
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_rounded, size: 22),
                  label: const Text(
                    '상품 등록하기',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // ✅ 특정 화면으로 이동 (등록 후 홈으로)
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeSanginScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

/// 상단 바
class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: onBack,
          ),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/// 섹션 라벨
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text, {this.top = 0});
  final String text;
  final double top;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: top),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

/// 사진 미리보기 박스
class _PhotoBox extends StatelessWidget {
  const _PhotoBox({required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEFEFEF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Center(
              child: Icon(Icons.image_not_supported_outlined, size: 36),
            ),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator(strokeWidth: 2));
            },
          ),
        ),
      ),
    );
  }
}

/// 단일줄 입력 박스
class _InputBox extends StatelessWidget {
  const _InputBox({
    required this.controller,
    required this.hintText,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE5E1DC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD8D2CB), width: 1.2),
        ),
      ),
    );
  }
}

/// 다줄 입력 박스(설명)
class _MultilineInputBox extends StatelessWidget {
  const _MultilineInputBox({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 140),
      child: TextField(
        controller: controller,
        maxLines: null,
        minLines: 6,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE5E1DC)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD8D2CB), width: 1.2),
          ),
        ),
      ),
    );
  }
}
