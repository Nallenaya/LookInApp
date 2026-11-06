import 'package:flutter/material.dart';

import '../../services/api_service.dart';

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
    end: DateTime.now(),
  );
  String _type = 'cuti';
  Map<String, dynamic> _profile = {};
  List<Map<String, dynamic>> _requests = [];
  bool _loading = true;
  bool _submitting = false;
  String? _error;

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
    final latestRequest = _requests.isEmpty ? null : _requests.first;
    return ListView(
      padding: const EdgeInsets.fromLTRB(17, 14, 17, 24),
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 29,
                color: Colors.blueGrey.shade800,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat pagi, ${_profile['name'] ?? 'Karyawan'}',
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
        const SizedBox(height: 27),
        const Text(
          'Buat Pengajuan',
          style: TextStyle(
            color: Color(0xFF151D2D),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 15, 16, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE0E5EB)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _RequestFieldLabel('Jenis Pengajuan'),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _type,
                  decoration: _requestInputDecoration(),
                  items: const [
                    DropdownMenuItem(
                      value: 'cuti',
                      child: Text('Cuti Tahunan'),
                    ),
                    DropdownMenuItem(value: 'izin', child: Text('Izin')),
                    DropdownMenuItem(value: 'sakit', child: Text('Izin Sakit')),
                    DropdownMenuItem(value: 'lembur', child: Text('Lembur')),
                  ],
                  onChanged: _submitting
                      ? null
                      : (value) => setState(() => _type = value ?? 'cuti'),
                ),
                const SizedBox(height: 13),
                const _RequestFieldLabel('Rentang Tanggal'),
                const SizedBox(height: 6),
                InkWell(
                  onTap: _submitting ? null : _chooseDateRange,
                  borderRadius: BorderRadius.circular(8),
                  child: InputDecorator(
                    decoration: _requestInputDecoration(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${_displayDate(_dateRange.start)} - ${_displayDate(_dateRange.end)}',
                            style: const TextStyle(
                              color: Color(0xFF293548),
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                          color: Color(0xFF697789),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                const _RequestFieldLabel('Keterangan / Alasan'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _reason,
                  minLines: 3,
                  maxLines: 4,
                  decoration: _requestInputDecoration(
                    hintText: 'Tuliskan keterangan atau alasan...',
                    alignLabelWithHint: true,
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                       ? 'Alasan harus diisi.'
                      : null,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _load,
                      child: const Text('Coba lagi'),
                    ),
                  ),
                ],
                const SizedBox(height: 13),
                SizedBox(
                  height: 44,
                  child: FilledButton(
                    onPressed: _submitting ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF2862E9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: _submitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Kirim Pengajuan',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          'Status Terakhir',
          style: TextStyle(
            color: Color(0xFF151D2D),
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        if (_loading && latestRequest == null)
          const Center(child: CircularProgressIndicator())
        else if (latestRequest != null)
          _EmployeeLatestRequestCard(request: latestRequest)
        else
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE0E5EB)),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Text(
              'Belum ada pengajuan.',
              style: TextStyle(color: Color(0xFF778397), fontSize: 13),
            ),
          ),
      ],
    );
  }
}

class _RequestFieldLabel extends StatelessWidget {
  const _RequestFieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: const TextStyle(
      color: Color(0xFF3B4659),
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
  );
}

class _EmployeeLatestRequestCard extends StatelessWidget {
  const _EmployeeLatestRequestCard({required this.request});

  final Map<String, dynamic> request;

  @override
  Widget build(BuildContext context) {
    final status = request['status']?.toString() ?? 'pending';
    final statusColor = switch (status) {
      'approved' => const Color(0xFF08765B),
      'rejected' => const Color(0xFFB42318),
      _ => const Color(0xFF9A6700),
    };
    final statusBackground = switch (status) {
      'approved' => const Color(0xFFD4F7E8),
      'rejected' => const Color(0xFFFFE4E1),
      _ => const Color(0xFFFFF1CC),
    };
    final startDate = request['start_date']?.toString() ?? '-';
    final endDate = request['end_date']?.toString();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E5EB)),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _requestTypeLabel(request['type']?.toString() ?? ''),
                  style: const TextStyle(
                    color: Color(0xFF293548),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  endDate == null || endDate == startDate
                      ? startDate
                      : '$startDate - $endDate',
                  style: const TextStyle(
                    color: Color(0xFF8792A2),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
            decoration: BoxDecoration(
              color: statusBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _requestStatusLabel(status),
              style: TextStyle(
                color: statusColor,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration _requestInputDecoration({
  String? hintText,
  bool alignLabelWithHint = false,
}) => InputDecoration(
  hintText: hintText,
  alignLabelWithHint: alignLabelWithHint,
  filled: true,
  fillColor: const Color(0xFFF9FAFB),
  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Color(0xFFD7DDE5)),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Color(0xFFD7DDE5)),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Color(0xFF2862E9)),
  ),
);

String _requestTypeLabel(String type) => switch (type) {
  'cuti' => 'Cuti Tahunan',
  'izin' => 'Izin',
  'sakit' => 'Izin Sakit',
  'lembur' => 'Lembur',
  _ => 'Pengajuan',
};

String _requestStatusLabel(String status) => switch (status) {
  'approved' => 'Disetujui',
  'rejected' => 'Ditolak',
  _ => 'Menunggu',
};

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

