import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 600;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: isSmallScreen ? 250 : 300,
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
                  top: isSmallScreen ? 40 : 60,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/icons/appIcon.png',
                        height: isSmallScreen ? 80 : 100,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'BITEFEED',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 24 : 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        'SAVE & SHARE YOUR TASTY ADVENTURES',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 10 : 12,
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
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
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
                    'Login To Your Account',
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
                  const SizedBox(height: 32),
                  _buildLabel('Email'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    hintText: 'Enter Your Email Address',
                    iconPath: 'assets/icons/emailIcon.png',
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Password'),
                  const SizedBox(height: 8),
                  _buildPasswordField(),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.forgotPassword);
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildGradientButton(
                    text: 'Continue',
                    onPressed: () {},
                  ),
                  const SizedBox(height: 32),
                  _buildDivider(),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SocialButton(icon: 'assets/icons/googleIcon.png'),
                      const SizedBox(width: 20),
                      _SocialButton(icon: 'assets/icons/appleIcon.png'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.signup);
                        },
                        child: const Text(
                          'Signup',
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

  Widget _buildPasswordField() {
    return TextField(
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
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildGradientButton({required String text, required VoidCallback onPressed}) {
    return SizedBox(
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
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('or', style: TextStyle(color: Colors.grey.shade600)),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String icon;
  const _SocialButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Image.asset(icon, width: 30, height: 30),
    );
  }
}
