import 'package:flutter/material.dart';

import '../../services/api_service.dart';

class EmployeeProfilePanel extends StatefulWidget {
  const EmployeeProfilePanel({
    super.key,
    required this.api,
    required this.onEdit,
    required this.onLogout,
  });

  final ApiService api;
  final VoidCallback onEdit;
  final VoidCallback onLogout;

  @override
  State<EmployeeProfilePanel> createState() => _EmployeeProfilePanelState();
}

class _EmployeeProfilePanelState extends State<EmployeeProfilePanel> {
  Map<String, dynamic> _profile = {};
  bool _loading = true;
  String? _error;

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
      final profile = await widget.api.profile();
      if (mounted) setState(() => _profile = profile);
    } catch (error) {
      if (mounted) setState(() => _error = ApiService.errorMessage(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    final name = _profile['name']?.toString() ?? 'Karyawan';
    final email = _profile['email']?.toString() ?? '';

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      children: [
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 57,
                backgroundColor: const Color(0xFFE7F0FF),
                child: Text(
                  name.isEmpty ? '?' : name[0].toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF1769FF),
                    fontSize: 42,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: const TextStyle(
                  color: Color(0xFF1769FF),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                email,
                style: const TextStyle(
                  color: Color(0xFF7C8798),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: 240,
                child: FilledButton(
                  onPressed: widget.onEdit,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2862E9),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  child: const Text('Edit Profil'),
                ),
              ),
            ],
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.error_outline, color: Colors.red),
            title: Text(_error!),
            trailing: IconButton(
              tooltip: 'Coba lagi',
              onPressed: _load,
              icon: const Icon(Icons.refresh),
            ),
          ),
        ],
        const SizedBox(height: 24),
        Card(
          color: Colors.white,
          child: Column(
            children: [
              ListTile(
                title: const Text('My Profile'),
                trailing: const Icon(Icons.chevron_right),
                onTap: widget.onEdit,
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('Log out'),
                trailing: const Icon(Icons.chevron_right),
                onTap: widget.onLogout,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

