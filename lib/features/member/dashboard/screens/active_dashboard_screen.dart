import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/digital_id_card.dart';
import '../widgets/member_sidebar_menu.dart';
import '/core/widgets/dharma_app_bar.dart';
import '/core/enums/app_bar_type.dart';
import '/core/constants/colors.dart';

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

    // ✅ Dynamic Time Greeting Logic
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = "Good morning,";
    } else if (hour < 17) {
      greeting = "Good afternoon,";
    } else {
      greeting = "Good evening,";
    }

    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    // ✅ Updated brand color for the icons
    final Color brandColor = const Color(0xFFFF9641);

    // ✅ The "Frosted Glass" colors
    final Color translucentCardColor = Colors.white.withOpacity(0.45);
    final Color subtleBorderColor = Colors.white.withOpacity(0.60);

    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: false,
      endDrawer: MemberSidebarMenu(userData: userData, onLogout: onLogout),
      appBar: DharmaAppBar(
        type: DharmaAppBarType.dashboard,
        onPrimaryAction: () => _scaffoldKey.currentState?.openEndDrawer(),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.44, 0.88],
            colors: [
              AppColors.primary,
              Color(0xFFFFDB8E),
              AppColors.primaryLight,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.025,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: GoogleFonts.anekDevanagari(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                style: GoogleFonts.anekDevanagari(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: Colors.white,
                  height: 1.1,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              DigitalIdCard(
                name: name,
                memberId: memberId,
                uid: uid,
                status: 'Active',
              ),

              SizedBox(height: screenHeight * 0.025),

              // --- 1. DOWNLOAD ID CARD (Translucent Style) ---
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: translucentCardColor, // ✅ Soft transparent fill
                    border: Border.all(
                      color: subtleBorderColor,
                      width: 1,
                    ), // ✅ Soft edge
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // ✅ Forces exact center alignment
                    children: [
                      Icon(Icons.file_download_outlined, color: brandColor),
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 3.0,
                        ), // ✅ Tiny nudge down to offset Anek Devanagari's baseline
                        child: Text(
                          "Download ID Card",
                          style: GoogleFonts.anekDevanagari(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFFF9641),
                            height: 1.1, // ✅ Tightens the text box
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // --- 2. SUMMARY CARDS (Translucent Style) ---
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      icon: Icons.currency_rupee_rounded,
                      amount: "₹ 2550",
                      label: "CONTRIBUTIONS",
                      brandColor: brandColor,
                      cardColor: translucentCardColor,
                      borderColor: subtleBorderColor,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: _buildSummaryCard(
                      icon: Icons.volunteer_activism_rounded,
                      amount: "₹ 10000",
                      label: "HELP RECEIVED",
                      brandColor: brandColor,
                      cardColor: translucentCardColor,
                      borderColor: subtleBorderColor,
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.035),

              // --- 3. QUICK ACTIONS HEADER ---
              Text(
                "Quick Actions",
                style: GoogleFonts.anekDevanagari(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // --- 4. QUICK ACTIONS GRID (Translucent Style) ---
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: screenWidth * 0.035,
                mainAxisSpacing: screenWidth * 0.035,
                childAspectRatio: 1.2,
                children: [
                  _buildActionCard(
                    icon: Icons.account_balance_wallet_outlined,
                    title: "Pay Contribution",
                    brandColor: brandColor,
                    cardColor: translucentCardColor,
                    borderColor: subtleBorderColor,
                    onTap: () {},
                  ),
                  // _buildActionCard(
                  //   icon: Icons.people_alt_outlined,
                  //   title: "Add Family",
                  //   brandColor: brandColor,
                  //   cardColor: translucentCardColor,
                  //   borderColor: subtleBorderColor,
                  //   onTap: () {},
                  // ),
                  _buildActionCard(
                    icon: Icons.clean_hands_outlined,
                    title: "Request Help",
                    brandColor: brandColor,
                    cardColor: translucentCardColor,
                    borderColor: subtleBorderColor,
                    onTap: () {},
                  ),
                  // _buildActionCard(
                  //   icon: Icons.history_rounded,
                  //   title: "History",
                  //   brandColor: brandColor,
                  //   cardColor: translucentCardColor,
                  //   borderColor: subtleBorderColor,
                  //   onTap: () {},
                  // ),
                ],
              ),

              SizedBox(height: screenHeight * 0.04),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER: TRANSLUCENT SUMMARY CARD ---
  Widget _buildSummaryCard({
    required IconData icon,
    required String amount,
    required String label,
    required Color brandColor,
    required Color cardColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
            CrossAxisAlignment.center, // ✅ Forces exact center alignment
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: brandColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: brandColor, size: 24),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    amount,
                    style: GoogleFonts.anekDevanagari(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      height: 1.1, // ✅ Tightens the text box
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: GoogleFonts.anekDevanagari(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                      letterSpacing: 0.5,
                      height: 1.1, // ✅ Tightens the text box
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER: TRANSLUCENT QUICK ACTION CARD ---
  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color brandColor,
    required Color cardColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: brandColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: brandColor, size: 28),
            ),
            const SizedBox(height: 12),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  title,
                  style: GoogleFonts.anekDevanagari(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.1, // ✅ Tightens the text box
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
