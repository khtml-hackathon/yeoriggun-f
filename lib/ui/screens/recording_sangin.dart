// 상인용 녹음화면

import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:my_app/ui/screens/add_reault_sangin.dart';

class RecordingSangin extends StatefulWidget {
  const RecordingSangin({super.key});

  @override
  State<RecordingSangin> createState() => _RecordingSanginState();
}

class _RecordingSanginState extends State<RecordingSangin> {
  // 컬러/스타일
  static const Color kBg = Color(0xFFFBF8F5);
  static const Color kAccent = Color(0xFFFFB300); // 파형/버튼 색
  static const double kRadius = 14;

  late final Stopwatch _watch;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _watch = Stopwatch()..start();
    _ticker = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _watch.stop();
    super.dispose();
  }

  String _elapsedText() {
    final ms = _watch.elapsedMilliseconds;
    final secs = (ms / 1000).floor();
    final min = (secs ~/ 60).toString().padLeft(2, '0');
    final sec = (secs % 60).toString().padLeft(2, '0');
    final frac = ((ms % 1000) / 10).floor().toString().padLeft(
      2,
      '0',
    ); // 1/100초
    return '$min:$sec.$frac';
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = _elapsedText();

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kBg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kAccent),
          onPressed: () => Navigator.pop(context),
          tooltip: '뒤로',
        ),
        centerTitle: true,
        title: const Text(
          '녹음',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 6),
            const Text(
              '대본 위치',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),

            // 파형
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: CustomPaint(
                  size: const Size(double.infinity, 120),
                  painter: _WavePainter(color: kAccent),
                ),
              ),
            ),

            const Spacer(),

            // 타이머 (회색 + 오렌지 조합)
            Builder(
              builder: (context) {
                final parts = elapsed.split(':'); // mm:ss.ff
                final mm = parts[0];
                final secFrac = parts[1]; // ss.ff
                final ss = secFrac.split('.').first;
                final ff = secFrac.split('.').last;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$mm:$ss',
                      style: const TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w800,
                        fontSize: 36,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      ff.length == 1 ? '0$ff' : ff, // 두 자리 보장
                      style: const TextStyle(
                        color: kAccent,
                        fontWeight: FontWeight.w900,
                        fontSize: 36,
                        height: 1.0,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // 완료 버튼 (노란색 + 그림자)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  icon: const Text(
                    '✓',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  label: const Text(
                    '녹음 완료',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                  onPressed: () {
                    final result = _elapsedText();
                    // Navigator.pop(context, result);  // 기존 뒤로가기 대신

                    // 👉 다음 페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddResultSangin(), // 이동할 위젯
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccent,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kRadius),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}

/// 스샷 느낌의 막대 파형을 대충 그려주는 페인터 (디자인 전용)
class _WavePainter extends CustomPainter {
  final Color color;
  _WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;

    final h = size.height;
    final yMid = h / 2;
    final startX = 16.0;
    final endX = size.width - 16.0;
    final bars = 36;
    final dx = (endX - startX) / (bars - 1);

    for (int i = 0; i < bars; i++) {
      final x = startX + dx * i;

      // ✅ sin/cos는 math.* 로 호출
      final t = (i / bars) * math.pi * 2;
      final base = (h * (0.28 + 0.22 * (1 + math.sin(1.2 * t)))) / 2;

      final barH = base.clamp(14.0, h * 0.9);
      final y1 = yMid - barH / 2;
      final y2 = yMid + barH / 2;

      canvas.drawLine(Offset(x, y1), Offset(x, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) => false;
}
