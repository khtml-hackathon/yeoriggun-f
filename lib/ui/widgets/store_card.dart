import 'package:flutter/material.dart';

class StoreCard extends StatelessWidget {
  final String storeName;
  final String category;
  final double rating;
  final String priceRange;
  final String pickupTime;
  final String? imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onFavoritePressed;
  final bool isFavorite;

  /// 가게명 텍스트 스타일 커스텀(예: Public Sans 17 w700 -0.34)
  final TextStyle? titleStyle;

  /// 가게명 최대 표시 폭(즐겨찾기 아이콘과 겹침 방지)
  final double? titleMaxWidth;

  /// (선택) 카드 크기 고정이 필요할 때 지정. 기본은 null(내용에 맞게)
  final double? cardWidth;
  final double? cardHeight;

  const StoreCard({
    super.key,
    required this.storeName,
    required this.category,
    required this.rating,
    required this.priceRange,
    required this.pickupTime,
    this.imageUrl,
    this.onTap,
    this.onFavoritePressed,
    this.isFavorite = false,
    this.titleStyle,
    this.titleMaxWidth,
    this.cardWidth,
    this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    // 기본 타이틀 스타일(요청한 스펙)
    final defaultTitleStyle = const TextStyle(
      color: Color(0xFF271C1A),
      fontSize: 17,
      fontFamily: 'Public Sans', // pubspec에 등록되어 있어야 실제 폰트 적용됨
      fontWeight: FontWeight.w700,
      letterSpacing: -0.34,
    );

    // 카드 콘텐츠
    final cardChild = Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.withOpacity(0.25), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단: 가게명 + 즐겨찾기
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 가게명 (최대 폭 제한 옵션)
                  Flexible(
                    child: SizedBox(
                      width: titleMaxWidth ?? double.infinity,
                      child: Text(
                        storeName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: titleStyle ?? defaultTitleStyle,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onFavoritePressed,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? const Color(0xFFC6007E) : Colors.grey,
                      size: 24,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // 중간: 별점 · 가격 · 카테고리 · 픽업시간
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
              child: Row(
                children: [
                  const Icon(Icons.star, size: 12, color: Colors.orange),
                  const SizedBox(width: 2),
                  Text(
                    rating.toStringAsFixed(1),
                    style: TextStyle(
                      color: const Color(0xFF757575).withOpacity(0.62),
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    ' · $priceRange · $category · $pickupTime',
                    style: TextStyle(
                      color: const Color(0xFF757575).withOpacity(0.62),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // 하단: 썸네일
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                height: 144,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[200],
                ),
                child: _buildImage(),
              ),
            ),
          ],
        ),
      ),
    );

    // 카드 크기 고정 옵션이 있으면 SizedBox로 감싸기
    if (cardWidth != null || cardHeight != null) {
      return SizedBox(width: cardWidth, height: cardHeight, child: cardChild);
    }
    return cardChild;
  }

  Widget _buildImage() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              alignment: Alignment.center,
              child: const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => _fallbackImage(),
        ),
      );
    }
    return _fallbackImage();
  }

  Widget _fallbackImage() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[100],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.store, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            '이미지를 불러올 수 없습니다',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }
}
