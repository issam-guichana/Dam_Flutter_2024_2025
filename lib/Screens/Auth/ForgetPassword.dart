import 'package:flutter/material.dart';
import 'package:flutter_application_dam/Providers/authProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_dam/Screens/Auth/OtpVerif.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  String _email = '';

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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.forgotPassword(_email);
      print("Success status: $success");

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OtpVerif()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Don't worry! It happens. Please enter the email associated with your account.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Consumer<AuthProvider>(
                                builder: (context, auth, _) => Column(
                                  children: [
                                    if (auth.error != null)
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          auth.error!,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Email',
                                        labelStyle: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(color: Colors.black),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(color: Colors.black),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                            color: Colors.redAccent,
                                            width: 2,
                                          ),
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.email,
                                          color: Colors.redAccent,
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        contentPadding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                          horizontal: 16,
                                        ),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        }
                                        if (!value.contains('@')) {
                                          return 'Please enter a valid email';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _email = value!;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
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
                                      onPressed: auth.isLoading ? null : _submitForm,
                                      child: auth.isLoading
                                          ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                          : const Text(
                                        'Submit',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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