import 'package:flutter/material.dart';

class ItemOfTransaction extends StatelessWidget {
  const ItemOfTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListTile(
        contentPadding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
        leading: Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Theme.of(context).colorScheme.primary.withValues(alpha:0.1),
          ),
        ),
        title: Row(
          children: [
            Text(
              'عنوان تراکنش',
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.apply(fontSizeFactor: 0.85),
            ),
            const Spacer(),
            Text('15,000 تومان', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        subtitle: Row(
          children: [
            Text(
              'زمان تراکنش',
              style: Theme.of(
                context,
              ).textTheme.titleSmall!.apply(fontSizeFactor: 0.9),
            ),
            const Spacer(),
            Text(
              'افزایش موجودی',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(width: 5),
            Icon(
              Icons.arrow_circle_up_rounded,
              size: 17,
              color: Colors.indigo[600],
            ),
          ],
        ),
      ),
    );
  }
}
