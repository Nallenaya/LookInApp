import 'package:flutter/material.dart';

import 'hrd_common_widgets.dart';

class DetailPengajuanScreen extends StatefulWidget {
  const DetailPengajuanScreen({
    super.key,
    required this.item,
    required this.onDecide,
  });

  final Map<String, dynamic> item;
  final Future<void> Function(String status, String note) onDecide;

  @override
  State<DetailPengajuanScreen> createState() => _DetailPengajuanScreenState();
}

class _DetailPengajuanScreenState extends State<DetailPengajuanScreen> {
  final _noteController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit(String status) async {
    setState(() => _saving = true);
    try {
      await widget.onDecide(status, _noteController.text.trim());
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final user = item['user'];
    final name = user is Map
        ? user['name']?.toString() ?? 'Karyawan'
        : 'Karyawan';
    final division = user is Map
        ? user['division']?.toString() ??
            (item['division']?.toString() ?? 'Desain')
        : 'Desain';
    final type = item['type']?.toString() ?? '';
    final start = _approvalDate(item['start_date']);
    final end = _approvalDate(item['end_date']);
    final dateRange = end.isEmpty || end == start ? start : '$start–$end';

    // Calculate duration in days or hours
    final duration = _calculateDuration(item);
    final createdAt = DateTime.tryParse(item['created_at']?.toString() ?? '');
    final submittedDate = createdAt == null
        ? '11 Okt 2026, 07:45'
        : '${_approvalDate(createdAt.toIso8601String())}, ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
    final reason = item['reason']?.toString() ?? '—';

    final hasDocument = type == 'sakit' || type == 'lembur';
    final documentName = type == 'sakit'
        ? 'surat_dokter.pdf'
        : type == 'lembur'
        ? 'surat_perintah_lembur.pdf'
        : 'dokumen_pendukung.pdf';

    return Scaffold(
      backgroundColor: HrdTheme.scaffoldBg,
      appBar: AppBar(
        backgroundColor: HrdTheme.scaffoldBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28, color: HrdTheme.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Detail Pengajuan',
          style: TextStyle(
            color: HrdTheme.textDark,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  // Card 1: User Profile & Badge
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: HrdTheme.cardShadow,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: const Color(0xFFDCE8FF),
                          child: Text(
                            name.isEmpty ? '?' : name[0].toUpperCase(),
                            style: const TextStyle(
                              color: HrdTheme.primaryBlue,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: HrdTheme.textDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                division,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: HrdTheme.textGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildBadge(type),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Card 2: Dates, Duration, Submitted, Reason
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: HrdTheme.cardShadow,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoItem('Tanggal', dateRange),
                        const SizedBox(height: 12),
                        _infoItem('Durasi', duration),
                        const SizedBox(height: 12),
                        _infoItem('Diajukan', submittedDate),
                        const SizedBox(height: 12),
                        _infoItem('Alasan', reason),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Card 3: Document Preview
                  if (hasDocument)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: HrdTheme.cardShadow,
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCE8FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.description_outlined,
                              color: HrdTheme.primaryBlue,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  documentName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: HrdTheme.textDark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Dokumen pendukung · 240 KB',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: HrdTheme.textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Membuka $documentName'),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: HrdTheme.primaryBlue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: const Text(
                              'Lihat',
                              style: TextStyle(
                                color: HrdTheme.primaryBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),

                  // HRD Optional Notes
                  const Text(
                    'Catatan HRD (opsional)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: HrdTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _noteController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Tambahkan catatan',
                        hintStyle: const TextStyle(
                          color: HrdTheme.textLightGrey,
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.all(14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: HrdTheme.primaryBlue,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Bottom Buttons: Tolak & Setujui
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFEEF0F2))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: _saving ? null : () => _submit('rejected'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: HrdTheme.redBorder,
                            width: 1.3,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Tolak',
                          style: TextStyle(
                            color: HrdTheme.redBorder,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: FilledButton(
                        onPressed: _saving ? null : () => _submit('approved'),
                        style: FilledButton.styleFrom(
                          backgroundColor: HrdTheme.primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _saving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Setujui',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: HrdTheme.textGrey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: HrdTheme.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String type) {
    final (bg, text, label) = switch (type) {
      'sakit' => (HrdTheme.purpleBadgeBg, HrdTheme.purpleBadgeText, 'Sakit'),
      'cuti' => (HrdTheme.blueBadgeBg, HrdTheme.blueBadgeText, 'Cuti'),
      'lembur' => (HrdTheme.orangeBadgeBg, HrdTheme.orangeBadgeText, 'Lembur'),
      _ => (HrdTheme.greenBadgeBg, HrdTheme.greenBadgeText, 'Izin'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _calculateDuration(Map<String, dynamic> item) {
    final type = item['type']?.toString();
    if (type == 'lembur') {
      final start = item['start_time']?.toString() ?? '';
      final end = item['end_time']?.toString() ?? '';
      if (start.isNotEmpty && end.isNotEmpty) {
        return '$start–$end (4 jam)';
      }
      return '4 jam';
    }
    final startDate = DateTime.tryParse(item['start_date']?.toString() ?? '');
    final endDate = DateTime.tryParse(item['end_date']?.toString() ?? '');
    if (startDate != null && endDate != null) {
      final days = endDate.difference(startDate).inDays + 1;
      return '$days hari';
    }
    return '1 hari';
  }

  String _approvalDate(dynamic value) {
    final date = DateTime.tryParse(value?.toString() ?? '');
    if (date == null) return '';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

