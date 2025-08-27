import 'package:flutter/material.dart';

// widgets
import '../widgets/store_card.dart';
import '../widgets/category_icons.dart';
import '../widgets/local_svg_icon.dart';

class OrderSangin extends StatelessWidget {
  const OrderSangin({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = <_Order>[
      _Order(
        name: '이수혁',
        pickupWindow: '오후 6~7시',
        timeLabel: '오전 9:00',
        priceWon: 3500,
        qty: 1,
        avatarUrl:
            'https://images.unsplash.com/photo-1511367461989-f85a21fda167',
      ),
      _Order(
        name: '이수혁',
        pickupWindow: '오후 6~7시',
        timeLabel: '오전 7:00',
        priceWon: 7500,
        qty: 2,
        avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
      ),
      _Order(
        name: '이수혁',
        pickupWindow: '오후 6~7시',
        timeLabel: '오전 5:12',
        priceWon: 3500,
        qty: 1,
        avatarUrl: 'https://images.unsplash.com/photo-1554151228-14d9def656e4',
      ),
      _Order(
        name: '김서윤',
        pickupWindow: '오후 6~7시',
        timeLabel: '오전 4:00',
        priceWon: 3500,
        qty: 1,
        avatarUrl:
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFDFB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF28281A),
          ),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: '뒤로',
        ),
        centerTitle: true,
        title: const Text(
          '주문내역',
          style: TextStyle(
            color: Color(0xFF28281A),
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _OrderTile(order: orders[index]),
      ),
      bottomNavigationBar: const _BottomNav(currentIndex: 1),
    );
  }
}

class _Order {
  final String name;
  final String pickupWindow; // "오후 6~7시"
  final String timeLabel; // "오전 9:00"
  final int priceWon;
  final int qty;
  final String avatarUrl;
  const _Order({
    required this.name,
    required this.pickupWindow,
    required this.timeLabel,
    required this.priceWon,
    required this.qty,
    required this.avatarUrl,
  });
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order});
  final _Order order;

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFF28281A);
    const subText = Color(0xFF969487);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            offset: Offset(0, 2),
            color: Color(0x14000000),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(order.avatarUrl),
            backgroundColor: const Color(0xFFECEBE6),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        order.name,
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      order.timeLabel,
                      style: const TextStyle(
                        color: subText,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const _StatusDot(),
                  ],
                ),
                const SizedBox(height: 4),
                const SizedBox(height: 2),
                Text(
                  '픽업시간: ${order.pickupWindow}',
                  style: const TextStyle(
                    color: subText,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _TrashButton(
                      onTap: () {
                        // TODO: 삭제 로직 연결
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('삭제 로직을 연결하세요.')),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    _QtyPill(qty: order.qty),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 28),
              Text(
                _formatWon(order.priceWon),
                style: const TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatWon(int price) {
    final s = price.toString();
    final formatted = s.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '$formatted원';
  }
}

class _QtyPill extends StatelessWidget {
  const _QtyPill({required this.qty});
  final int qty;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F5F1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E3D8)),
      ),
      child: Text(
        '$qty',
        style: const TextStyle(
          color: Color(0xFF28281A),
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TrashButton extends StatelessWidget {
  const _TrashButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F5F1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE6E3D8)),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          size: 18,
          color: Color(0xFF6E6B62),
        ),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Color(0xFFFFAA00),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex});
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (i) {
        // TODO: 라우팅 연결
      },
      selectedItemColor: const Color(0xFF28281A),
      unselectedItemColor: const Color(0xFFB4B1A5),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_rounded),
          label: '주문',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline_rounded),
          label: '채팅',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_rounded),
          label: '프로필',
        ),
      ],
    );
  }
}
