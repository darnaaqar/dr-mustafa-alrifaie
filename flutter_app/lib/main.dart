// Premium Dental App for Dr. Mustafa Al-Rifai
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PremiumDentalApp());
}

class PremiumDentalApp extends StatefulWidget {
  const PremiumDentalApp({super.key});

  @override
  State<PremiumDentalApp> createState() => _PremiumDentalAppState();
}

class _PremiumDentalAppState extends State<PremiumDentalApp> {
  bool isArabic = true; // Default to Arabic as shown in the uploaded screenshot

  void toggleLanguage() {
    setState(() {
      isArabic = !isArabic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dr. Mustafa Clinic',
      debugShowCheckedModeBanner: false,
      locale: Locale(isArabic ? 'ar' : 'en'),
      
      // Modern High-Contrast Bioluminescent theme
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: DentalColors.background,
        cardColor: DentalColors.cardBg,
        primaryColor: DentalColors.primaryAccent,
        dividerColor: Colors.white10,
        textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme).copyWith(
          bodyMedium: isArabic 
            ? GoogleFonts.cairo(color: DentalColors.textSecondary)
            : GoogleFonts.inter(color: DentalColors.textSecondary),
          titleLarge: isArabic
            ? GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)
            : GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      home: HomeScreen(
        isArabic: isArabic, 
        onLanguageToggle: toggleLanguage,
      ),
    );
  }
}
