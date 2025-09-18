import 'package:flutter/material.dart';
import 'package:bike/widgets/animated_touch.dart';

class MyCheckbox extends StatefulWidget {
  const MyCheckbox({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyCheckboxState createState() => _MyCheckboxState();
}

class _MyCheckboxState extends State<MyCheckbox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context).colorScheme;
    return AnimatedTouch(
      scaleOnHover: 1.04,
      scaleOnPress: 0.94,
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: _themeData.primary, width: 2.2),
          color: _isChecked ? _themeData.primary : _themeData.onPrimary,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: _isChecked
              ? Center(
                  key: const ValueKey('dot'),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _themeData.onPrimary,
                    ),
                  ),
                )
              : const SizedBox.shrink(key: ValueKey('empty')),
        ),
      ),
    );
  }
}
