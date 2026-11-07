import 'package:flutter/material.dart';

import '../hrd/hrd_common_widgets.dart';

class KebijakanPrivasiKaryawanScreen extends StatelessWidget {
  const KebijakanPrivasiKaryawanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30, color: HrdTheme.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Kebijakan Privasi',
          style: TextStyle(
            color: HrdTheme.textDark,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: const [
            Text(
              'Terakhir diperbarui: 02/10/2026',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF9CA3AF),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Harap baca kebijakan privasi ini dengan seksama sebelum menggunakan aplikasi kami.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF374151),
                height: 1.4,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Kebijakan Privasi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: HrdTheme.primaryBlue,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Ada banyak variasi paragraf Lorem Ipsum yang tersedia, tetapi sebagian besar telah mengalami perubahan dalam beberapa bentuk, seperti humor yang disisipkan, atau kata-kata acak yang bahkan tidak terlihat sedikit pun dapat dipercaya. Jika Anda ingin menggunakan bagian dari Lorem Ipsum, Anda harus memastikan tidak ada hal yang mempermalukan yang tersembunyi di tengah teks. Semua generator Lorem Ipsum di Internet cenderung mengulang bagian yang telah ditentukan sebelumnya, menjadikan ini sebagai generator sejati pertama di Internet. Generator ini menggunakan kamus lebih dari 200 kata Latin, dikombinasikan dengan beberapa struktur kalimat model, untuk menghasilkan Lorem Ipsum yang terlihat masuk akal. Lorem Ipsum yang dihasilkan karenanya selalu bebas dari pengulangan, humor yang disisipkan, atau kata-kata tidak khas, dan lain-lain.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF4B5563),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

