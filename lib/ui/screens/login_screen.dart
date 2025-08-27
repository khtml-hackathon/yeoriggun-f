import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'home_sangin_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

enum UserType { personal, seller }

class _LoginScreenState extends State<LoginScreen> {
  final _idCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  UserType _type = UserType.personal;

  // 입력칸/버튼 공통 규격
  static const double kFieldWidth = 308;
  static const double kFieldHeight = 55;
  static const double kFieldRadius = 15;

  double _formWidth(BuildContext context) => kFieldWidth;

  @override
  Widget build(BuildContext context) {
    final formWidth = _formWidth(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFB),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const _LogoBlock(), // 이미지 + GGUN(가깝게)

                const SizedBox(height: 12),

                // 사용자 유형
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _radioItem(
                      '개인',
                      UserType.personal,
                      _type,
                      (v) => setState(() => _type = v),
                    ),
                    const SizedBox(width: 32),
                    _radioItem(
                      '상인',
                      UserType.seller,
                      _type,
                      (v) => setState(() => _type = v),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ID
                _OutlinedField(
                  controller: _idCtrl,
                  hint: 'ID',
                  width: formWidth,
                  height: kFieldHeight,
                  radius: kFieldRadius,
                ),
                const SizedBox(height: 10),

                // Password
                _OutlinedField(
                  controller: _pwCtrl,
                  hint: 'Password',
                  obscure: true,
                  width: formWidth,
                  height: kFieldHeight,
                  radius: kFieldRadius,
                ),

                const SizedBox(height: 12),

                // 로그인 버튼 (HomeScreen으로 전환)
                _PrimaryGradientButton(
                  label: '로그인',
                  width: formWidth,
                  height: kFieldHeight,
                  radius: kFieldRadius,
                  onPressed: () {
                    FocusScope.of(context).unfocus();

                    Widget targetScreen;
                    if (_type == UserType.personal) {
                      targetScreen = const HomeScreen(); // 개인 사용자 → 일반 홈
                    } else if (_type == UserType.seller) {
                      targetScreen = const HomeSanginScreen(); // 상인 사용자 → 상인 홈
                    } else {
                      targetScreen = const HomeScreen(); // 기본값 (예외 방지)
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => targetScreen),
                    );
                  },
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: 회원가입 이동
                    },
                    child: const Text(
                      '회원가입',
                      style: TextStyle(
                        color: Color(0xFF7C7C7C),
                        fontSize: 19.42,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
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

  // 라디오 아이템(컴팩트)
  static Widget _radioItem(
    String label,
    UserType value,
    UserType groupValue,
    ValueChanged<UserType> onChanged,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<UserType>(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
          value: value,
          groupValue: groupValue,
          activeColor: const Color(0xFFC6007E),
          onChanged: (v) => onChanged(v!),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF717171),
            fontSize: 18,
            fontFamily: 'Milonga',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

/// 이미지와 GGUN을 붙여서 표시
class _LogoBlock extends StatelessWidget {
  const _LogoBlock();

  static const Color kMagenta = Color(0xFFC6007E);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // GGUN 로고 (볼드 + 그림자)
        Text(
          'GGUN',
          style: TextStyle(
            fontSize: 44,
            fontWeight: FontWeight.w900,
            color: kMagenta,
            letterSpacing: 1.0,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.20),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '상인과 소비자를 이어주는 앱',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

/// GGUN 좌→우 그라데이션(#C6007E → #FFA600) + 그림자
class _GradientTitleGGUN extends StatelessWidget {
  const _GradientTitleGGUN();

  @override
  Widget build(BuildContext context) {
    const gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFFC6007E), Color(0xFFFFA600)],
    );

    return ShaderMask(
      shaderCallback: (r) =>
          gradient.createShader(Rect.fromLTWH(0, 0, r.width, r.height)),
      blendMode: BlendMode.srcIn,
      child: const Text(
        'GGUN',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Archivo Black',
          fontSize: 48,
          fontWeight: FontWeight.w900,
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
    );
  }
}

/// 외곽선 입력칸(세로 중앙 정렬, 버튼과 동일 크기)
class _OutlinedField extends StatelessWidget {
  const _OutlinedField({
    required this.controller,
    required this.hint,
    required this.width,
    required this.height,
    required this.radius,
    this.obscure = false,
  });

  final TextEditingController controller;
  final String hint;
  final double width;
  final double height;
  final double radius;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        textAlignVertical: TextAlignVertical.center, // 세로 중앙
        strutStyle: const StrutStyle(
          height: 1.0,
          leading: 0.0,
          forceStrutHeight: true,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFFCECECE),
            fontSize: 24,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
          isCollapsed: true, // 내부 세로 패딩 제거
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: const BorderSide(width: 3, color: Color(0xFFCECECE)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: const BorderSide(width: 3, color: Color(0xFFCECECE)),
          ),
        ),
      ),
    );
  }
}

/// 로그인 버튼(입력칸과 동일 크기)
class _PrimaryGradientButton extends StatelessWidget {
  const _PrimaryGradientButton({
    required this.label,
    required this.onPressed,
    required this.width,
    required this.height,
    required this.radius,
  });

  final String label;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFB0B0B0), Color(0xFF281D1B)],
          ),
          border: const Border.fromBorderSide(
            BorderSide(color: Color(0xFFCECECE), width: 3),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              offset: Offset(0, 6),
              blurRadius: 12,
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: onPressed,
            child: const Center(
              child: Text(
                '로그인',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.94,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
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
    );
  }
}
