import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'constants.dart';
import 'home_screen.dart';
import 'database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase if keys are provided
  if (SupabaseConfig.isConfigured) {
    try {
      await Supabase.initialize(
        url: SupabaseConfig.url,
        publishableKey: SupabaseConfig.anonKey,
      );
      DatabaseService.instance.markInitialized();
    } catch (e) {
      debugPrint("Supabase initialization failed: $e");
    }
  }

  runApp(const PremiumDentalApp());
}

class PremiumDentalApp extends StatefulWidget {
  const PremiumDentalApp({super.key});

  @override
  State<PremiumDentalApp> createState() => _PremiumDentalAppState();
}

class _PremiumDentalAppState extends State<PremiumDentalApp> {
  bool isArabic = true;

  void toggleLanguage() {
    setState(() {
      isArabic = !isArabic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dr. Mustafa Al-Rifai Clinic',
      debugShowCheckedModeBanner: false,
      locale: Locale(isArabic ? 'ar' : 'en'),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: DentalColors.background,
        cardColor: DentalColors.cardBg,
        primaryColor: DentalColors.primaryAccent,
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
