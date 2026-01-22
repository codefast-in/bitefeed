import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 250,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFF9881F),
                        Color(0xFFED1C24),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/icons/appIcon.png',
                        height: 80,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'BITEFEED',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      const Text(
                        'SAVE & SHARE YOUR TASTY ADVENTURES',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: -1,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Create Your Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enter Your Details To Get Started.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildLabel('Full Name'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    hintText: 'Enter Your Name',
                    iconPath: 'assets/icons/userIcon.png',
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Email'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    hintText: 'Enter Your Email Address',
                    iconPath: 'assets/icons/emailIcon.png',
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Phone Number'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    hintText: 'Enter Your Phone Number',
                    iconPath: 'assets/icons/mobileIcon.png',
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Password'),
                  const SizedBox(height: 8),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: '***********',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset('assets/icons/lockIcon.png', width: 20, height: 20),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset('assets/icons/eyeIcon.png', width: 20, height: 20),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFF9881F)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFF9881F)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Strong',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF9881F), Color(0xFFED1C24)],
                        ),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, AppRoutes.login);
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Color(0xFFF9881F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildTextField({required String hintText, required String iconPath}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(iconPath, width: 20, height: 20),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
