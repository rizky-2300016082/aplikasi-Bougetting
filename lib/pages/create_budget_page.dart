import 'package:flutter/material.dart';
// Asumsi import package name yang benar
import 'package:flutter_application_budget/pages/budget_page.dart'; // Import BudgetEntry dari budget_page.dart

class CreateBudgetPage extends StatefulWidget {
  final BudgetEntry budgetEntry; // Menerima objek BudgetEntry

  const CreateBudgetPage({
    super.key,
    required this.budgetEntry,
  });

  @override
  State<CreateBudgetPage> createState() => _CreateBudgetPageState();
}

class _CreateBudgetPageState extends State<CreateBudgetPage> {
  final TextEditingController _expenseNameController = TextEditingController();
  final TextEditingController _expenseAmountController = TextEditingController();

  // Kini menggunakan expenses dari widget.budgetEntry
  double _remainingAmount = 0.0;
  double _spentAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _recalculateAmounts(); // Hitung ulang jumlah saat inisialisasi
  }

  @override
  void dispose() {
    _expenseNameController.dispose();
    _expenseAmountController.dispose();
    super.dispose();
  }

  void _recalculateAmounts() {
    _spentAmount = widget.budgetEntry.expenses.fold(0.0, (sum, item) => sum + (double.tryParse(item['amount'] ?? '0') ?? 0.0));
    _remainingAmount = widget.budgetEntry.amount - _spentAmount;
  }

  void _addExpense() {
    setState(() {
      final String name = _expenseNameController.text;
      final double amount = double.tryParse(_expenseAmountController.text) ?? 0.0;

      if (name.isNotEmpty && amount > 0) {
        if (_remainingAmount >= amount) {
          widget.budgetEntry.expenses.add({ // Tambahkan ke list expenses di dalam BudgetEntry
            'name': name,
            'amount': amount.toStringAsFixed(0), // Format sebagai string integer
            'date': DateTime.now().toIso8601String().substring(0, 10), // YYYY-MM-DD
            'budget': widget.budgetEntry.name, // Gunakan nama budget dari BudgetEntry
          });
          _recalculateAmounts(); // Hitung ulang setelah menambah pengeluaran

          _expenseNameController.clear();
          _expenseAmountController.clear();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pengeluaran berhasil ditambahkan!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Jumlah pengeluaran melebihi sisa budget.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nama pengeluaran dan jumlah harus diisi dengan benar.')),
        );
      }
    });
  }

  void _deleteExpense(Map<String, String> expenseToDelete) {
    setState(() {
      widget.budgetEntry.expenses.remove(expenseToDelete); // Hapus dari list expenses di dalam BudgetEntry
      _recalculateAmounts(); // Hitung ulang setelah menghapus pengeluaran
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengeluaran dihapus.')),
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
          'Bougetting', // Consistent with other app bars
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
              // Budget Overview Card
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
                      widget.budgetEntry.name, // Display budget name dari BudgetEntry
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rp ${formatCurrency(widget.budgetEntry.amount)}', // Display total budget dari BudgetEntry
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
                          'Rp ${formatCurrency(_remainingAmount)} remaining',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Rp ${formatCurrency(_spentAmount)} spent',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: widget.budgetEntry.amount > 0 ? _spentAmount / widget.budgetEntry.amount : 0.0,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Add New Expense Card
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
                      'Tambahkan Pengeluaran Baru',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _expenseNameController,
                      hintText: 'name expense',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _expenseAmountController,
                      hintText: 'Amount',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _addExpense,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4EB7B2),
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

              // Expense History Table
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
                      'Riwayat Pengeluaran:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildExpenseTable(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const _BottomNavBar(currentIndex: 1), // Index untuk Bugetin
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

  // Helper to build the expense table
  Widget _buildExpenseTable() {
    return Table(
      border: TableBorder.all(color: Colors.black38),
      columnWidths: const {
        0: FlexColumnWidth(2), // Nama
        1: FlexColumnWidth(1.5), // Amount
        2: FlexColumnWidth(1.5), // Date
        3: FlexColumnWidth(2), // Budget (gunakan untuk nama budget)
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
            _buildTableCell('Budget', isHeader: true),
            _buildTableCell('Action', isHeader: true),
          ],
        ),
        // Table Rows from expenses list
        ...widget.budgetEntry.expenses.map((expense) { // Menggunakan expenses dari BudgetEntry
          return TableRow(
            children: [
              _buildTableCell(expense['name']!),
              _buildTableCell(expense['amount']!),
              _buildTableCell(expense['date']!),
              _buildTableCell(expense['budget']!), // Menampilkan nama budget
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteExpense(expense), // Panggil _deleteExpense
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
        if (widget.budgetEntry.expenses.isEmpty) // Show a message if no expenses
          TableRow(
            children: [
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Belum ada pengeluaran.',
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
