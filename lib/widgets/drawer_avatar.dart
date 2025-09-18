import 'package:flutter/material.dart';
import 'package:bike/widgets/animated_touch.dart';

class DrawerAvatar extends StatelessWidget {
  const DrawerAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => AnimatedTouch(
        borderRadius: BorderRadius.circular(30),
        onTap: () => Scaffold.of(context).openEndDrawer(),
        child: CircleAvatar(
          maxRadius: 30,
          child: Image.asset('assets/img/profile.png', fit: BoxFit.contain),
        ),
      ),
    );
  }
}
