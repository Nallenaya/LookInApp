import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import 'dashboard_components.dart';
import 'karyawan/home_karyawan.dart';
import 'karyawan/riwayat_karyawan.dart';
import 'karyawan/pengajuan_karyawan.dart';
import 'karyawan/profile_karyawan.dart';

export 'karyawan/home_karyawan.dart';
export 'karyawan/riwayat_karyawan.dart';
export 'karyawan/pengajuan_karyawan.dart';
export 'karyawan/profile_karyawan.dart';

class EmployeeDashboard extends StatefulWidget {
  const EmployeeDashboard({super.key, this.api});

  final ApiService? api;

  @override
  State<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  static const _titles = ['Home', 'Riwayat', 'Pengajuan', 'Profil'];
  static const _icons = [
    Icons.home_outlined,
    Icons.calendar_month_outlined,
    Icons.description_outlined,
    Icons.person_outline,
  ];

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
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
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
