import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/profile_page.dart';
import 'pages/budget_page.dart';
import 'pages/buy_page.dart';
import 'pages/add_page.dart';

void main() {
  runApp(const BudgetApp());
}

class BudgetApp extends StatelessWidget {
  const BudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      // Halaman awal aplikasi
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/signup': (_) => const SignupPage(),
        '/home': (_) => const HomePage(),
        '/budget': (_) => const BudgetPage(),
        '/buy': (_) => const BuyPage(),
        '/profile': (_) => const ProfilePage(),
        '/add': (_) => const AddPage(),
      },
    );
  }
}
