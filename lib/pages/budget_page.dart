import 'package:flutter/material.dart';
// Koreksi import package name. Asumsi nama proyek: flutter_application_budget
import 'package:flutter_application_budget/pages/create_budget_page.dart';

// Definisi model data untuk BudgetEntry.
class BudgetEntry {
  String name;
  double amount;
  List<Map<String, String>> expenses; // List untuk menyimpan pengeluaran

  BudgetEntry({
    required this.name,
    required this.amount,
    List<Map<String, String>>? expenses,
  }) : expenses = expenses ?? []; // Inisialisasi jika null
}

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final TextEditingController _budgetNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  // List untuk menyimpan semua objek BudgetEntry
  final List<BudgetEntry> _allBudgets = [];

  @override
  void dispose() {
    _budgetNameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _createAndNavigateToBudgetDetail() async { // Tambahkan async di sini
    final String name = _budgetNameController.text;
    final double? amount = double.tryParse(_amountController.text);

    if (name.isNotEmpty && amount != null && amount > 0) {
      // Buat objek BudgetEntry baru
      final newBudget = BudgetEntry(name: name, amount: amount);

      setState(() {
        _allBudgets.add(newBudget); // Tambahkan ke daftar budget
      });

      // Navigasi ke halaman detail budget, meneruskan objek budget
      await Navigator.push( // Gunakan await
        context,
        MaterialPageRoute(
          builder: (context) => CreateBudgetPage(
            budgetEntry: newBudget, // Meneruskan objek BudgetEntry lengkap
          ),
        ),
      );

      // Setelah kembali dari CreateBudgetPage, panggil setState untuk merefresh UI
      setState(() {
        // Tidak perlu logika spesifik di sini, hanya memicu build ulang
      });

      _budgetNameController.clear();
      _amountController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama Budget dan Jumlah harus diisi dengan benar.')),
      );
    }
  }

  // Fungsi untuk menavigasi ke halaman detail budget yang sudah ada
  void _navigateToExistingBudgetDetail(BudgetEntry budget) async { // Tambahkan async di sini
    await Navigator.push( // Gunakan await
      context,
      MaterialPageRoute(
        builder: (context) => CreateBudgetPage(
          budgetEntry: budget, // Meneruskan objek BudgetEntry yang sudah ada
        ),
      ),
    );

    // Setelah kembali dari CreateBudgetPage, panggil setState untuk merefresh UI
    setState(() {
      // Tidak perlu logika spesifik di sini, hanya memicu build ulang
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4EB7B2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB3ECEC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Bugetin',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card "Buat Budget baru:"
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFB3ECEC),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Buat Budget baru:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _budgetNameController,
                      labelText: 'Nama Budget :',
                      hintText: 'Misal: Liburan Bali',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _amountController,
                      labelText: 'Amount :',
                      hintText: 'Misal: 5000000',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _createAndNavigateToBudgetDetail,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4EB7B2),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        ),
                        child: const Text(
                          'Create',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Card "Daftar Budget:"
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFB3ECEC),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daftar Budget:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Menampilkan daftar budget yang sudah dibuat
                    _allBudgets.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Belum ada budget yang dibuat.',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _allBudgets.length,
                            itemBuilder: (context, index) {
                              final budget = _allBudgets[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                color: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: const Color(0xFF4EB7B2),
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  title: Text(
                                    budget.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                  subtitle: Text(
                                    'Jumlah: Rp ${formatCurrency(budget.amount)}',
                                    style: const TextStyle(color: Colors.black54),
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 16),
                                  onTap: () => _navigateToExistingBudgetDetail(budget),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const _BottomNavBar(currentIndex: 1),
    );
  }

  // Widget helper untuk membuat TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black54),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // Helper to format currency
  String formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}

// _BottomNavBar lokal untuk BudgetPage
class _BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const _BottomNavBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    Color activeColor = Colors.black;
    Color inactiveColor = Colors.black54;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: activeColor,
      unselectedItemColor: inactiveColor,
      backgroundColor: const Color(0xFFB3ECEC),
      showUnselectedLabels: true,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 1:
          // stay
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/add');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/buy');
            break;
          case 4:
            Navigator.pushReplacementNamed(context, '/profile');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.description), label: "Bugetin"),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: "Beliin"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
