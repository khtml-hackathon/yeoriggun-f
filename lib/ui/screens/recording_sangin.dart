import 'dart:async';
import 'package:flutter/material.dart';

class RecordingSangin extends StatefulWidget {
  const RecordingSangin({super.key});

  @override
  State<RecordingSangin> createState() => _RecordingSanginState();
}

class _RecordingSanginState extends State<RecordingSangin> {
  static const kAccent = Color(0xFFFFA600);
  static const kBg = Color(0xFFFFFDFB);

  final Stopwatch _watch = Stopwatch();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // 화면 들어오면 바로 경과 시간 업데이트(실제 녹음 로직과는 분리: UI용)
    _watch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _watch.stop();
    super.dispose();
  }

  String _elapsedString() {
    final ms = _watch.elapsedMilliseconds;
    final minutes = (ms ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((ms % 60000) ~/ 1000).toString().padLeft(2, '0');
    final hundredths = (((ms % 1000) / 10).floor()).toString().padLeft(2, '0');
    return '$minutes:$seconds.$hundredths';
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = _elapsedString();

    // "00:06.10" 에서 분:회색 / 초.소수:주황색 표현
    final splitIndex = elapsed.indexOf(':'); // "00" | ":06.10"
    final grayPart = elapsed.substring(0, splitIndex + 1); // "00:"
    final orangePart = elapsed.substring(splitIndex + 1);   // "06.10"

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            // 상단바
            SizedBox(
              height: 56,
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                    color: kAccent,
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: 4),
                  const Expanded(
                    child: Text(
                      '녹음',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(width: 48), // 오른쪽 균형 맞춤
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 파형 (디자인 고정, 주황색)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _Waveform(color: kAccent),
            ),

            const SizedBox(height: 28),

            // 타이머 (회색/주황 혼합)
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: grayPart,
                    style: const TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  TextSpan(
                    text: orangePart,
                    style: const TextStyle(
                      color: kAccent,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

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
                        builder: (context) => const RecordingResultPage(), // 이동할 위젯
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


            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}

/// 고정 파형(디자인 전용). 실제 오디오 시각화 로직은 건드리지 않음.
class _Waveform extends StatelessWidget {
  const _Waveform({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    // 스크린샷 느낌에 맞춘 막대 높이 패턴
    const bars = <double>[
      18, 28, 44, 64, 82, 96, 86, 72, 54, 36, 24, 18,
      22, 38, 58, 78, 96, 88, 70, 52, 34, 22, 18,
      20, 34, 52, 72, 88, 98, 84, 66, 48, 30, 22, 18,
    ];

    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
      ),
      child: Center(
        child: SizedBox(
          height: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final h in bars) ...[
                Container(
                  width: 6,
                  height: h,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
