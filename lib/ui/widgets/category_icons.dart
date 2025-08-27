import 'package:flutter/material.dart';
import 'local_svg_icon.dart';

/// 해산물 아이콘
class SeafoodIcon extends StatelessWidget {
  final double size;
  final Color color;

  const SeafoodIcon({
    super.key,
    this.size = 18,
    this.color = const Color(0xFFFFFDFB),
  });

  @override
  Widget build(BuildContext context) {
    return LocalSvgIcon('seafood', size: size, color: color);
  }
}

/// 조리식품 아이콘
class CookedIcon extends StatelessWidget {
  final double size;
  final Color color;

  const CookedIcon({
    super.key,
    this.size = 18,
    this.color = const Color(0xFFFFFDFB),
  });

  @override
  Widget build(BuildContext context) {
    return LocalSvgIcon('cooked', size: size, color: color);
  }
}

/// 채소·과일 아이콘
class VegieIcon extends StatelessWidget {
  final double size;
  final Color color;

  const VegieIcon({
    super.key,
    this.size = 18,
    this.color = const Color(0xFFFFFDFB),
  });

  @override
  Widget build(BuildContext context) {
    return LocalSvgIcon('vegetable', size: size, color: color);
  }
}

/// 장류·양념 아이콘
class SeasoningIcon extends StatelessWidget {
  final double size;
  final Color color;

  const SeasoningIcon({
    super.key,
    this.size = 18,
    this.color = const Color(0xFFFFFDFB),
  });

  @override
  Widget build(BuildContext context) {
    return LocalSvgIcon('seasoning', size: size, color: color);
  }
}

/// 한방 아이콘
class HealthIcon extends StatelessWidget {
  final double size;
  final Color color;

  const HealthIcon({
    super.key,
    this.size = 18,
    this.color = const Color(0xFFFFFDFB),
  });

  @override
  Widget build(BuildContext context) {
    return LocalSvgIcon('health', size: size, color: color);
  }
}
