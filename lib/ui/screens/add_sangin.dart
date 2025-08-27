// 상품사진 등록 화면(shopkeeper_addproduct_picture)

import 'package:flutter/material.dart';
import 'package:my_app/ui/screens/recording_sangin.dart';
// import 'package:image_picker/image_picker.dart'; // 업로드(선택/촬영) 로직은 일단 주석 처리

class AddSangin extends StatefulWidget {
  const AddSangin({super.key});

  @override
  State<AddSangin> createState() => _AddSanginState();
}

class _AddSanginState extends State<AddSangin> {
  static const Color kBg = Color(0xFFFFFDFB);
  static const Color kAccent = Color(0xFFFFA600);
  static const Color kCard = Color(0xFFEDECEA);
  static const Color kIcon = Color(0xFF757575);
  static const Color kTitle = Color(0xFF2B2B2B);

  // final ImagePicker _picker = ImagePicker(); // 업로드 관련: 보류

  // ---- 업로드 대신 recording 화면으로 이동 ----
  void _goRecording() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const RecordingSangin()));
  }

  // // (보류) 카메라에서 이미지 선택 후 다음
  // Future<void> _pickFromCamera() async {
  //   final XFile? picked = await _picker.pickImage(
  //     source: ImageSource.camera,
  //     imageQuality: 90,
  //   );
  //   if (picked != null) _goRecording();
  // }

  // // (보류) 갤러리에서 이미지 선택 후 다음
  // Future<void> _pickFromGallery() async {
  //   final XFile? picked = await _picker.pickImage(
  //     source: ImageSource.gallery,
  //     imageQuality: 90,
  //   );
  //   if (picked != null) _goRecording();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: kAccent,
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: '뒤로',
        ),
        title: const Text(
          '상품 추가',
          style: TextStyle(
            color: kTitle,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final double cardHeight = c.maxWidth * 0.48;
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    '상품 사진 등록',
                    style: TextStyle(
                      color: kTitle,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 카메라 이동 -> recording
                  _ActionCard(
                    height: cardHeight,
                    label: '카메라 이동',
                    icon: Icons.photo_camera_outlined,
                    onTap: _goRecording,
                  ),
                  const SizedBox(height: 16),

                  // 갤러리 이동 -> recording
                  _ActionCard(
                    height: cardHeight,
                    label: '갤러리 이동',
                    icon: Icons.image_outlined,
                    onTap: _goRecording,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
    this.height = 200,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double height;

  static const Color kCard = _AddSanginState.kCard;
  static const Color kIcon = _AddSanginState.kIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 72, color: kIcon),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  color: kIcon,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
