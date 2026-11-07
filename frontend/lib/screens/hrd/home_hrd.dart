import 'package:flutter/material.dart';

import 'hrd_common_widgets.dart';

class HrdHomePanel extends StatelessWidget {
  const HrdHomePanel({
    super.key,
    required this.profile,
    required this.dashboard,
    required this.onRefresh,
    required this.onSeeRequests,
  });

  final Map<String, dynamic> profile;
  final Map<String, dynamic> dashboard;
  final Future<void> Function() onRefresh;
  final VoidCallback onSeeRequests;

  @override
  Widget build(BuildContext context) {
    final summary = dashboard['summary'] is Map
        ? Map<String, dynamic>.from(dashboard['summary'] as Map)
        : <String, dynamic>{};
    final notifications = dashboard['notifications'] is List
        ? (dashboard['notifications'] as List)
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList()
        : <Map<String, dynamic>>[];
    final employees = _count(summary['employee_count']);
    final present = _count(summary['present_count']);
    final rate = employees == 0 ? 0.0 : (present / employees).clamp(0.0, 1.0);
    final now = DateTime.now();

    return RefreshIndicator(
      onRefresh: onRefresh,
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
                      '${_greeting(now.hour)}, ${profile['name'] ?? 'HRD'}',
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
                      profile['division']?.toString() ?? 'Divisi SDM',
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
          const SizedBox(height: 10),

          // Cyan Date
          Text(
            _formattedDate(now),
            style: const TextStyle(
              color: HrdTheme.cyanDate,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),

          // Main Attendance Summary Card
          _AttendanceSummaryCard(
            employeeCount: employees,
            presentCount: present,
            rate: rate,
          ),
          const SizedBox(height: 12),

          // 3 Metric Cards: Cuti, Sakit, Menunggu
          Row(
            children: [
              _MetricCard(
                label: 'Cuti',
                count: _count(summary['active_cuti_count']),
                color: const Color(0xFF2855D9),
              ),
              const SizedBox(width: 8),
              _MetricCard(
                label: 'Sakit',
                count: _count(summary['active_sakit_count']),
                color: const Color(0xFF761ACB),
              ),
              const SizedBox(width: 8),
              _MetricCard(
                label: 'Menunggu',
                count: _count(summary['pending_request_count']),
                color: const Color(0xFFF28A00),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Notification Section Header
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Notifikasi terbaru',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: HrdTheme.textDark,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onSeeRequests,
                child: const Text(
                  'Lihat semua',
                  style: TextStyle(
                    color: HrdTheme.primaryBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Notifications List
          if (notifications.isEmpty)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: HrdTheme.cardShadow,
              ),
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Belum ada notifikasi pengajuan.',
                style: TextStyle(color: Color(0xFF667085), fontSize: 13),
              ),
            )
          else
            ...notifications.map(
              (item) => _NotificationCard(item: item, onTap: onSeeRequests),
            ),
        ],
      ),
    );
  }
}

class _AttendanceSummaryCard extends StatelessWidget {
  const _AttendanceSummaryCard({
    required this.employeeCount,
    required this.presentCount,
    required this.rate,
  });

  final int employeeCount;
  final int presentCount;
  final double rate;

  @override
  Widget build(BuildContext context) {
    final percentage = (rate * 100).round();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: HrdTheme.cardShadow,
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Total karyawan',
                  style: TextStyle(fontSize: 13, color: HrdTheme.textDark),
                ),
              ),
              Text(
                'Hadir hari ini',
                style: TextStyle(fontSize: 13, color: HrdTheme.textDark),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  '$employeeCount',
                  style: const TextStyle(
                    height: 1.05,
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: HrdTheme.textDark,
                  ),
                ),
              ),
              Text(
                '$presentCount',
                style: const TextStyle(
                  height: 1.05,
                  color: HrdTheme.greenPresent,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: rate,
              minHeight: 9,
              backgroundColor: const Color(0xFF8E9299),
              color: const Color(0xFF254EEB),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$percentage% karyawan sudah hadir',
            style: const TextStyle(fontSize: 12, color: Color(0xFF6D7077)),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: HrdTheme.cardShadow,
        ),
        padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: HrdTheme.textDark,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '$count',
              style: const TextStyle(
                fontSize: 30,
                height: 1.05,
                fontWeight: FontWeight.w700,
                color: HrdTheme.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item, required this.onTap});

  final Map<String, dynamic> item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final user = item['user'];
    final name = user is Map
        ? user['name']?.toString() ?? 'Karyawan'
        : 'Karyawan';
    final type = switch (item['type']?.toString()) {
      'cuti' => 'cuti',
      'izin' => 'izin',
      'sakit' => 'izin sakit',
      'lembur' => 'lembur',
      _ => 'pengajuan',
    };
    final status = item['status']?.toString() ?? 'pending';
    final message = status == 'pending'
        ? '$name mengajukan $type'
        : 'Pengajuan $type dari $name ${status == 'approved' ? 'disetujui' : 'ditolak'}';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: HrdTheme.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 12, color: Color(0xFF2860E8)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: HrdTheme.textDark,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _timeAgo(item['created_at']),
                  style: const TextStyle(
                    fontSize: 11,
                    color: HrdTheme.textLightGrey,
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

int _count(dynamic value) => value is num ? value.toInt() : 0;

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

String _timeAgo(dynamic value) {
  final createdAt = DateTime.tryParse(value?.toString() ?? '');
  if (createdAt == null) return 'Baru';
  final difference = DateTime.now().difference(createdAt);
  if (difference.isNegative || difference.inMinutes < 1) return 'Baru saja';
  if (difference.inMinutes < 60) return '${difference.inMinutes} mnt';
  if (difference.inHours < 24) return '${difference.inHours} jam';
  if (difference.inDays < 7) return '${difference.inDays} hari';
  return '${(difference.inDays / 7).floor()} mgg';
}
