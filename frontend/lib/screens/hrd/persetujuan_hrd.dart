import 'package:flutter/material.dart';

import '../../services/api_service.dart';

class HrdApprovalsPanel extends StatefulWidget {
  const HrdApprovalsPanel({
    super.key,
    required this.api,
    required this.onChanged,
  });

  final ApiService api;
  final Future<void> Function() onChanged;

  @override
  State<HrdApprovalsPanel> createState() => _HrdApprovalsPanelState();
}

class _HrdApprovalsPanelState extends State<HrdApprovalsPanel> {
  List<Map<String, dynamic>> _requests = [];
  bool _loading = true;
  String? _error;
  String? _savingId;

  List<Map<String, dynamic>> get _pending => _requests
      .where((request) => request['status'] == 'pending')
      .toList();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final requests = await widget.api.requests();
      if (mounted) setState(() => _requests = requests);
    } catch (error) {
      if (mounted) setState(() => _error = ApiService.errorMessage(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _showDetails(
    Map<String, dynamic> item, {
    String? requestedDecision,
  }) async {
    final noteController = TextEditingController();
    final decision = await showDialog<String>(
      context: context,
      builder: (context) {
        final user = item['user'];
        final userName = user is Map
            ? user['name']?.toString() ?? 'Karyawan'
            : 'Karyawan';
        final type = item['type']?.toString() ?? '';
        final start = _approvalDate(item['start_date']);
        final end = _approvalDate(item['end_date']);
        final createdAt = DateTime.tryParse(
          item['created_at']?.toString() ?? '',
        );

        return AlertDialog(
          title: Text(
            requestedDecision == null
                ? 'Detail Pengajuan'
                : requestedDecision == 'approved'
                ? 'Setujui pengajuan?'
                : 'Tolak pengajuan?',
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    child: Text(userName.isEmpty ? '?' : userName[0]),
                  ),
                  title: Text(userName),
                  subtitle: Text(_approvalType(type)),
                ),
                const Divider(),
                _ApprovalDetailRow(
                  label: 'Tanggal',
                  value: end.isEmpty || end == start ? start : '$start – $end',
                ),
                if (type == 'lembur') ...[
                  _ApprovalDetailRow(
                    label: 'Durasi',
                    value:
                        '${item['start_time'] ?? '--:--'} – ${item['end_time'] ?? '--:--'}',
                  ),
                ],
                _ApprovalDetailRow(
                  label: 'Diajukan',
                  value: createdAt == null
                      ? '—'
                      : '${_approvalDate(createdAt.toIso8601String())}, ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}',
                ),
                _ApprovalDetailRow(
                  label: 'Alasan',
                  value: item['reason']?.toString() ?? '—',
                ),
                const SizedBox(height: 8),
                const Text(
                  'Lampiran',
                  style: TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                const Text('Tidak ada lampiran pada pengajuan ini.'),
                const SizedBox(height: 14),
                TextField(
                  controller: noteController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Catatan HRD (opsional)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
            if (requestedDecision == null) ...[
              OutlinedButton(
                onPressed: () => Navigator.pop(context, 'rejected'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Tolak'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, 'approved'),
                child: const Text('Setujui'),
              ),
            ] else
              FilledButton(
                onPressed: () =>
                    Navigator.pop(context, requestedDecision),
                style: requestedDecision == 'rejected'
                    ? FilledButton.styleFrom(backgroundColor: Colors.red)
                    : null,
                child: Text(
                  requestedDecision == 'approved' ? 'Setujui' : 'Tolak',
                ),
              ),
          ],
        );
      },
    );
    final note = noteController.text.trim();
    noteController.dispose();

    if (decision == null) return;
    await _decide(item, decision, note);
  }

  Future<void> _decide(
    Map<String, dynamic> item,
    String status,
    String note,
  ) async {
    final id = item['id']?.toString();
    if (id == null) {
      _message('ID pengajuan tidak tersedia.', isError: true);
      return;
    }
    setState(() => _savingId = id);
    try {
      final result = await widget.api.decideRequest(id, {
        'status': status,
        'reviewer_note': note,
      });
      if (!mounted) return;
      _message(result['message']?.toString() ?? 'Keputusan tersimpan.');
      await _load();
      await widget.onChanged();
    } catch (error) {
      if (mounted) _message(ApiService.errorMessage(error), isError: true);
    } finally {
      if (mounted) setState(() => _savingId = null);
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
    final pending = _pending;
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Text(
            'Persetujuan',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '${pending.length} pengajuan menunggu',
            style: const TextStyle(color: Color(0xFF7C8798)),
          ),
          const SizedBox(height: 12),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            Card(
              child: ListTile(
                leading: const Icon(Icons.error_outline, color: Colors.red),
                title: Text(_error!),
                trailing: IconButton(
                  tooltip: 'Coba lagi',
                  onPressed: _load,
                  icon: const Icon(Icons.refresh),
                ),
              ),
            )
          else if (pending.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('Tidak ada pengajuan yang menunggu persetujuan.'),
              ),
            )
          else
            ...pending.map(_requestCard),
        ],
      ),
    );
  }

  Widget _requestCard(Map<String, dynamic> item) {
    final user = item['user'];
    final name = user is Map
        ? user['name']?.toString() ?? 'Karyawan'
        : 'Karyawan';
    final email = user is Map ? user['email']?.toString() ?? '' : '';
    final type = item['type']?.toString() ?? '';
    final start = _approvalDate(item['start_date']);
    final end = _approvalDate(item['end_date']);
    final dateRange = end.isEmpty || end == start ? start : '$start – $end';
    final id = item['id']?.toString();

    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFE0EDFF),
                  foregroundColor: const Color(0xFF2460D9),
                  child: Text(name.isEmpty ? '?' : name[0].toUpperCase()),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        email,
                        style: const TextStyle(
                          color: Color(0xFF7C8798),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                _RequestTypeBadge(type: type),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '$dateRange${type == 'lembur' ? ' · ${item['start_time'] ?? ''}–${item['end_time'] ?? ''}' : ''}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              item['reason']?.toString() ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF667085), fontSize: 13),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: id != null && id == _savingId
                        ? null
                        : () => _showDetails(item),
                    child: const Text('Detail'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: id != null && id == _savingId
                        ? null
                        : () => _showDetails(
                            item,
                            requestedDecision: 'rejected',
                          ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Tolak'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: id != null && id == _savingId
                        ? null
                        : () => _showDetails(
                            item,
                            requestedDecision: 'approved',
                          ),
                    child: const Text('Setujui'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ApprovalDetailRow extends StatelessWidget {
  const _ApprovalDetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF7C8798), fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

class _RequestTypeBadge extends StatelessWidget {
  const _RequestTypeBadge({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final color = switch (type) {
      'sakit' => const Color(0xFF7B3FB4),
      'cuti' => const Color(0xFF2460D9),
      'lembur' => const Color(0xFFB05A00),
      _ => const Color(0xFF18734A),
    };
    final background = switch (type) {
      'sakit' => const Color(0xFFF0E2FA),
      'cuti' => const Color(0xFFE0EDFF),
      'lembur' => const Color(0xFFFFE9CF),
      _ => const Color(0xFFDDF5E8),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _approvalType(type),
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}

String _approvalType(String type) => switch (type) {
  'cuti' => 'Cuti',
  'izin' => 'Izin',
  'sakit' => 'Sakit',
  'lembur' => 'Lembur',
  _ => 'Pengajuan',
};

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

