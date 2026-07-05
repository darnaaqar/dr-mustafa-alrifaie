import 'package:flutter/material.dart';

class DentalColors {
  static const Color background = Color(0xFF07131E);
  static const Color cardBg = Color(0xFF0F1D2A);
  static const Color primaryAccent = Color(0xFF00D8FF);
  static const Color secondaryAccent = Color(0xFF39E6FF);
  static const Color textMain = Colors.white;
  static const Color textSecondary = Color(0xFFB6D3E5);

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF00D4FF), Color(0xFF00A6E6)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

class SupabaseConfig {
  static const String url = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  static const String anonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
  
  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;
}

class DentalTranslations {
  static const Map<String, Map<String, String>> localizedValues = {
    'ar': {
      'app_name': 'د. مصطفى الرفاعي',
      'clinic_name': 'عيادة د. مصطفى الرفاعي',
      'tagline': 'إبتسامة صحية.. مظهر أجمل.. حياة أفضل',
      'home': 'الرئيسية',
      'services': 'الخدمات',
      'gallery': 'المعرض',
      'about': 'عن الدكتور',
      'contact': 'اتصل بنا',
      'appointments': 'مواعيدي',
      'book_now': 'احجز الآن',
      'experience': 'سنة خبرة',
      'book_btn': 'حجز موعد جديد',
      'name_label': 'الاسم الكامل',
      'phone_label': 'رقم الجوال',
      'email_label': 'البريد الإلكتروني (اختياري)',
      'select_service': 'اختر الخدمة',
      'notes_label': 'ملاحظات إضافية',
      'submit_booking': 'تأكيد الحجز الرقمي',
      'success_booking': 'تم استلام طلب الحجز بنجاح!',
      'language': 'Language',
      'view_all': 'عرض الكل',
      'our_doctors': 'أطباؤنا',
      'our_services_title': 'خدماتنا المتميزة',
      'working_hours': 'ساعات العمل',
      'address': 'العنوان',
    },
    'en': {
      'app_name': 'Dr. Mustafa Al-Rifai',
      'clinic_name': 'Dr. Mustafa Al-Rifai Clinic',
      'tagline': 'Healthy smile.. Beautiful look.. Better life',
      'home': 'Home',
      'services': 'Services',
      'gallery': 'Gallery',
      'about': 'About',
      'contact': 'Contact',
      'appointments': 'Appointments',
      'book_now': 'Book Now',
      'experience': 'Years Experience',
      'book_btn': 'Book Appointment',
      'name_label': 'Full Name',
      'phone_label': 'Phone Number',
      'email_label': 'Email (Optional)',
      'select_service': 'Select Service',
      'notes_label': 'Additional Notes',
      'submit_booking': 'Confirm Digital Booking',
      'success_booking': 'Booking request received successfully!',
      'language': 'عربي',
      'view_all': 'View All',
      'our_doctors': 'Our Doctors',
      'our_services_title': 'Our Premium Services',
      'working_hours': 'Working Hours',
      'address': 'Address',
    }
  };
}
