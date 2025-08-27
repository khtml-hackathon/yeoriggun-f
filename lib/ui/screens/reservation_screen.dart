import 'package:flutter/material.dart';

class ReservationScreen extends StatelessWidget {
  const ReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_Reservation>[
      _Reservation(
        title: '김씨네 채소가게 복주머니',
        time: '오전 9:00',
        qty: 1,
        price: 3500,
        image:
            'https://images.unsplash.com/photo-1511689660979-10d2b1aada49?q=80&w=300',
      ),
      _Reservation(
        title: '이씨네 과일가게 복주머니',
        time: '오전 7:00',
        qty: 2,
        price: 7500,
        image:
            'https://images.unsplash.com/photo-1542831371-29b0f74f9713?q=80&w=300',
      ),
      _Reservation(
        title: '한방한의원 복주머니',
        time: '오전 4:00',
        qty: 1,
        price: 3500,
        image:
            'https://images.unsplash.com/photo-1469474968028-56623f02e42e?q=80&w=300',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: const Color(0xFFC6007E),
        title: const Text(
          '예약 목록',
          style: TextStyle(
            color: Color(0xFF28281A),
            fontSize: 30,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.64,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, i) => _ReservationTile(data: items[i]),
      ),
    );
  }
}

class _Reservation {
  final String title, time, image;
  final int qty, price;
  _Reservation({
    required this.title,
    required this.time,
    required this.qty,
    required this.price,
    required this.image,
  });
}

class _ReservationTile extends StatelessWidget {
  const _ReservationTile({required this.data});
  final _Reservation data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 썸네일
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Image.network(
            data.image,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 64,
              height: 64,
              color: const Color(0xFFEDEDED),
              child: const Icon(Icons.image_not_supported, size: 20),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // 본문
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1행: 제목 + 시간
              Row(
                children: [
                  Expanded(
                    child: Text(
                      data.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    data.time,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 15,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 2행: 칩 + 가격 (정렬 맞춤)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center, // baseline 느낌 맞춤
                children: [
                  QtyChip(qty: data.qty),
                  Text(
                    _won(data.price),
                    style: const TextStyle(
                      color: Color(0xFF271C1A),
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class QtyChip extends StatelessWidget {
  final int qty;
  const QtyChip({super.key, required this.qty});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0x336D4F49)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // 내용에 맞게
        children: [
          const Icon(Icons.delete_outline, size: 16, color: Color(0xFF271C1A)),
          const SizedBox(width: 6),
          Text(
            '$qty',
            style: const TextStyle(
              color: Color(0xFF271C1A),
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

String _won(int v) {
  final s = v.toString();
  final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  return '${s.replaceAllMapped(reg, (m) => '${m[1]},')}원';
}
