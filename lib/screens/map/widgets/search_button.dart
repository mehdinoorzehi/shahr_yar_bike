import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:bike/widgets/animated_touch.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key, required this.showSearchBox});

  final RxBool showSearchBox;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: 16,
      child: AnimatedTouch(
        borderRadius: BorderRadius.circular(12),
        onTap: () => showSearchBox.value = !showSearchBox.value,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text(
                'جستجو ایستگاه',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                LucideIcons.search,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
