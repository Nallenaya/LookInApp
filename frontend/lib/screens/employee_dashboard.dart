import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import 'dashboard_components.dart';
import 'hrd/hrd_common_widgets.dart';
import 'karyawan/home_karyawan.dart';
import 'karyawan/kebijakan_privasi_karyawan.dart';
import 'karyawan/my_profile_karyawan.dart';
import 'karyawan/pengajuan_karyawan.dart';
import 'karyawan/profile_karyawan.dart';
import 'karyawan/riwayat_karyawan.dart';
import 'karyawan/settings_karyawan.dart';
import 'karyawan/syarat_ketentuan_karyawan.dart';

export 'karyawan/home_karyawan.dart';
export 'karyawan/riwayat_karyawan.dart';
export 'karyawan/pengajuan_karyawan.dart';
export 'karyawan/profile_karyawan.dart';
export 'karyawan/my_profile_karyawan.dart';
export 'karyawan/settings_karyawan.dart';
export 'karyawan/syarat_ketentuan_karyawan.dart';
export 'karyawan/kebijakan_privasi_karyawan.dart';

class EmployeeDashboard extends StatefulWidget {
  const EmployeeDashboard({super.key, this.api});

  final ApiService? api;

  @override
  State<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  static const _titles = ['Home', 'Riwayat', 'Pengajuan', 'Profil'];

  late final ApiService _api;
  int _selectedIndex = 0;
  String _requestType = 'cuti';
  int _requestLaunchId = 0;
  bool _editingProfile = false;

  @override
  void initState() {
    super.initState();
    _api = widget.api ?? context.read<AuthProvider>().api;
  }

  void _openRequest(String type) {
    setState(() {
      _requestType = type;
      _requestLaunchId++;
      _selectedIndex = 2;
    });
  }

  Future<void> _logout() async {
    await context.read<AuthProvider>().logout();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      EmployeeHomePanel(api: _api, onRequest: _openRequest),
      EmployeeHistoryPanel(api: _api),
      EmployeeRequestsPanel(
        key: const ValueKey('employee-requests'),
        api: _api,
        initialRequestType: _requestType,
        requestLaunchId: _requestLaunchId,
      ),
      _editingProfile
          ? ProfilePanel(
              key: const ValueKey('employee-profile-editor'),
              api: _api,
            )
          : EmployeeProfilePanel(
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
