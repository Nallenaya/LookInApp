import 'package:flutter/material.dart';

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
      child: ListView(
        padding: const EdgeInsets.fromLTRB(10, 4, 10, 24),
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 30, color: Color(0xFF17191D)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_greeting(now.hour)}, ${profile['name'] ?? 'HRD'}',
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
                      'Divisi SDM',
                      style: TextStyle(color: Color(0xFF7C8798), fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _formattedDate(now),
            style: const TextStyle(color: Color(0xFF00BCEB), fontSize: 13),
          ),
          const SizedBox(height: 3),
          _AttendanceSummaryCard(
            employeeCount: employees,
            presentCount: present,
            rate: rate,
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Notifikasi terbaru',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ),
              TextButton(
                onPressed: onSeeRequests,
                child: const Text(
                  'Lihat semua',
                  style: TextStyle(
                    color: Color(0xFF1769FF),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          if (notifications.isEmpty)
            const Card(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(14),
                child: Text(
                  'Belum ada notifikasi pengajuan.',
                  style: TextStyle(color: Color(0xFF667085), fontSize: 13),
                ),
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
  Widget build(BuildContext context) => Card(
    color: Colors.white,
    elevation: 3,
    shadowColor: Colors.black26,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Total karyawan',
                  style: TextStyle(fontSize: 13, color: Color(0xFF17191D)),
                ),
              ),
              const Text(
                'Hadir hari ini',
                style: TextStyle(fontSize: 13, color: Color(0xFF17191D)),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  '$employeeCount',
                  style: const TextStyle(
                    height: 1.05,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '$presentCount',
                style: const TextStyle(
                  height: 1.05,
                  color: Color(0xFF176522),
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: rate,
              minHeight: 10,
              backgroundColor: const Color(0xFF92949A),
              color: const Color(0xFF293FDB),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${(rate * 100).round()}% karyawan sudah hadir',
            style: const TextStyle(fontSize: 12, color: Color(0xFF6D7077)),
          ),
        ],
      ),
    ),
  );
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
  Widget build(BuildContext context) => Expanded(
    child: Card(
      color: Colors.white,
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(11, 8, 8, 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
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
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '$count',
              style: const TextStyle(
                fontSize: 30,
                height: 1.05,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ),
  );
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

    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          child: Row(
            children: [
              const Icon(Icons.circle, size: 13, color: Color(0xFF2860E8)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _timeAgo(item['created_at']),
                style: const TextStyle(fontSize: 11, color: Color(0xFF9A9DA3)),
              ),
            ],
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
