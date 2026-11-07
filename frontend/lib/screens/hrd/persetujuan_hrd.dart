import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import 'detail_pengajuan_screen.dart';
import 'hrd_common_widgets.dart';

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

  void _openDetailScreen(Map<String, dynamic> item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DetailPengajuanScreen(
          item: item,
          onDecide: (status, note) async {
            await _decide(item, status, note);
          },
        ),
      ),
    );
  }

  Future<void> _showQuickDecisionDialog(
    Map<String, dynamic> item,
    String requestedDecision,
  ) async {
    final noteController = TextEditingController();
    final isApproved = requestedDecision == 'approved';

    final decision = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            isApproved ? 'Setujui pengajuan?' : 'Tolak pengajuan?',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Apakah Anda yakin ingin ${isApproved ? "menyetujui" : "menolak"} pengajuan ini?',
                style: const TextStyle(color: HrdTheme.textGrey, fontSize: 13),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: noteController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Catatan HRD (opsional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, requestedDecision),
              style: FilledButton.styleFrom(
                backgroundColor: isApproved ? HrdTheme.primaryBlue : Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(isApproved ? 'Setujui' : 'Tolak'),
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
      color: HrdTheme.primaryBlue,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          // Top LookIn Logo & Avatar
          const HrdTopBar(showAvatar: true),
          const SizedBox(height: 12),

          // Title & Count
          const Text(
            'Persetujuan',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: HrdTheme.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${pending.length} pengajuan menunggu',
            style: const TextStyle(
              fontSize: 13,
              color: HrdTheme.textGrey,
            ),
          ),
          const SizedBox(height: 12),

          // 4-step progress indicator
          const HrdStepIndicator(activeStep: 0, totalSteps: 4),
          const SizedBox(height: 16),

          // State handlers
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(40),
              child: Center(
                child: CircularProgressIndicator(color: HrdTheme.primaryBlue),
              ),
            )
          else if (_error != null)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: HrdTheme.cardShadow,
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(_error!, style: const TextStyle(fontSize: 13)),
                  ),
                  IconButton(
                    onPressed: _load,
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            )
          else if (pending.isEmpty)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: HrdTheme.cardShadow,
              ),
              padding: const EdgeInsets.all(24),
              child: const Center(
                child: Text(
                  'Tidak ada pengajuan yang menunggu persetujuan.',
                  style: TextStyle(color: HrdTheme.textGrey, fontSize: 13),
                ),
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
    final division = user is Map
        ? user['division']?.toString() ??
            (item['division']?.toString() ?? 'Desain')
        : 'Desain';
    final type = item['type']?.toString() ?? '';
    final start = _approvalDate(item['start_date']);
    final end = _approvalDate(item['end_date']);
    final dateRange = end.isEmpty || end == start ? start : '$start–$end';
    final duration = _calculateDuration(item);
    final reason = item['reason']?.toString() ?? '';
    final id = item['id']?.toString();
    final isSaving = id != null && id == _savingId;

    final hasDocument = type == 'sakit' || type == 'lembur';
    final documentName = type == 'sakit'
        ? 'surat_dokter.pdf'
        : type == 'lembur'
        ? 'surat_perintah_lembur.pdf'
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: HrdTheme.cardShadow,
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Avatar, Name, Department, Type Badge
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFDCE8FF),
                child: Text(
                  name.isEmpty ? '?' : name[0].toUpperCase(),
                  style: const TextStyle(
                    color: HrdTheme.primaryBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: HrdTheme.textDark,
                      ),
                    ),
                    Text(
                      division,
                      style: const TextStyle(
                        color: HrdTheme.textGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              _buildBadge(type),
            ],
          ),
          const SizedBox(height: 10),

          // Date Range & Duration
          Text(
            '$dateRange · $duration',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: HrdTheme.textDark,
            ),
          ),
          const SizedBox(height: 4),

          // Reason
          Text(
            reason,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF4B5563), fontSize: 13),
          ),
          const SizedBox(height: 8),

          // Document line
          Row(
            children: [
              Icon(
                Icons.description_outlined,
                size: 16,
                color: hasDocument
                    ? HrdTheme.primaryBlue
                    : const Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 6),
              Text(
                hasDocument ? documentName! : 'Tanpa dokumen',
                style: TextStyle(
                  fontSize: 12,
                  color: hasDocument
                      ? HrdTheme.primaryBlue
                      : const Color(0xFF9CA3AF),
                  fontWeight:
                      hasDocument ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 3 Action Buttons: Detail, Tolak, Setujui
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: OutlinedButton(
                    onPressed: isSaving ? null : () => _openDetailScreen(item),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: HrdTheme.primaryBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Detail',
                      style: TextStyle(
                        color: HrdTheme.primaryBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: OutlinedButton(
                    onPressed: isSaving
                        ? null
                        : () => _showQuickDecisionDialog(item, 'rejected'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: HrdTheme.redBorder,
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Tolak',
                      style: TextStyle(
                        color: HrdTheme.redBorder,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: FilledButton(
                    onPressed: isSaving
                        ? null
                        : () => _showQuickDecisionDialog(item, 'approved'),
                    style: FilledButton.styleFrom(
                      backgroundColor: HrdTheme.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Setujui',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _calculateDuration(Map<String, dynamic> item) {
    final type = item['type']?.toString();
    if (type == 'lembur') {
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
