import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import 'dashboard_components.dart';
import 'hrd/home_hrd.dart';
import 'hrd/hrd_common_widgets.dart';
import 'hrd/laporan_hrd.dart';
import 'hrd/persetujuan_hrd.dart';
import 'hrd/profile_hrd.dart';

export 'hrd/home_hrd.dart';
export 'hrd/laporan_hrd.dart';
export 'hrd/persetujuan_hrd.dart';
export 'hrd/profile_hrd.dart';
export 'hrd/detail_pengajuan_screen.dart';
export 'hrd/my_profile_hrd.dart';
export 'hrd/settings_hrd.dart';
export 'hrd/syarat_ketentuan_hrd.dart';
export 'hrd/kebijakan_privasi_hrd.dart';

class HrdDashboard extends StatefulWidget {
  const HrdDashboard({super.key, this.api});

  final ApiService? api;

  @override
  State<HrdDashboard> createState() => _HrdDashboardState();
}

class _HrdDashboardState extends State<HrdDashboard> {
  static const _titles = ['Home', 'Persetujuan', 'Laporan', 'Profil'];

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
      return const Center(
        child: CircularProgressIndicator(color: HrdTheme.primaryBlue),
      );
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
                style: FilledButton.styleFrom(
                  backgroundColor: HrdTheme.primaryBlue,
                ),
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
      backgroundColor: HrdTheme.scaffoldBg,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: IndexedStack(index: _selectedIndex, children: pages),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(_titles.length, (index) {
                    final isSelected = _selectedIndex == index;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                          if (index != 3) _editingProfile = false;
                        });
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: Text(
                          _titles[index],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? HrdTheme.primaryBlue
                                : const Color(0xFF8C95A6),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              // iOS-style home indicator bar
              Container(
                width: 134,
                height: 4.5,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
