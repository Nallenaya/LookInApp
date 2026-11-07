import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../hrd/hrd_common_widgets.dart';

class EmployeeHomePanel extends StatefulWidget {
  const EmployeeHomePanel({
    super.key,
    required this.api,
    required this.onRequest,
  });

  final ApiService api;
  final ValueChanged<String> onRequest;

  @override
  State<EmployeeHomePanel> createState() => _EmployeeHomePanelState();
}

class _EmployeeHomePanelState extends State<EmployeeHomePanel> {
  DateTime _now = DateTime.now();
  Timer? _clockTimer;
  Map<String, dynamic> _profile = {};
  Map<String, dynamic>? _todayAttendance;
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final profile = await widget.api.profile();
      final now = DateTime.now();
      final month = '${now.year}-${now.month.toString().padLeft(2, '0')}';
      final records = await widget.api.attendance(month);
      final todayKey = _dateKey(now);
      final today = records.cast<Map<String, dynamic>?>().firstWhere(
        (record) =>
            record?['tanggal']?.toString().startsWith(todayKey) ?? false,
        orElse: () => null,
      );
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _todayAttendance = today;
        _now = now;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = ApiService.errorMessage(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _record(String action) async {
    setState(() => _saving = true);
    try {
      await widget.api.recordAttendance(action);
      if (!mounted) return;
      _message(
        action == 'check-in'
            ? 'Presensi Masuk Berhasil'
            : 'Presensi Pulang Berhasil',
      );
      await _load();
    } catch (error) {
      if (mounted) _message(ApiService.errorMessage(error), isError: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _message(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
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
    final branch = _profile['branch']?.toString() ?? 'Kantor Yogyakarta';

    final attendance = _todayAttendance;
    final hasCheckedIn = attendance != null;
    final hasCheckedOut =
        attendance != null && attendance['jam_pulang'] != null;

    final inTime = hasCheckedIn
        ? _formatTimeDisplay(attendance['jam_masuk']?.toString())
        : '06:50 AM';
    final outTime = hasCheckedOut
        ? _formatTimeDisplay(attendance['jam_pulang']?.toString())
        : '--:--';

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
                      '${_greeting(_now.hour)}, $name',
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
          const SizedBox(height: 24),

          // Center Cyan Date, Big Time, and Location
          Center(
            child: Column(
              children: [
                Text(
                  _formattedDate(_now),
                  style: const TextStyle(
                    color: HrdTheme.cyanDate,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatClockTime(_now),
                  style: const TextStyle(
                    fontSize: 54,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF007AFF),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Color(0xFF4B5563),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      branch,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF4B5563),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Clock In & Clock Out Cards
          Row(
            children: [
              Expanded(
                child: _ClockActionButton(
                  icon: Icons.login,
                  iconColor: const Color(0xFF10B981),
                  iconBg: const Color(0xFFD1FAE5),
                  label: 'Clock In',
                  isLoading: _saving,
                  onTap: () => _record('check-in'),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _ClockActionButton(
                  icon: Icons.logout,
                  iconColor: const Color(0xFFEF4444),
                  iconBg: const Color(0xFFFEE2E2),
                  label: 'Clock Out',
                  isLoading: _saving,
                  onTap: () => _record('check-out'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 4 Category Icons: Cuti, Izin, Sakit, Lembur
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _CategoryItem(
                imagePath: 'assets/images/icon_cuti.png',
                fallbackIcon: Icons.work_outline,
                label: 'Cuti',
                onTap: () => widget.onRequest('cuti'),
              ),
              _CategoryItem(
                imagePath: 'assets/images/icon_izin.png',
                fallbackIcon: Icons.edit_note,
                label: 'Izin',
                onTap: () => widget.onRequest('izin'),
              ),
              _CategoryItem(
                imagePath: 'assets/images/icon_sakit.png',
                fallbackIcon: Icons.sick_outlined,
                label: 'Sakit',
                onTap: () => widget.onRequest('sakit'),
              ),
              _CategoryItem(
                imagePath: 'assets/images/icon_lembur.png',
                fallbackIcon: Icons.nights_stay_outlined,
                label: 'Lembur',
                onTap: () => widget.onRequest('lembur'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Aktivitas Hari Ini Section
          const Text(
            'Aktivitas Hari Ini',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4B5563),
            ),
          ),
          const SizedBox(height: 10),

          // Aktivitas Card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: HrdTheme.cardShadow,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD1FAE5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.login,
                        color: Color(0xFF10B981),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Jam Masuk',
                          style: TextStyle(
                            fontSize: 12,
                            color: HrdTheme.textGrey,
                          ),
                        ),
                        Text(
                          inTime,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0066FF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFEE2E2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.logout,
                        color: Color(0xFFEF4444),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Jam Pulang',
                          style: TextStyle(
                            fontSize: 12,
                            color: HrdTheme.textGrey,
                          ),
                        ),
                        Text(
                          outTime,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0066FF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClockActionButton extends StatelessWidget {
  const _ClockActionButton({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.isLoading,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: HrdTheme.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                const SizedBox(height: 10),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8B2500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    required this.imagePath,
    required this.fallbackIcon,
    required this.label,
    required this.onTap,
  });

  final String imagePath;
  final IconData fallbackIcon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: HrdTheme.cardShadow,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  fallbackIcon,
                  size: 28,
                  color: HrdTheme.textDark,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }
}

String _dateKey(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

String _greeting(int hour) {
  if (hour < 11) return 'Selamat pagi';
  if (hour < 15) return 'Selamat siang';
  if (hour < 18) return 'Selamat sore';
  return 'Selamat malam';
}

String _formattedDate(DateTime date) {
  const weekdays = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];
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
  return '${weekdays[date.weekday - 1]}, ${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
}

String _formatClockTime(DateTime time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

String _formatTimeDisplay(String? timeStr) {
  if (timeStr == null || timeStr.isEmpty) return '--:--';
  return timeStr;
}
