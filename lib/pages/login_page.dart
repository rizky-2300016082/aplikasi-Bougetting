import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Import halaman lain yang akan dituju
import 'home_page.dart';
import 'signup_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisikan warna yang akan digunakan sesuai gambar
    const Color primaryColor = Color(0xFF68B9B1);
    const Color inputFieldColor = Color(0xFFEFFFFC);
    const Color linkColor = Color(0xFF3B4FE3);

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Placeholder untuk Logo
                const Icon(
                  Icons.bar_chart_rounded,
                  color: Colors.white,
                  size: 60,
                ),
                const SizedBox(height: 40),

                // Card Form Login
                Container(
                  padding: const EdgeInsets.all(28.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 10,
                        )
                      ]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Teks Judul
                      const Text(
                        'Selamat Datang di Bugetting',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Link untuk Daftar
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                          children: [
                            const TextSpan(text: 'Sudah Punya Akun? '),
                            TextSpan(
                              text: 'Daftar dulu yuk!',
                              style: const TextStyle(
                                color: linkColor,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // NAVIGASI KE SIGNUP PAGE
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SignupPage()),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Input Email
                      const Text('Email *', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                      const SizedBox(height: 8),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: inputFieldColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Input Password
                      const Text('Password', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                      const SizedBox(height: 8),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: inputFieldColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Tombol Login
                      ElevatedButton(
                        onPressed: () {
                          // NAVIGASI KE HOME PAGE
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text(
                          'Login',
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
    );
  }
}