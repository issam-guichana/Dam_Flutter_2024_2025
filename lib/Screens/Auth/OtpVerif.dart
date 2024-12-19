import 'package:flutter/material.dart';
import 'package:flutter_application_dam/Providers/OTPProvider.dart';
import 'package:flutter_application_dam/Screens/Auth/reset_password.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpVerif extends StatefulWidget {
  const OtpVerif({super.key});

  @override
  _OtpVerifState createState() => _OtpVerifState();
}

class _OtpVerifState extends State<OtpVerif> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  String _otp = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitOtp(BuildContext context) async {
    final otpProvider = Provider.of<OtpProvider>(context, listen: false);
    await otpProvider.verifyOtp(_otp);

    if (otpProvider.isVerified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ResetPassword()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.redAccent),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.orange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 150,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: Image.asset('assets/gourmetia_logo.png'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              'OTP Verification',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Enter the OTP sent to your number',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Consumer<OtpProvider>(
                              builder: (context, provider, child) {
                                if (provider.error != null) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Text(
                                      provider.error!,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                            Pinput(
                              length: 4,
                              pinAnimationType: PinAnimationType.slide,
                              defaultPinTheme: defaultPinTheme,
                              onCompleted: (pin) => setState(() => _otp = pin),
                            ),
                            const SizedBox(height: 20),
                            Consumer<OtpProvider>(
                              builder: (context, provider, child) {
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                      horizontal: 24,
                                    ),
                                    backgroundColor: Colors.redAccent,
                                    elevation: 4,
                                    shadowColor: Colors.black45,
                                  ),
                                  onPressed: provider.isLoading
                                      ? null
                                      : () => _submitOtp(context),
                                  child: provider.isLoading
                                      ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                      : const Text(
                                    'Submit',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                // Resend OTP logic here
                              },
                              child: const Text(
                                "Didn't receive the OTP? Resend",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}