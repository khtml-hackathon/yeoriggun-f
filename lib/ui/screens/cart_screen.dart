// 일반 사용자 home_screen.dart에서 “장바구니” 버튼 눌렀을 때 뜨는 화면
// 최종 수정 때 장바구니 얘기가 나와 미리 만들어 놓음, 아직 연결은 안 함

import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (_, i) => ListTile(
                  title: Text('Product ${i + 1}'),
                  trailing: const Text('₩9,900'),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Total: ₩29,700',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                ElevatedButton(onPressed: () {}, child: const Text('Checkout')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
