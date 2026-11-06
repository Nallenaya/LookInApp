import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import 'dashboard_components.dart';
import 'hrd/home_hrd.dart';
import 'hrd/persetujuan_hrd.dart';
import 'hrd/laporan_hrd.dart';
import 'hrd/profile_hrd.dart';

export 'hrd/home_hrd.dart';
export 'hrd/persetujuan_hrd.dart';
export 'hrd/laporan_hrd.dart';
export 'hrd/profile_hrd.dart';

class HrdDashboard extends StatefulWidget {
  const HrdDashboard({super.key, this.api});

  final ApiService? api;

  @override
  State<HrdDashboard> createState() => _HrdDashboardState();
}

class _HrdDashboardState extends State<HrdDashboard> {
  static const _titles = ['Home', 'Persetujuan', 'Laporan', 'Profil'];
  static const _icons = [
    Icons.home_outlined,
    Icons.fact_check_outlined,
    Icons.bar_chart_outlined,
    Icons.person_outline,
  ];

  late final ApiService _api;
  int _selectedIndex = 0;
  bool _editingProfile = false;
  Map<String, dynamic> _profile = {};
  Map<String, dynamic> _dashboard = {};
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _api = widget.api ?? context.read<AuthProvider>().api;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadOverview();
    });
  }

  Future<void> _loadOverview() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await Future.wait<Map<String, dynamic>>([
        _api.profile(),
        _api.hrdDashboard(),
      ]);
      if (!mounted) return;
      setState(() {
        _profile = result[0];
        _dashboard = result[1];
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = ApiService.errorMessage(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    await context.read<AuthProvider>().logout();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
    }
  }

  Widget _overview() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _loadOverview,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      );
    }
    return HrdHomePanel(
      profile: _profile,
      dashboard: _dashboard,
      onRefresh: _loadOverview,
      onSeeRequests: () => setState(() => _selectedIndex = 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _overview(),
      HrdApprovalsPanel(api: _api, onChanged: _loadOverview),
      HrdReportPanel(api: _api, dashboard: _dashboard),
      _editingProfile
          ? ProfilePanel(
              key: const ValueKey('hrd-profile-editor'),
              api: _api,
            )
          : HrdProfilePanel(
              api: _api,
              onEdit: () => setState(() => _editingProfile = true),
              onLogout: _logout,
            ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F1F1),
        surfaceTintColor: const Color(0xFFF1F1F1),
        titleSpacing: 18,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.fingerprint, color: Color(0xFF1769FF), size: 25),
            SizedBox(width: 5),
            Text(
              'LookIn',
              style: TextStyle(
                color: Color(0xFF17191D),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        actions: [
          if (_selectedIndex == 3 && _editingProfile)
            IconButton(
              tooltip: 'Kembali ke profil',
              onPressed: () => setState(() => _editingProfile = false),
              icon: const Icon(Icons.close),
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: IndexedStack(index: _selectedIndex, children: pages),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFE7F0FF),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
            if (index != 3) _editingProfile = false;
          });
        },
        destinations: List.generate(
          _titles.length,
          (index) => NavigationDestination(
            icon: Icon(_icons[index]),
            label: _titles[index],
          ),
        ),
      ),
    );
  }
}
