import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Doctor {
  final String id;
  final String fullNameAr;
  final String fullNameEn;
  final String? titleAr;
  final String? titleEn;
  final String? aboutAr;
  final String? aboutEn;
  final String? qualificationsAr;
  final String? qualificationsEn;
  final int experienceYears;
  final String? imageUrl;
  final String? phone;
  final String? email;
  final String? whatsapp;
  final String? facebook;
  final String? instagram;

  Doctor({
    required this.id,
    required this.fullNameAr,
    required this.fullNameEn,
    this.titleAr,
    this.titleEn,
    this.aboutAr,
    this.aboutEn,
    this.qualificationsAr,
    this.qualificationsEn,
    this.experienceYears = 0,
    this.imageUrl,
    this.phone,
    this.email,
    this.whatsapp,
    this.facebook,
    this.instagram,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      fullNameAr: json['full_name_ar'] ?? '',
      fullNameEn: json['full_name_en'] ?? '',
      titleAr: json['title_ar'],
      titleEn: json['title_en'],
      aboutAr: json['about_ar'],
      aboutEn: json['about_en'],
      qualificationsAr: json['qualifications_ar'],
      qualificationsEn: json['qualifications_en'],
      experienceYears: json['experience_years'] ?? 0,
      imageUrl: json['image_url'],
      phone: json['phone'],
      email: json['email'],
      whatsapp: json['whatsapp'],
      facebook: json['facebook'],
      instagram: json['instagram'],
    );
  }
}

class DentalService {
  final String id;
  final String nameAr;
  final String nameEn;
  final String? shortDescAr;
  final String? shortDescEn;
  final String? detailsAr;
  final String? detailsEn;
  final String? benefitsAr;
  final String? benefitsEn;
  final String? icon;
  final String? imageUrl;
  final int sortOrder;

  DentalService({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.shortDescAr,
    this.shortDescEn,
    this.detailsAr,
    this.detailsEn,
    this.benefitsAr,
    this.benefitsEn,
    this.icon,
    this.imageUrl,
    this.sortOrder = 1,
  });

  factory DentalService.fromJson(Map<String, dynamic> json) {
    return DentalService(
      id: json['id'],
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      shortDescAr: json['short_desc_ar'],
      shortDescEn: json['short_desc_en'],
      detailsAr: json['details_ar'],
      detailsEn: json['details_en'],
      benefitsAr: json['benefits_ar'],
      benefitsEn: json['benefits_en'],
      icon: json['icon'],
      imageUrl: json['image_url'],
      sortOrder: json['sort_order'] ?? 1,
    );
  }
}

class DatabaseService {
  static final DatabaseService instance = DatabaseService._();
  DatabaseService._();

  bool _initialized = false;
  void markInitialized() => _initialized = true;

  final _supabase = Supabase.instance.client;

  Future<List<Doctor>> getDoctors() async {
    if (!_initialized) return [];
    try {
      final response = await _supabase.from('doctors').select('*');
      return (response as List).map((d) => Doctor.fromJson(d)).toList();
    } catch (e) {
      debugPrint("Error fetching doctors: $e");
      return [];
    }
  }

  Future<List<DentalService>> getServices() async {
    if (!_initialized) return [];
    try {
      final response = await _supabase
          .from('services')
          .select('*')
          .eq('active', true)
          .order('sort_order', ascending: true);
      return (response as List).map((s) => DentalService.fromJson(s)).toList();
    } catch (e) {
      debugPrint("Error fetching services: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getGallery() async {
    if (!_initialized) return [];
    try {
      final response = await _supabase.from('gallery').select('*').order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint("Error fetching gallery: $e");
      return [];
    }
  }

  Future<bool> bookAppointment({
    required String name,
    required String phone,
    required String? email,
    required String? serviceId,
    required String date,
    required String time,
    required String notes,
    String lang = 'ar',
  }) async {
    try {
      await _supabase.from('appointments').insert({
        'patient_name': name,
        'phone': phone,
        'email': email,
        'service_id': serviceId,
        'preferred_language': lang,
        'appointment_date': date,
        'appointment_time': time,
        'notes': notes,
        'status': 'pending',
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
