import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../hrd/hrd_common_widgets.dart';

class EmployeeRequestsPanel extends StatefulWidget {
  const EmployeeRequestsPanel({
    super.key,
    required this.api,
    this.initialRequestType = 'cuti',
    this.requestLaunchId = 0,
  });

  final ApiService api;
  final String initialRequestType;
  final int requestLaunchId;

  @override
  State<EmployeeRequestsPanel> createState() => _EmployeeRequestsPanelState();
}

class _EmployeeRequestsPanelState extends State<EmployeeRequestsPanel> {
  final _formKey = GlobalKey<FormState>();
  final _reason = TextEditingController();
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 2)),
  );
  String _type = 'cuti';
  Map<String, dynamic> _profile = {};
  List<Map<String, dynamic>> _requests = [];
  bool _loading = true;
  bool _submitting = false;
  String? _error;
  String? _uploadedFileName;

  static const _requestTypes = {'cuti', 'izin', 'sakit', 'lembur'};

  @override
  void initState() {
    super.initState();
    _type = _requestTypes.contains(widget.initialRequestType)
        ? widget.initialRequestType
        : 'cuti';
    _load();
  }

  @override
  void didUpdateWidget(covariant EmployeeRequestsPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.requestLaunchId != oldWidget.requestLaunchId &&
        widget.requestLaunchId > 0) {
      setState(() {
        _type = _requestTypes.contains(widget.initialRequestType)
            ? widget.initialRequestType
            : 'cuti';
      });
    }
  }

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        widget.api.profile(),
        widget.api.requests(),
      ]);
      if (!mounted) return;
      final requests = results[1] as List<Map<String, dynamic>>;
      setState(() {
        _profile = results[0] as Map<String, dynamic>;
        _requests = requests;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = ApiService.errorMessage(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _chooseDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: _dateRange,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 2, now.month, now.day),
      helpText: 'Pilih rentang tanggal',
      saveText: 'Pilih',
    );
    if (picked != null) setState(() => _dateRange = picked);
  }

  String _date(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  String _displayDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)} ${date.year}';

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      final result = await widget.api.submitRequest({
        'type': _type,
        'start_date': _date(_dateRange.start),
        'end_date': _date(_dateRange.end),
        'reason': _reason.text.trim(),
      });
      if (!mounted) return;
      _reason.clear();
      setState(() => _uploadedFileName = null);
      _message(result['message']?.toString() ?? 'Pengajuan berhasil dikirim.');
      await _load();
    } catch (error) {
      if (mounted) _message(ApiService.errorMessage(error), isError: true);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _message(String text, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = _profile['name']?.toString() ?? 'Papoi';
    final position = _profile['position']?.toString() ??
        _profile['division']?.toString() ??
        'Kepala Divisi';
    final latestRequest = _requests.isEmpty ? null : _requests.first;

    return RefreshIndicator(
      onRefresh: _load,
      color: HrdTheme.primaryBlue,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          // Top LookIn Logo
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Image.asset(
                'assets/images/lookin_logo.png',
                height: 24,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.fingerprint, color: HrdTheme.primaryBlue, size: 24),
                    SizedBox(width: 4),
                    Text(
                      'LookIn',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: HrdTheme.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // User Greeting Row
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/avatar_hrd.png',
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.person,
                      size: 32,
                      color: HrdTheme.textDark,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_greeting(DateTime.now().hour)}, $name',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: HrdTheme.primaryBlue,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      position,
                      style: const TextStyle(
                        color: HrdTheme.textGrey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Title & Leave Quota Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Buat Pengajuan',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: HrdTheme.textDark,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCE8FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Sisa Cuti: 10',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: HrdTheme.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Main Form Card matching Persetujuan.png
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: HrdTheme.cardShadow,
            ),
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Jenis Pengajuan
                  const Text(
                    'Jenis Pengajuan',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: HrdTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFD1D5DB)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _type,
                        items: const [
                          DropdownMenuItem(
                            value: 'cuti',
                            child: Text('Cuti Tahunan'),
                          ),
                          DropdownMenuItem(
                            value: 'izin',
                            child: Text('Izin'),
                          ),
                          DropdownMenuItem(
                            value: 'sakit',
                            child: Text('Sakit'),
                          ),
                          DropdownMenuItem(
                            value: 'lembur',
                            child: Text('Lembur'),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _type = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Rentang Tanggal
                  const Text(
                    'Rentang Tanggal',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: HrdTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: _chooseDateRange,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFD1D5DB)),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 13,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_displayDate(_dateRange.start)} - ${_displayDate(_dateRange.end)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: HrdTheme.textDark,
                            ),
                          ),
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 18,
                            color: Color(0xFF6B7280),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Keterangan / Alasan
                  const Text(
                    'Keterangan / Alasan',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: HrdTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _reason,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Tuliskan keterangan atau alasan...',
                      hintStyle: const TextStyle(
                        color: Color(0xFF9CA3AF),
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
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Keterangan atau alasan harus diisi.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Lampiran (Opsional)
                  const Text(
                    'Lampiran (Opsional)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: HrdTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _uploadedFileName = 'surat_keterangan.pdf';
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Berkas berhasil dipilih: surat_keterangan.pdf'),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFD1D5DB),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _uploadedFileName != null
                              ? '✓ $_uploadedFileName'
                              : '+ Unggah File (.pdf, .jpg)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: _uploadedFileName != null
                                ? HrdTheme.primaryBlue
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Kirim Pengajuan Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: _submitting ? null : _submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: HrdTheme.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _submitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Kirim Pengajuan',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),

          // Status Terakhir Section
          const Text(
            'Status Terakhir',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: HrdTheme.textDark,
            ),
          ),
          const SizedBox(height: 10),

          // Latest Request Status Card
          _buildLatestStatusCard(latestRequest),
        ],
      ),
    );
  }

  Widget _buildLatestStatusCard(Map<String, dynamic>? item) {
    final type = item?['type']?.toString() ?? 'sakit';
    final title = switch (type) {
      'cuti' => 'Cuti Tahunan',
      'izin' => 'Izin',
      'sakit' => 'Izin Sakit',
      'lembur' => 'Lembur',
      _ => 'Pengajuan',
    };
    final dateStr = item != null
        ? _approvalDate(item['start_date'])
        : '15 Sep 2026';
    final status = item?['status']?.toString() ?? 'approved';

    final (badgeBg, badgeText, badgeLabel) = switch (status) {
      'approved' => (const Color(0xFFDDF5E8), const Color(0xFF18734A), 'Disetujui'),
      'rejected' => (const Color(0xFFFCE8E8), const Color(0xFFB42318), 'Ditolak'),
      _ => (const Color(0xFFFFE9CF), const Color(0xFFB05A00), 'Menunggu'),
    };

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: HrdTheme.cardShadow,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: HrdTheme.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dateStr,
                style: const TextStyle(
                  fontSize: 13,
                  color: HrdTheme.textGrey,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              badgeLabel,
              style: TextStyle(
                color: badgeText,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _approvalDate(dynamic value) {
    final date = DateTime.tryParse(value?.toString() ?? '');
    if (date == null) return '';
    return '${date.day} ${_monthName(date.month)} ${date.year}';
  }
}

String _monthName(int month) => const [
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
][month - 1];

String _greeting(int hour) {
  if (hour < 11) return 'Selamat pagi';
  if (hour < 15) return 'Selamat siang';
  if (hour < 18) return 'Selamat sore';
  return 'Selamat malam';
}
