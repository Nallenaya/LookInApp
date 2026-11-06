import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/api_service.dart';

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
    final attendance = _todayAttendance;
    final hasCheckedIn = attendance != null;
    final hasCheckedOut =
        attendance != null && attendance['jam_pulang'] != null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 31,
                color: Colors.blueGrey.shade800,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_greeting(_now.hour)}, ${_profile['name'] ?? 'Karyawan'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF1769FF),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Karyawan',
                    style: TextStyle(color: Color(0xFF7C8798), fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 36),
        Text(
          _formattedDate(_now),
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF00BCEB), fontSize: 14),
        ),
        const SizedBox(height: 8),
        Text(
          '${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF0787F9),
            fontSize: 52,
            height: 1,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, size: 16, color: Color(0xFF667085)),
            SizedBox(width: 4),
            Text(
              'Lokasi kantor',
              style: TextStyle(color: Color(0xFF667085), fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(
              child: _AttendanceAction(
                label: 'Clock In',
                icon: Icons.login,
                color: const Color(0xFF08A84A),
                background: const Color(0xFFDDFBE8),
                enabled:
                    !_loading && _error == null && !_saving && !hasCheckedIn,
                onTap: () => _record('check-in'),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _AttendanceAction(
                label: 'Clock Out',
                icon: Icons.logout,
                color: const Color(0xFFF04444),
                background: const Color(0xFFFFE3E3),
                enabled:
                    !_loading &&
                    _error == null &&
                    !_saving &&
                    hasCheckedIn &&
                    !hasCheckedOut,
                onTap: () => _record('check-out'),
              ),
            ),
          ],
        ),
        if (_saving)
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        if (_error != null) ...[
          const SizedBox(height: 16),
          _EmployeeErrorCard(message: _error!, onRetry: _load),
        ],
        const SizedBox(height: 24),
        Row(
          children: [
            _QuickAction(
              label: 'Cuti',
              icon: Icons.work_outline,
              onTap: () => widget.onRequest('cuti'),
            ),
            _QuickAction(
              label: 'Izin',
              icon: Icons.description_outlined,
              onTap: () => widget.onRequest('izin'),
            ),
            _QuickAction(
              label: 'Sakit',
              icon: Icons.sick_outlined,
              onTap: () => widget.onRequest('sakit'),
            ),
            _QuickAction(
              label: 'Lembur',
              icon: Icons.night_shelter_outlined,
              onTap: () => widget.onRequest('lembur'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Aktivitas Hari Ini',
          style: TextStyle(color: Color(0xFF667085), fontSize: 13),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _ActivityRow(
                label: 'Jam Masuk',
                time: _formattedTime(attendance?['jam_masuk']),
                icon: Icons.login,
                color: const Color(0xFF08A84A),
                background: const Color(0xFFDDFBE8),
              ),
              const Divider(height: 20, color: Color(0xFFF0F2F5)),
              _ActivityRow(
                label: 'Jam Pulang',
                time: _formattedTime(attendance?['jam_pulang']),
                icon: Icons.logout,
                color: const Color(0xFFF04444),
                background: const Color(0xFFFFE3E3),
              ),
            ],
          ),
        ),
        if (_loading)
          const Padding(
            padding: EdgeInsets.only(top: 14),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

class _AttendanceAction extends StatelessWidget {
  const _AttendanceAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.background,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color background;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(28),
    child: InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(28),
      child: SizedBox(
        height: 126,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: enabled ? background : const Color(0xFFF0F2F5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: enabled ? color : const Color(0xFF98A2B3),
                size: 26,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: enabled ? const Color(0xFF9A4A4A) : Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            height: 64,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Center(
              child: Icon(icon, size: 34, color: const Color(0xFF15191F)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF667085), fontSize: 12),
          ),
        ],
      ),
    ),
  );
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.label,
    required this.time,
    required this.icon,
    required this.color,
    required this.background,
  });

  final String label;
  final String time;
  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 18),
      ),
      const SizedBox(width: 14),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF667085), fontSize: 12),
          ),
          const SizedBox(height: 1),
          Text(
            time,
            style: const TextStyle(
              color: Color(0xFF1769FF),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ],
  );
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

String _formattedTime(dynamic value) {
  final time = value?.toString();
  if (time == null || time.isEmpty) return '--:--';
  final parts = time.split(':');
  if (parts.length < 2) return time;
  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) return time;
  final suffix = hour >= 12 ? 'PM' : 'AM';
  final displayHour = hour % 12 == 0 ? 12 : hour % 12;
  return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $suffix';
}

String _dateKey(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

String _greeting(int hour) {
  if (hour < 11) return 'Selamat pagi';
  if (hour < 15) return 'Selamat siang';
  if (hour < 18) return 'Selamat sore';
  return 'Selamat malam';
}

class _EmployeeErrorCard extends StatelessWidget {
  const _EmployeeErrorCard({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: const Icon(Icons.error_outline, color: Colors.red),
      title: Text(message),
      trailing: IconButton(
        tooltip: 'Coba lagi',
        onPressed: onRetry,
        icon: const Icon(Icons.refresh),
      ),
    ),
  );
}

