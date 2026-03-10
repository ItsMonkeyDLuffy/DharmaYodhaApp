import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DigitalIdCard extends StatelessWidget {
  final String name;
  final String memberId;
  final String uid; // We will encode the UID in the QR code
  final String status;

  const DigitalIdCard({
    super.key,
    required this.name,
    required this.memberId,
    required this.uid,
    this.status = 'Active',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 190,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        // ✅ Removed .withOpacity(0.95) here so the shadow stays strictly behind the card
        gradient: const LinearGradient(
          colors: [Color(0xFFF0612E), Color(0xFFFF943D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(2, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 1. Background Watermark Flag (Updated with your Container structure)
          Positioned(
            right: -20,
            bottom:
                -6, // Shifted slightly so the 212 height fits nicely in the 200 container
            child: Opacity(
              opacity: 0.70,
              child: Container(
                width: 312,
                height: 205,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/saffron_flag_bg.png',
                    ), // Swapped placeholder for your asset
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),

          // 2. Card Content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // --- TOP ROW: Logo & Text ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Hindi Title
                        Text(
                          'धर्म योद्धा',
                          style: GoogleFonts.anekDevanagari(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: const [
                              Shadow(
                                offset: Offset(1, 2),
                                blurRadius: 4,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Digital ID Card",
                      style: GoogleFonts.anekDevanagari(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        height: 2.2,
                      ),
                    ),
                  ],
                ),

                // --- BOTTOM ROW: User Info & QR Code ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // ✅ Changed to start so the Name aligns with the top of the QR Box
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Side: Name, ID, Badge
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ✅ Wrapped Name in responsive FittedBox
                          SizedBox(
                            width: double.infinity,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                name.toUpperCase(),
                                style: GoogleFonts.anekDevanagari(
                                  color: const Color(
                                    0xFF1A1A1A,
                                  ), // Almost black
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                  height:
                                      1.1, // ✅ Tightened line-height padding
                                ),
                              ),
                            ),
                          ),
                          // ✅ Wrapped ID in responsive FittedBox
                          SizedBox(
                            width: double.infinity,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "ID: $memberId",
                                style: GoogleFonts.anekDevanagari(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13,
                                  letterSpacing: 1.2,
                                  height:
                                      1.1, // ✅ Tightened line-height padding
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ), // ✅ Reduced padding from 12 to 4
                          // Active Status Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFD4F5D6,
                              ), // Light green background
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: Color(0xFF1B8035), // Dark green
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  status,
                                  style: GoogleFonts.anekDevanagari(
                                    color: const Color(0xFF1B8035),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Right Side: QR Code Container
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: QrImageView(
                        data: uid, // Encodes the user's UID securely
                        version: QrVersions.auto,
                        size: 70.0,
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.all(1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
