import 'package:flutter/material.dart';

import '../hrd/hrd_common_widgets.dart';

class SyaratKetentuanKaryawanScreen extends StatelessWidget {
  const SyaratKetentuanKaryawanScreen({super.key});

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
          'Syarat & Ketentuan',
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
              'Harap baca syarat dan ketentuan ini dengan seksama sebelum menggunakan aplikasi kami.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF374151),
                height: 1.4,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Ketentuan Penggunaan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: HrdTheme.primaryBlue,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Sudah menjadi fakta yang terbukti bahwa seorang pembaca akan terdistraksi oleh konten halaman yang dapat dibaca saat melihat tata letaknya. Tujuan penggunaan Lorem Ipsum adalah agar teks tersebut memiliki distribusi huruf yang kurang lebih normal, berbeda dengan penggunaan \'Konten di sini, konten di sini\', membuatnya terlihat seperti Bahasa Indonesia yang dapat dibaca. Banyak paket penerbitan desktop dan editor web sekarang menggunakan Lorem Ipsum sebagai teks model standar mereka, dan pencarian \'lorem ipsum\' akan mengungkap banyak situs web yang masih dalam tahap awal. Berbagai versi telah berkembang selama bertahun-tahun, kadang secara tidak sengaja, kadang disengaja (humor yang disisipkan dan sejenisnya).',
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
