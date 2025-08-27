import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/session_state.dart';

class ResultScreen extends StatelessWidget {
  ResultScreen({super.key});

  final TextEditingController _product = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _qty = TextEditingController();
  final TextEditingController _summary = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SessionState>();
    final img = state.selectedImage;
    final ar = state.analyzeResult;
    final stt = state.sttResult;

    _product.text = ar?.productName ?? '';
    _price.text = (ar?.price ?? 0).toString();
    _qty.text = (ar?.quantity ?? 0).toString();
    _summary.text = stt?.summary ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFDFB),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFFFFBF40),
            size: 32,
          ),
        ),
        title: const Text(
          '상품 추가',
          style: TextStyle(
            color: Color(0xFF281D1B),
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // 상품 이미지
                if (img != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.file(
                      img,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                const SizedBox(height: 32),
                // 상품 이름
                const Text(
                  '상품 이름',
                  style: TextStyle(
                    color: Color(0xFF281D1B),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0x40B0B0B0)),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: TextField(
                    controller: _product,
                    style: const TextStyle(fontSize: 16, color: Color(0xFF281D1B)),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // 가격
                const Text(
                  '가격',
                  style: TextStyle(
                    color: Color(0xFF281D1B),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0x40B0B0B0)),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: TextField(
                    controller: _price,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 16, color: Color(0xFF281D1B)),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // 수량
                const Text(
                  '수량',
                  style: TextStyle(
                    color: Color(0xFF281D1B),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0x40B0B0B0)),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: TextField(
                    controller: _qty,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 16, color: Color(0xFF281D1B)),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // 상세 설명
                const Text(
                  '상세 설명',
                  style: TextStyle(
                    color: Color(0xFF281D1B),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 165,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0x40B0B0B0)),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: TextField(
                    controller: _summary,
                    maxLines: null,
                    expands: true,
                    style: const TextStyle(fontSize: 16, color: Color(0xFF281D1B)),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFBF40),
              foregroundColor: const Color(0xFFFFFDFB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14.5),
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check, color: Color(0xFFFFFDFB)),
                SizedBox(width: 8),
                Text('상품등록하기'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


