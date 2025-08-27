// 일반 사용자 주문 완료 화면

// order_screen.dart
import 'package:flutter/material.dart';
import 'home_screen.dart';

const kFigmaGradient = LinearGradient(
  colors: [Color(0xFFC6007E), Color(0xFF93328E)],
  begin: Alignment(0.05, -0.00),
  end: Alignment(1.00, 1.22),
);

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '주문 완료',
          style: TextStyle(
            color: Color(0xFF28281A),
            fontSize: 32, // 피그마 크기
            fontWeight: FontWeight.w800,
            letterSpacing: -0.64,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        foregroundColor: const Color(0xFFC6007E), // 뒤로가기 아이콘 색
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 100),

            // 아이콘(캐릭터) 이미지
            SizedBox(
              width: 400,
              height: 300,
              child: Center(
                child: Image.asset(
                  'assets/icons/ggun_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 0),

            // GGUN 텍스트
            const SizedBox(
              width: 414,
              height: 54,
              child: Center(
                child: Text(
                  'GGUN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFC6007E),
                    fontSize: 36,
                    // fontFamily: 'Archivo Black', // 폰트 넣었으면 주석 해제
                    fontWeight: FontWeight.w900, // Archivo Black 대체 굵기
                    letterSpacing: -0.68,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 4),
                        blurRadius: 4,
                        color: Color(0x40000000),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 50), // 피그마 기반 30으로 줄여도 괜찮을듯?
            // 주문 완료 메시지
            const SizedBox(
              width: 402,
              height: 36,
              child: Center(
                child: Text(
                  '📦 주문이 완료되었습니다',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1A281B),
                    fontSize: 30,
                    // fontFamily: 'Inter', // 폰트 쓰면 주석 해제
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.60,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 50),

            // 확인 버튼
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                },
                child: Container(
                  width: 320,
                  height: 50,
                  decoration: ShapeDecoration(
                    gradient: kFigmaGradient,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 2,
                        color: Colors.white.withOpacity(0.60),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '✓  확인',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.30,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 4),
                            blurRadius: 4,
                            color: Color(0x40000000),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
