import 'package:flutter/material.dart';

import 'button.dart';

class QueastionBoxDialog extends StatelessWidget {
  final String title;
  final Function() yesOnTap;
  final bool? isLoading;

  const QueastionBoxDialog({
    super.key,
    required this.title,
    required this.yesOnTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final isMobile = MediaQuery.of(context).size.width < 600;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Center(
              //   child: Lottie.asset(
              //     'assets/anim/error.json',
              //     width: 90,
              //     repeat: false,
              //   ),
              // ),
              // const SizedBox(height: 20),
              Center(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              isLoading!
                  ? const CircularProgressIndicator()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: MyButton(buttonText: 'بله', onTap: yesOnTap),
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: MyButton(
                              buttonText: 'خیر',
                              onTap: () {
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
