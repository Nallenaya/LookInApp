import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../hrd/hrd_common_widgets.dart';
import 'kebijakan_privasi_karyawan.dart';
import 'my_profile_karyawan.dart';
import 'settings_karyawan.dart';
import 'syarat_ketentuan_karyawan.dart';

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
    try {
      final profile = await widget.api.profile();
      if (mounted) setState(() => _profile = profile);
    } catch (error) {
      if (mounted) setState(() => _error = ApiService.errorMessage(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _navigateToMyProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MyProfileKaryawanScreen(
          api: widget.api,
          initialProfile: _profile,
        ),
      ),
    ).then((_) => _load());
  }

  void _navigateToSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SettingsKaryawanScreen(
          api: widget.api,
          profile: _profile,
        ),
      ),
    ).then((_) => _load());
  }

  void _navigateToTerms() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const SyaratKetentuanKaryawanScreen(),
      ),
    );
  }

  void _navigateToPrivacy() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const KebijakanPrivasiKaryawanScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: HrdTheme.primaryBlue),
      );
    }

    final name = _profile['name']?.toString() ?? 'Papoi Gila';
    final position = _profile['position']?.toString() ??
        _profile['designation']?.toString() ??
        'Kepala Divisi';

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      children: [
        // Top LookIn Logo
        const HrdTopBar(showAvatar: false),
        const SizedBox(height: 10),

        // Profile Avatar Section
        Center(
          child: Column(
            children: [
              // Character Avatar Badge with Camera
              GestureDetector(
                onTap: _navigateToMyProfile,
                child: SizedBox(
                  width: 170,
                  height: 125,
                  child: Image.asset(
                    'assets/images/profile_avatar_badge.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: const Color(0xFFDCE8FF),
                          child: Text(
                            name.isEmpty ? '?' : name[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              color: HrdTheme.primaryBlue,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 10,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0096AA),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // User Name
              Text(
                name,
                style: const TextStyle(
                  color: HrdTheme.primaryBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),

              // User Position/Title
              Text(
                position,
                style: const TextStyle(
                  color: HrdTheme.textGrey,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),

              // Edit Profil Button
              SizedBox(
                width: 230,
                height: 44,
                child: FilledButton(
                  onPressed: _navigateToMyProfile,
                  style: FilledButton.styleFrom(
                    backgroundColor: HrdTheme.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Edit Profil',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        if (_error != null) ...[
          const SizedBox(height: 14),
          ListTile(
            leading: const Icon(Icons.error_outline, color: Colors.red),
            title: Text(_error!),
            trailing: IconButton(
              onPressed: _load,
              icon: const Icon(Icons.refresh),
            ),
          ),
        ],
        const SizedBox(height: 24),

        // Navigation Menu List matching profil.png
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: HrdTheme.cardShadow,
          ),
          child: Column(
            children: [
              _menuTile(
                title: 'My Profile',
                onTap: _navigateToMyProfile,
              ),
              const Divider(height: 1, color: Color(0xFFF3F4F6)),
              _menuTile(
                title: 'Settings',
                onTap: _navigateToSettings,
              ),
              const Divider(height: 1, color: Color(0xFFF3F4F6)),
              _menuTile(
                title: 'Syarat & Ketentuan',
                onTap: _navigateToTerms,
              ),
              const Divider(height: 1, color: Color(0xFFF3F4F6)),
              _menuTile(
                title: 'Kebijakan Privasi',
                onTap: _navigateToPrivacy,
              ),
              const Divider(height: 1, color: Color(0xFFF3F4F6)),
              _menuTile(
                title: 'Log out',
                onTap: widget.onLogout,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _menuTile({
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: HrdTheme.textDark,
                ),
              ),
              const Text(
                '>',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: HrdTheme.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
