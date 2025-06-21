import 'package:flutter/material.dart';
// Import TabunganEntry dari buy_page.dart
import 'package:flutter_application_budget/pages/buy_page.dart';

class CreateBuyPage extends StatefulWidget {
  final TabunganEntry tabunganEntry; // Menerima objek TabunganEntry

  const CreateBuyPage({
    super.key,
    required this.tabunganEntry,
  });

  @override
  State<CreateBuyPage> createState() => _CreateBuyPageState();
}

class _CreateBuyPageState extends State<CreateBuyPage> {
  final TextEditingController _incomeNameController = TextEditingController();
  final TextEditingController _incomeAmountController = TextEditingController();

  double _savedAmount = 0.0;
  double _remainingAmount = 0.0;
  double _targetAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _targetAmount = widget.tabunganEntry.amount;
    _recalculateAmounts(); // Hitung ulang jumlah saat inisialisasi
  }

  @override
  void dispose() {
    _incomeNameController.dispose();
    _incomeAmountController.dispose();
    super.dispose();
  }

  void _recalculateAmounts() {
    // Perbaikan: Pastikan list expenses tidak null sebelum melakukan fold.
    // Jika expenses null, gunakan list kosong ([]) agar fold tetap berjalan dan mengembalikan 0.0.
    _savedAmount = (widget.tabunganEntry.expenses ?? []).fold<double>(
      0.0,
      (sum, item) => sum + (double.tryParse(item['amount'] ?? '0') ?? 0.0),
    );
    _remainingAmount = _targetAmount - _savedAmount;
  }

  void _addIncome() {
    setState(() {
      final String name = _incomeNameController.text;
      final double amount = double.tryParse(_incomeAmountController.text) ?? 0.0;

      if (name.isNotEmpty && amount > 0) {
        widget.tabunganEntry.expenses?.add({
          'name': name,
          'amount': amount.toStringAsFixed(0), // Format sebagai string integer
          'date': DateTime.now().toIso8601String().substring(0, 10), //YYYY-MM-DD
          'savings': widget.tabunganEntry.name, // Gunakan nama tabungan dari TabunganEntry
        });
        _recalculateAmounts(); // Hitung ulang setelah menambah pemasukan

        _incomeNameController.clear();
        _incomeAmountController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pemasukan berhasil ditambahkan!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nama pemasukan dan jumlah harus diisi dengan benar.')),
        );
      }
    });
  }

  void _deleteIncome(Map<String, String> incomeToDelete) {
    setState(() {
      widget.tabunganEntry.expenses?.remove(incomeToDelete); // Hapus dari list incomes di dalam TabunganEntry
      _recalculateAmounts(); // Hitung ulang setelah menghapus pemasukan
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pemasukan dihapus.')),
    );
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
          'Bougetting', // Konsisten dengan app bar lainnya
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.bar_chart, color: Colors.black, size: 30),
              onPressed: () {
                // Handle action for the icon
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tabungan Overview Card
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFB3ECEC),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.tabunganEntry.name, // Menampilkan nama tabungan
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rp ${formatCurrency(widget.tabunganEntry.amount)}', // Menampilkan target jumlah tabungan
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rp ${formatCurrency(_savedAmount)} saved',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Rp ${formatCurrency(_remainingAmount)} remaining',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: _targetAmount > 0 ? _savedAmount / _targetAmount : 0.0,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.green), // Warna progress bar untuk tabungan (hijau)
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Add New Income Card
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
                      'Tambahkan Pemasukan Baru',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _incomeNameController,
                      hintText: 'name income',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _incomeAmountController,
                      hintText: 'Amount',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _addIncome,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4EB7B2), // Warna tombol Add
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Income History Table
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
                      'Riwayat Pemasukan:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildIncomeTable(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const _BottomNavBar(currentIndex: 3), // Index untuk Beliin
    );
  }

  // Helper for text fields
  Widget _buildTextField({
    required TextEditingController controller,
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

  // Helper to build the income table
  Widget _buildIncomeTable() {
    return Table(
      border: TableBorder.all(color: Colors.black38),
      columnWidths: const {
        0: FlexColumnWidth(2), // Nama
        1: FlexColumnWidth(1.5), // Amount
        2: FlexColumnWidth(1.5), // Date
        3: FlexColumnWidth(2), // Savings (mengacu pada nama tabungan)
        4: FlexColumnWidth(1.5), // Action
      },
      children: [
        // Table Header
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[300]),
          children: [
            _buildTableCell('Nama', isHeader: true),
            _buildTableCell('Amount', isHeader: true),
            _buildTableCell('Date', isHeader: true),
            _buildTableCell('Savings', isHeader: true),
            _buildTableCell('Action', isHeader: true),
          ],
        ),
        // Table Rows from expenses list (now used for incomes)
        ...(widget.tabunganEntry.expenses ?? []).map((income) { // Menggunakan (expenses ?? [])
          return TableRow(
            children: [
              _buildTableCell(income['name']!),
              _buildTableCell(income['amount']!),
              _buildTableCell(income['date']!),
              _buildTableCell(income['savings']!), // Menampilkan nama tabungan
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteIncome(income),
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
        if (widget.tabunganEntry.expenses?.isEmpty ?? true) // Show a message if no incomes
          TableRow(
            children: [
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Belum ada pemasukan.',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
              ),
              _buildTableCell(''),
              _buildTableCell(''),
              _buildTableCell(''),
              _buildTableCell(''),
            ],
          ),
      ],
    );
  }

  // Helper for table cell styling
  static Widget _buildTableCell(String text, {bool isHeader = false}) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            color: Colors.black,
            fontSize: isHeader ? 14 : 12,
          ),
        ),
      ),
    );
  }
}

// Reusing _BottomNavBar from other pages
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
