import 'package:bike/widgets/button.dart';
import 'package:bike/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final TextEditingController _codeController = TextEditingController();
  String? scannedCode;

  void _onQrDetect(BarcodeCapture capture) {
    if (capture.barcodes.isNotEmpty) {
      setState(() {
        scannedCode = capture.barcodes.first.rawValue;
      });
      // میتونی اینجا مستقیم بفرستی به سرور یا لاگین کنی
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,
        title: const Text("اسکن دوچرخه", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.primary,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // 🔹 بخش اسکن QR
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  MobileScanner(onDetect: _onQrDetect),
                  // لایه شیشه‌ای برای نشون دادن محدوده QR
                  Center(
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  if (scannedCode != null)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "کد اسکن شده: $scannedCode",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // 🔹 بخش وارد کردن دستی کد
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "یا شماره پلاک دوچرخه را وارد کنید",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    MyTextFeild(
                      controller: _codeController,
                      textAlign: TextAlign.center,

                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    MyButton(
                      buttonText: 'تایید',
                      onTap: () {
                        final code = _codeController.text.trim();
                        if (code.isNotEmpty) {
                          // ارسال کد دستی
                          debugPrint("Manual code: $code");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
