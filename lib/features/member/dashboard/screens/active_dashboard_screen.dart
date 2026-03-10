import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/digital_id_card.dart';
import '../widgets/member_sidebar_menu.dart';
import '/core/widgets/dharma_app_bar.dart';
import '/core/enums/app_bar_type.dart';
import '/core/constants/colors.dart'; // ✅ Imported AppColors for the gradient

class ActiveDashboardScreen extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onLogout;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ActiveDashboardScreen({
    super.key,
    required this.userData,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final name = userData['personal_details']?['name'] ?? 'Member';
    final memberId = userData['member_id'] ?? 'PENDING';
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'UNKNOWN';

    // ✅ Get the screen dimensions dynamically
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      key: _scaffoldKey,
      // ✅ Removed the grey background color so the gradient shows through
      extendBodyBehindAppBar: false,

      endDrawer: MemberSidebarMenu(userData: userData, onLogout: onLogout),

      appBar: DharmaAppBar(
        type: DharmaAppBarType.dashboard,
        onPrimaryAction: () => _scaffoldKey.currentState?.openEndDrawer(),
      ),

      // ✅ Wrapped the body in a Container to apply the global background gradient
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.44, 0.88],
            colors: [
              AppColors.primary, // Top: Saffron
              Color(0xFFFFDB8E), // Mid: Bridge Color
              AppColors.primaryLight, // Bottom: Cream
            ],
          ),
        ),
        child: SingleChildScrollView(
          // ✅ Converted hardcoded 8 and 20 to dynamic screen percentages
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03,
            vertical: screenHeight * 0.025,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome back,",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white70,
                  height:
                      1.0, // ✅ Strips away the invisible padding below this line
                ),
              ),
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height:
                      1.1, // ✅ Strips away the invisible padding above this line
                ),
              ),

              // ✅ Converted 25 to dynamic height
              SizedBox(height: screenHeight * 0.02),

              // Saffron Digital ID Card
              DigitalIdCard(
                name: name,
                memberId: memberId,
                uid: uid,
                status: 'Active',
              ),

              // ✅ Converted 35 to dynamic height
              SizedBox(height: screenHeight * 0.035),

              // Quick Action Grid
              Text(
                "Quick Actions",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors
                      .black87, // Kept dark as the gradient gets lighter here
                ),
              ),

              // ✅ Converted 15 to dynamic height
              SizedBox(height: screenHeight * 0.02),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                // ✅ Converted 15 to dynamic width spacing
                crossAxisSpacing: screenWidth * 0.035,
                mainAxisSpacing: screenWidth * 0.035,
                childAspectRatio: 1.1,
                children: [
                  _buildActionCard(
                    icon: Icons.receipt_long_rounded,
                    title: "My Receipts",
                    color: Colors.blue.shade600,
                    onTap: () {},
                  ),
                  _buildActionCard(
                    icon: Icons.person_outline_rounded,
                    title: "Profile Details",
                    color: Colors.orange.shade600,
                    onTap: () {},
                  ),
                  _buildActionCard(
                    icon: Icons.card_membership_rounded,
                    title: "Certificate",
                    color: Colors.green.shade600,
                    onTap: () {},
                  ),
                  _buildActionCard(
                    icon: Icons.support_agent_rounded,
                    title: "Support",
                    color: Colors.purple.shade600,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            // ✅ Wrapped Text in FittedBox to ensure it never overflows on small screens
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
