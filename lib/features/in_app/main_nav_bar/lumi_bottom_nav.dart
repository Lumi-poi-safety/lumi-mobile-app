import 'dart:ui';

import 'package:flutter/material.dart';

class LumiBottomNav extends StatelessWidget {
  const LumiBottomNav({
    super.key,
    required this.index,
    required this.onTap,
    required this.items,
  });

  final int index;
  final ValueChanged<int> onTap;
  final List<IconData> items;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F9FC),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFD7DEE7)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(items.length, (i) {
              final selected = i == index;
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => onTap(i),
                child: SizedBox(
                  width: 64,
                  height: 44,
                  child: Icon(
                    items[i],
                    size: 22,
                    color: selected
                        ? const Color(0xFF65BFD3)
                        : const Color(0xFF1E2A33).withOpacity(0.45),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
