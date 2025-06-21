import 'package:flutter/material.dart';
// Import halaman baru CreateBuyPage
import 'package:flutter_application_budget/pages/create_buy_page.dart';

// Definisi model data untuk TabunganEntry
class TabunganEntry {
  String name;
  double amount;
  List<Map<String, String>> expenses; // Hapus nullable '?' di sini karena selalu diinisialisasi

  TabunganEntry({
    required this.name,
    required this.amount,
    List<Map<String, String>>? expenses, // Parameter ini bisa nullable
  }) : expenses = expenses ?? []; // Inisialisasi di sini, jadi tidak ada duplikasi
}

class BuyPage extends StatefulWidget {
  const BuyPage({super.key});

  @override
  State<BuyPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  final TextEditingController _tabunganNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  // List untuk menyimpan semua objek TabunganEntry
  final List<TabunganEntry> _allTabungan = [];

  @override
  void dispose() {
    _tabunganNameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _createAndNavigateToTabunganDetail() async {
    final String name = _tabunganNameController.text;
    final double? amount = double.tryParse(_amountController.text);

    if (name.isNotEmpty && amount != null && amount > 0) {
      final newTabungan = TabunganEntry(name: name, amount: amount);

      setState(() {
        _allTabungan.add(newTabungan); // Tambahkan ke daftar tabungan
      });

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateBuyPage(
            tabunganEntry: newTabungan, // Meneruskan objek TabunganEntry lengkap
          ),
        ),
      );

      // Setelah kembali dari CreateBuyPage, panggil setState untuk merefresh UI
      setState(() {
        // Tidak perlu logika spesifik di sini, hanya memicu build ulang
      });

      _tabunganNameController.clear();
      _amountController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama Tabungan dan Jumlah harus diisi dengan benar.')),
      );
    }
  }

  // Fungsi untuk menavigasi ke halaman detail tabungan yang sudah ada
  void _navigateToExistingTabunganDetail(TabunganEntry tabungan) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateBuyPage(
          tabunganEntry: tabungan, // Meneruskan objek TabunganEntry yang sudah ada
        ),
      ),
    );

    // Setelah kembali dari CreateBuyPage, panggil setState untuk merefresh UI
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
          'Beliin Page', // Judul tetap 'Beliin Page'
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
              // Card "Buat Tabungan baru:"
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
                      'Buat Tabungan baru:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _tabunganNameController,
                      labelText: 'Nama Tabungan :',
                      hintText: 'Misal: Tabungan HP Baru',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _amountController,
                      labelText: 'Amount :',
                      hintText: 'Misal: 3000000',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _createAndNavigateToTabunganDetail, // Panggil fungsi baru
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4EB7B2), // Warna tombol Create
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

              // Card "Daftar Tabungan:"
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
                      'Daftar Tabungan:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Menampilkan daftar tabungan yang sudah dibuat
                    _allTabungan.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Belum ada tabungan yang dibuat.',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _allTabungan.length,
                            itemBuilder: (context, index) {
                              final tabungan = _allTabungan[index];
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
                                    tabungan.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                  subtitle: Text(
                                    'Jumlah: Rp ${formatCurrency(tabungan.amount)}',
                                    style: const TextStyle(color: Colors.black54),
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 16),
                                  onTap: () => _navigateToExistingTabunganDetail(tabungan), // Navigasi ke detail
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
      bottomNavigationBar: const _BottomNavBar(currentIndex: 3), // currentIndex for Beliin is 3
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

// _BottomNavBar lokal untuk BuyPage
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
            Navigator.pushReplacementNamed(context, '/budget');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/add');
            break;
          case 3:
            // stay
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
