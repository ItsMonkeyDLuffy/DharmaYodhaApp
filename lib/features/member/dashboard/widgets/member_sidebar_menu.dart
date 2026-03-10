import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/constants/colors.dart';

class MemberSidebarMenu extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onLogout; // ✅ Added the callback property

  const MemberSidebarMenu({
    super.key,
    required this.userData,
    required this.onLogout, // ✅ Required in constructor
  });

  @override
  Widget build(BuildContext context) {
    final name = userData['personal_details']?['name'] ?? 'Member';
    final memberId = userData['member_id'] ?? 'PENDING';

    return Drawer(
      child: Column(
        children: [
          // 1. Sidebar Header with User Info
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            accountName: Text(
              name,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            accountEmail: Text(
              "ID: $memberId",
              style: GoogleFonts.spaceMono(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: AppColors.primary, size: 40),
            ),
          ),

          // 2. Menu Navigation Items
          ListTile(
            leading: const Icon(Icons.person_outline_rounded),
            title: Text('My Profile', style: GoogleFonts.poppins()),
            onTap: () {
              Navigator.pop(context); // Close drawer
              // TODO: Navigate to Profile Screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long_rounded),
            title: Text('Payment History', style: GoogleFonts.poppins()),
            onTap: () {
              Navigator.pop(context); // Close drawer
              // TODO: Navigate to Receipts
            },
          ),
          ListTile(
            leading: const Icon(Icons.card_membership_rounded),
            title: Text('My Certificate', style: GoogleFonts.poppins()),
            onTap: () {
              Navigator.pop(context); // Close drawer
              // TODO: Navigate to Certificate
            },
          ),
          ListTile(
            leading: const Icon(Icons.support_agent_rounded),
            title: Text('Support & Help', style: GoogleFonts.poppins()),
            onTap: () {
              Navigator.pop(context); // Close drawer
              // TODO: Navigate to Support
            },
          ),

          const Spacer(), // Pushes everything below this to the bottom

          const Divider(),

          // 3. Logout Button at the very bottom
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            title: Text(
              'Logout',
              style: GoogleFonts.poppins(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Close the drawer safely first
              onLogout(); // ✅ Call the safe logout function!
            },
          ),
          const SizedBox(height: 20), // Bottom padding for safety
        ],
      ),
    );
  }
}
