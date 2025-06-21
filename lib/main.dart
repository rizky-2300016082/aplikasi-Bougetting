import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/profile_page.dart';
import 'pages/budget_page.dart';
import 'pages/buy_page.dart';
import 'pages/add_page.dart';
import 'pages/edit_profile_page.dart';
import 'pages/create_budget_page.dart';
import 'pages/create_buy_page.dart'; // Import halaman CreateBuyPage yang baru

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
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/signup': (_) => const SignupPage(),
        '/home': (_) => const HomePage(),
        '/budget': (_) => const BudgetPage(),
        '/buy': (_) => const BuyPage(),
        '/profile': (_) => const ProfilePage(),
        '/add': (_) => const AddPage(),
        '/edit_profile': (_) => const EditProfilePage(),
        // Rute untuk CreateBudgetPage dan CreateBuyPage tidak perlu didefinisikan di sini
        // karena kita akan menggunakannya dengan MaterialPageRoute untuk meneruskan argumen.
      },
    );
  }
}
