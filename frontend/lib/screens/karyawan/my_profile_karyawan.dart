import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../hrd/hrd_common_widgets.dart';

class MyProfileKaryawanScreen extends StatefulWidget {
  const MyProfileKaryawanScreen({
    super.key,
    required this.api,
    this.initialProfile,
  });

  final ApiService api;
  final Map<String, dynamic>? initialProfile;

  @override
  State<MyProfileKaryawanScreen> createState() => _MyProfileKaryawanScreenState();
}

class _MyProfileKaryawanScreenState extends State<MyProfileKaryawanScreen> {
  int _selectedTab = 0; // 0: Personal, 1: Professional, 2: Documents
  Map<String, dynamic> _profile = {};
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _profile = widget.initialProfile ?? {};
    if (_profile.isEmpty) {
      _loadProfile();
    }
  }

  Future<void> _loadProfile() async {
    setState(() => _loading = true);
    try {
      final profile = await widget.api.profile();
      if (mounted) setState(() => _profile = profile);
    } catch (_) {
      // Fallback
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30, color: HrdTheme.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: HrdTheme.textDark,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(color: HrdTheme.primaryBlue),
              )
            : Column(
                children: [
                  const SizedBox(height: 12),
                  // Segmented Tab Selector
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          _tabPill(0, 'Personal'),
                          _tabPill(1, 'Professional'),
                          _tabPill(2, 'Documents'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tab Contents
                  Expanded(
                    child: IndexedStack(
                      index: _selectedTab,
                      children: [
                        _buildPersonalTab(),
                        _buildProfessionalTab(),
                        _buildDocumentsTab(),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _tabPill(int index, String label) {
    final isSelected = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? HrdTheme.primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalTab() {
    final name = _profile['name']?.toString() ?? 'Papoi Gila';
    final email = _profile['email']?.toString() ?? 'Papoi.gila123@gmail.com';
    final phone = _profile['phone']?.toString() ?? '08511311334';
    final address = _profile['address']?.toString() ?? 'Jl.Jombor no 43';

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      children: [
        _profileField('Full Name', name),
        _profileField('Email Address', email),
        _profileField('Phone Number', phone),
        _profileField('Address', address),
      ],
    );
  }

  Widget _buildProfessionalTab() {
    final employeeId = _profile['employee_id']?.toString() ?? '7879987';
    final designation = _profile['position']?.toString() ??
        _profile['designation']?.toString() ??
        'Lead UI/UX Designer';
    final companyEmail = _profile['email']?.toString() ?? 'Papoi.gila123@gmail.com';
    final employeeType = 'Permanent';
    final department = _profile['division']?.toString() ?? 'Design';
    final reportingManager = 'Robert Fox';
    final experience = '2 Year 5 Months';
    final officeTime = _profile['shift_time']?.toString() ?? '10:00 am to 07:00 pm';

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      children: [
        _profileField('Employee ID', employeeId),
        _profileField('Designation', designation),
        _profileField('Company Email Address', companyEmail),
        _profileField('Employee Type', employeeType),
        _profileField('Department', department),
        _profileField('Reporting Manager', reportingManager),
        _profileField('Company Experience', experience),
        _profileField('Office Time', officeTime),
      ],
    );
  }

  Widget _buildDocumentsTab() {
    final documents = [
      'Offer Letter',
      'Appointment Letter',
      'Bond Agreement',
      'Appraisal Letter',
      'Salary Slip',
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      children: documents.map((doc) => _documentCard(doc)).toList(),
    );
  }

  Widget _profileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: HrdTheme.textDark,
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
        ],
      ),
    );
  }

  Widget _documentCard(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF0F2F5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Icon(
            Icons.description_outlined,
            size: 22,
            color: HrdTheme.textDark,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: HrdTheme.textDark,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Mengunduh $title...')),
              );
            },
            icon: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF6B7280)),
              ),
              child: const Icon(
                Icons.arrow_downward,
                size: 16,
                color: Color(0xFF374151),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
