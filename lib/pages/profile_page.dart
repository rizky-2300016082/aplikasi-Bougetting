import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4EB7B2),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
          child: Column(
            children: [
              // Foto Profil + Nama
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.teal),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Darwin Nunes",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        "darwin@gmail.com",
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),

              // Tombol Edit & Bagikan
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigasi ke halaman edit profil (jika ada)
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Edit Profil"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Aksi share profil
                      },
                      icon: const Icon(Icons.share),
                      label: const Text("Bagikan Profil"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),

              // Motivasi
              _ProfileSection(
                title: "Motivasi",
                content:
                    "Wujudkan tujuan finansialmu satu per satu.\n\nBeliin dirancang untuk mencatat dan memantau progres tabunganmu—apakah itu untuk beli HP baru, liburan, atau impian lainnya.",
              ),
              const SizedBox(height: 16),

              // Catatan
              _ProfileSection(
                title: "Catatan",
                content:
                    "Wujudkan tujuan finansialmu satu per satu.\n\nBeliin dirancang untuk mencatat dan memantau progres tabunganmu—apakah itu untuk beli HP baru, liburan, atau impian lainnya.",
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const _BottomNavBar(currentIndex: 4),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final String content;

  const _ProfileSection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFB3ECEC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

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
