import 'package:flutter/material.dart';

import '../../services/api_service.dart';

class HrdReportPanel extends StatefulWidget {
  const HrdReportPanel({
    super.key,
    required this.api,
    required this.dashboard,
  });

  final ApiService api;
  final Map<String, dynamic> dashboard;

  @override
  State<HrdReportPanel> createState() => _HrdReportPanelState();
}

class _HrdReportPanelState extends State<HrdReportPanel> {
  late Map<String, dynamic> _dashboard;
  late DateTime _month;
  late DateTime _selectedDate;
  bool _loading = false;
  bool _hasCustomFilters = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _dashboard = widget.dashboard;
    final selectedMonth = DateTime.tryParse(
      '${widget.dashboard['month'] ?? _currentMonthKey()}-01',
    );
    _month = selectedMonth ?? DateTime.now();
    _selectedDate =
        DateTime.tryParse(
          widget.dashboard['status_date']?.toString() ??
              widget.dashboard['date']?.toString() ??
              '',
        ) ??
        DateTime.now();
  }

  String get _monthKey =>
      '${_month.year}-${_month.month.toString().padLeft(2, '0')}';
  String get _dateKey =>
      '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';

  Future<void> _loadReport() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final dashboard = await widget.api.hrdDashboard(
        month: _monthKey,
        date: _dateKey,
      );
      if (mounted) setState(() => _dashboard = dashboard);
    } catch (error) {
      if (mounted) setState(() => _error = ApiService.errorMessage(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _chooseMonth() async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _month,
      firstDate: DateTime(2015),
      lastDate: DateTime(now.year, now.month, now.day),
      helpText: 'Pilih periode laporan',
    );
    if (selectedDate == null) return;

    final selectedMonth = DateTime(selectedDate.year, selectedDate.month);
    if (selectedMonth.year == _month.year &&
        selectedMonth.month == _month.month) {
      return;
    }

    final today = DateTime.now();
    final firstOfMonth = DateTime(selectedMonth.year, selectedMonth.month);
    final monthEnd = DateTime(selectedMonth.year, selectedMonth.month + 1, 0);
    final latestDate = monthEnd.isAfter(today) ? today : monthEnd;
    _selectedDate = firstOfMonth.isAfter(latestDate)
        ? latestDate
        : firstOfMonth;
    setState(() {
      _month = selectedMonth;
      _hasCustomFilters = true;
    });
    await _loadReport();
  }

  Future<void> _chooseDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(_month.year, _month.month);
    final monthEnd = DateTime(_month.year, _month.month + 1, 0);
    final lastDate = monthEnd.isAfter(now) ? now : monthEnd;
    final initialDate = _selectedDate.isBefore(firstDate)
        ? firstDate
        : _selectedDate.isAfter(lastDate)
        ? lastDate
        : _selectedDate;
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Pilih tanggal laporan',
    );
    if (selectedDate == null) return;
    setState(() {
      _selectedDate = selectedDate;
      _hasCustomFilters = true;
    });
    await _loadReport();
  }

  @override
  void didUpdateWidget(covariant HrdReportPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_hasCustomFilters &&
        oldWidget.dashboard != widget.dashboard &&
        widget.dashboard['month'] == _monthKey) {
      _dashboard = widget.dashboard;
      _selectedDate =
          DateTime.tryParse(
            widget.dashboard['status_date']?.toString() ??
                widget.dashboard['date']?.toString() ??
                '',
          ) ??
          _selectedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final summary = _dashboard['summary'] is Map
        ? Map<String, dynamic>.from(_dashboard['summary'] as Map)
        : <String, dynamic>{};
    final weeklyAttendance = _dashboard['weekly_attendance'] is List
        ? (_dashboard['weekly_attendance'] as List)
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList()
        : <Map<String, dynamic>>[];
    final employees = _dashboard['employee_statuses'] is List
        ? (_dashboard['employee_statuses'] as List)
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList()
        : <Map<String, dynamic>>[];
    final maxAttendance = weeklyAttendance.fold<int>(
      0,
      (maximum, week) => _count(week['count']) > maximum
          ? _count(week['count'])
          : maximum,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Text(
          'Laporan Kehadiran',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const Text(
          'Rekap seluruh karyawan',
          style: TextStyle(color: Color(0xFF7C8798)),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ReportFilter(
                label: 'Tanggal',
                value: _reportDateLabel(_selectedDate),
                onTap: _loading ? null : _chooseDate,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ReportFilter(
                label: 'Bulan',
                value: _reportMonthLabel(_month),
                onTap: _loading ? null : _chooseMonth,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ReportFilter(
                label: 'Divisi',
                value: 'Semua',
              ),
            ),
          ],
        ),
        if (_error != null) ...[
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.error_outline, color: Colors.red),
              title: Text(_error!),
            ),
          ),
        ],
        const SizedBox(height: 12),
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ringkasan ${_reportMonthLabel(_month)}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 130,
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : weeklyAttendance.isEmpty
                      ? const Center(
                          child: Text('Belum ada data presensi pada periode ini.'),
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: weeklyAttendance.map((week) {
                            final count = _count(week['count']);
                            final height = maxAttendance == 0
                                ? 8.0
                                : (count / maxAttendance * 88).clamp(
                                    8.0,
                                    88.0,
                                  );
                            return Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '$count',
                                    style: const TextStyle(
                                      color: Color(0xFF667085),
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    height: height,
                                    width: 24,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2862E9),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    week['week']?.toString() ?? '',
                                    style: const TextStyle(
                                      color: Color(0xFF667085),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 14,
                  runSpacing: 8,
                  children: [
                    _ReportLegend(
                      color: const Color(0xFF2862E9),
                      label:
                          'Presensi tercatat · ${_count(summary['monthly_attendance_count'])}',
                    ),
                    _ReportLegend(
                      color: const Color(0xFFF28A00),
                      label:
                          'Pengajuan masuk · ${_count(summary['monthly_request_count'])}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Status ${_reportDateLabel(_selectedDate)}',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: 8),
        if (_loading && employees.isEmpty)
          const Center(child: CircularProgressIndicator())
        else if (employees.isEmpty)
          const Card(
            child: ListTile(title: Text('Belum ada karyawan aktif.')),
          )
        else
          ...employees.map((employee) => _EmployeeStatusCard(employee: employee)),
      ],
    );
  }
}

class _ReportFilter extends StatelessWidget {
  const _ReportFilter({
    required this.label,
    required this.value,
    this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Card(
    color: Colors.white,
    margin: EdgeInsets.zero,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Color(0xFF7C8798), fontSize: 11),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                if (onTap != null)
                  const Icon(Icons.keyboard_arrow_down, size: 18),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _ReportLegend extends StatelessWidget {
  const _ReportLegend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
      ),
      const SizedBox(width: 5),
      Text(
        label,
        style: const TextStyle(color: Color(0xFF667085), fontSize: 11),
      ),
    ],
  );
}

class _EmployeeStatusCard extends StatelessWidget {
  const _EmployeeStatusCard({required this.employee});

  final Map<String, dynamic> employee;

  @override
  Widget build(BuildContext context) {
    final name = employee['name']?.toString() ?? 'Karyawan';
    final status = employee['status']?.toString() ?? 'alpa';
    final presentation = switch (status) {
      'hadir' => ('Hadir', const Color(0xFFDDF5E8), const Color(0xFF18734A)),
      'cuti' => ('Cuti', const Color(0xFFE0EDFF), const Color(0xFF2460D9)),
      'sakit' => ('Sakit', const Color(0xFFF0E2FA), const Color(0xFF7B3FB4)),
      'izin' => ('Izin', const Color(0xFFFFE9CF), const Color(0xFFB05A00)),
      _ => ('Belum hadir', const Color(0xFFFFE4E1), const Color(0xFFB42318)),
    };
    final subtitle = [
      employee['email']?.toString() ?? '',
      if (status == 'hadir' && employee['jam_masuk'] != null)
        'Masuk ${employee['jam_masuk']}',
    ].where((part) => part.isNotEmpty).join(' · ');

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE0EDFF),
          foregroundColor: const Color(0xFF2460D9),
          child: Text(name.isEmpty ? '?' : name[0].toUpperCase()),
        ),
        title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 11),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: presentation.$2,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            presentation.$1,
            style: TextStyle(
              color: presentation.$3,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

String _currentMonthKey() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}';
}

String _reportMonthLabel(DateTime date) =>
    '${_monthName(date.month)} ${date.year}';

String _reportDateLabel(DateTime date) =>
    '${date.day} ${_monthName(date.month)}';

int _count(dynamic value) => value is num ? value.toInt() : 0;

String _monthName(int month) => const [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
][month - 1];

