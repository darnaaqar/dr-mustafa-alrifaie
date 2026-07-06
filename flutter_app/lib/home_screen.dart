import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants.dart';
import 'database_service.dart';

class HomeScreen extends StatefulWidget {
  final bool isArabic;
  final VoidCallback onLanguageToggle;

  const HomeScreen({
    super.key,
    required this.isArabic,
    required this.onLanguageToggle,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final trans = DentalTranslations.localizedValues[widget.isArabic ? 'ar' : 'en']!;
    final textDir = widget.isArabic ? TextDirection.rtl : TextDirection.ltr;

    return Directionality(
      textDirection: textDir,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: DentalColors.background,
        appBar: AppBar(
          backgroundColor: DentalColors.background.withOpacity(0.8),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(LucideIcons.menu, color: DentalColors.primaryAccent),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          title: Row(
            children: [
              const Icon(LucideIcons.stethoscope, color: DentalColors.primaryAccent, size: 20),
              const SizedBox(width: 8),
              Text(
                "DENTAL AI",
                style: GoogleFonts.inter(
                  color: DentalColors.primaryAccent,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ActionChip(
                backgroundColor: DentalColors.cardBg,
                side: BorderSide(color: DentalColors.primaryAccent.withOpacity(0.2)),
                label: Text(
                  widget.isArabic ? "English" : "عربي",
                  style: TextStyle(color: DentalColors.primaryAccent, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                onPressed: widget.onLanguageToggle,
              ),
            ),
          ],
        ),
        drawer: _buildDrawer(trans),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _HomeTab(isArabic: widget.isArabic, onBookNow: () => _openBookingForm(context)),
            _ServicesTab(isArabic: widget.isArabic),
            _GalleryTab(isArabic: widget.isArabic),
            _AboutTab(isArabic: widget.isArabic),
            _ContactTab(isArabic: widget.isArabic),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: DentalColors.cardBg,
          selectedItemColor: DentalColors.primaryAccent,
          unselectedItemColor: DentalColors.textSecondary.withOpacity(0.5),
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: [
            BottomNavigationBarItem(icon: const Icon(LucideIcons.home), label: trans['home']),
            BottomNavigationBarItem(icon: const Icon(LucideIcons.stethoscope), label: trans['services']),
            BottomNavigationBarItem(icon: const Icon(LucideIcons.layoutGrid), label: trans['gallery']),
            BottomNavigationBarItem(icon: const Icon(LucideIcons.user), label: trans['about']),
            BottomNavigationBarItem(icon: const Icon(LucideIcons.phone), label: trans['contact']),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(Map<String, String> trans) {
    return Drawer(
      backgroundColor: DentalColors.background,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white10)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.stethoscope, size: 40, color: DentalColors.primaryAccent),
                  const SizedBox(height: 12),
                  Text(
                    "DENTAL AI CLINIC",
                    style: GoogleFonts.inter(
                      color: DentalColors.primaryAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildDrawerItem(LucideIcons.home, trans['home']!, 0),
          _buildDrawerItem(LucideIcons.stethoscope, trans['services']!, 1),
          _buildDrawerItem(LucideIcons.layoutGrid, trans['gallery']!, 2),
          _buildDrawerItem(LucideIcons.user, trans['about']!, 3),
          _buildDrawerItem(LucideIcons.phone, trans['contact']!, 4),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "v1.0.1 Premium",
              style: GoogleFonts.jetBrainsMono(color: Colors.white10, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String label, int index) {
    bool isActive = _currentIndex == index;
    return ListTile(
      leading: Icon(icon, color: isActive ? DentalColors.primaryAccent : DentalColors.textSecondary),
      title: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : DentalColors.textSecondary,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        setState(() => _currentIndex = index);
        Navigator.pop(context);
      },
    );
  }

  void _openBookingForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BookingForm(isArabic: widget.isArabic),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final bool isArabic;
  final VoidCallback onBookNow;
  const _HomeTab({required this.isArabic, required this.onBookNow});

  @override
  Widget build(BuildContext context) {
    final trans = DentalTranslations.localizedValues[isArabic ? 'ar' : 'en']!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: DentalColors.cardBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white10),
              image: DecorationImage(
                image: const NetworkImage('https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&q=80&w=1200'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.darken),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trans['tagline']!,
                  style: GoogleFonts.cairo(
                    color: DentalColors.primaryAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2),
                const SizedBox(height: 12),
                Text(
                  isArabic ? "أحدث تقنيات طب الأسنان الرقمي والجميل" : "Latest digital and aesthetic dentistry technologies",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onBookNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DentalColors.primaryAccent,
                    foregroundColor: DentalColors.background,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(trans['book_now']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Stats Row
          Row(
            children: [
              _buildStatCard(isArabic ? '١٥+' : '15+', trans['experience']!),
              const SizedBox(width: 12),
              _buildStatCard(isArabic ? '٥٠٠٠+' : '5000+', isArabic ? 'مريض سعيد' : 'Happy Patients'),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Services Preview
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(trans['our_services_title']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              TextButton(onPressed: () {}, child: Text(trans['view_all']!, style: const TextStyle(color: DentalColors.primaryAccent))),
            ],
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<DentalService>>(
            future: DatabaseService.instance.getServices(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              final services = snapshot.data!.take(4).toList();
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.5,
                ),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final s = services[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: DentalColors.cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.sparkles, color: DentalColors.primaryAccent, size: 20),
                        const SizedBox(height: 8),
                        Text(
                          isArabic ? s.nameAr : s.nameEn,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String val, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: DentalColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          children: [
            Text(val, style: const TextStyle(color: DentalColors.primaryAccent, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: DentalColors.textSecondary, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _ServicesTab extends StatelessWidget {
  final bool isArabic;
  const _ServicesTab({required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DentalService>>(
      future: DatabaseService.instance.getServices(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final services = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final s = services[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: DentalColors.cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (s.imageUrl != null)
                    Image.network(s.imageUrl!, height: 160, width: double.infinity, fit: BoxFit.cover),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic ? s.nameAr : s.nameEn,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          (isArabic ? s.shortDescAr : s.shortDescEn) ?? '',
                          style: const TextStyle(color: DentalColors.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _GalleryTab extends StatelessWidget {
  final bool isArabic;
  const _GalleryTab({required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseService.instance.getGallery(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final items = snapshot.data!;
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(image: NetworkImage(item['image_url']), fit: BoxFit.cover),
                border: Border.all(color: Colors.white10),
              ),
            );
          },
        );
      },
    );
  }
}

class _AboutTab extends StatelessWidget {
  final bool isArabic;
  const _AboutTab({required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Doctor>>(
      future: DatabaseService.instance.getDoctors(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        if (snapshot.data!.isEmpty) return const Center(child: Text("No data"));
        final doc = snapshot.data!.first;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(doc.imageUrl ?? ''),
                backgroundColor: DentalColors.cardBg,
              ),
              const SizedBox(height: 24),
              Text(
                isArabic ? doc.fullNameAr : doc.fullNameEn,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                (isArabic ? doc.titleAr : doc.titleEn) ?? '',
                style: const TextStyle(color: DentalColors.primaryAccent, fontSize: 16),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: DentalColors.cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(LucideIcons.user, color: DentalColors.primaryAccent, size: 18),
                        const SizedBox(width: 8),
                        Text(isArabic ? "عن الدكتور" : "About Me", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      (isArabic ? doc.aboutAr : doc.aboutEn) ?? '',
                      style: const TextStyle(color: DentalColors.textSecondary, height: 1.6),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ContactTab extends StatelessWidget {
  final bool isArabic;
  const _ContactTab({required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final trans = DentalTranslations.localizedValues[isArabic ? 'ar' : 'en']!;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildContactItem(LucideIcons.phone, trans['phone_label']!, "+966 50 123 4567"),
          _buildContactItem(LucideIcons.mail, trans['email_label']!, "info@dr-mustafa-clinic.com"),
          _buildContactItem(LucideIcons.mapPin, trans['address']!, isArabic ? "شارع التخصصي، الرياض" : "Takhassusi St, Riyadh"),
          _buildContactItem(LucideIcons.clock, trans['working_hours']!, isArabic ? "السبت - الخميس: ٩ ص - ٩ م" : "Sat - Thu: 9 AM - 9 PM"),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DentalColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, color: DentalColors.primaryAccent, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: DentalColors.textSecondary, fontSize: 11)),
                Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingForm extends StatefulWidget {
  final bool isArabic;
  const _BookingForm({required this.isArabic});

  @override
  State<_BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<_BookingForm> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String phone = '';
  String email = '';
  String? serviceId;
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 0);
  String notes = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final trans = DentalTranslations.localizedValues[widget.isArabic ? 'ar' : 'en']!;
    return Container(
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 40,
      ),
      decoration: const BoxDecoration(
        color: DentalColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: DentalColors.primaryAccent, width: 2)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(trans['book_btn']!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 24),
              _buildField(LucideIcons.user, trans['name_label']!, (v) => name = v),
              const SizedBox(height: 16),
              _buildField(LucideIcons.phone, trans['phone_label']!, (v) => phone = v, type: TextInputType.phone),
              const SizedBox(height: 16),
              _buildField(LucideIcons.mail, trans['email_label']!, (v) => email = v, type: TextInputType.emailAddress, required: false),
              const SizedBox(height: 16),
              
              FutureBuilder<List<DentalService>>(
                future: DatabaseService.instance.getServices(),
                builder: (context, snapshot) {
                  return DropdownButtonFormField<String>(
                    dropdownColor: DentalColors.cardBg,
                    decoration: _inputDecoration(LucideIcons.stethoscope, trans['select_service']!),
                    items: (snapshot.data ?? []).map((s) => DropdownMenuItem(
                      value: s.id,
                      child: Text(widget.isArabic ? s.nameAr : s.nameEn, style: const TextStyle(fontSize: 13)),
                    )).toList(),
                    onChanged: (v) => setState(() => serviceId = v),
                    validator: (v) => v == null ? 'Required' : null,
                  );
                },
              ),
              
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DentalColors.primaryAccent,
                    foregroundColor: DentalColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: loading 
                    ? const CircularProgressIndicator(color: DentalColors.background)
                    : Text(trans['submit_booking']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => loading = true);
    
    final success = await DatabaseService.instance.bookAppointment(
      name: name,
      phone: phone,
      email: email,
      serviceId: serviceId,
      date: "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
      time: "${selectedTime.hour}:${selectedTime.minute}",
      notes: notes,
      lang: widget.isArabic ? 'ar' : 'en',
    );

    if (mounted) {
      setState(() => loading = false);
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(DentalTranslations.localizedValues[widget.isArabic ? 'ar' : 'en']!['success_booking']!)),
        );
      }
    }
  }

  Widget _buildField(IconData icon, String label, Function(String) onSave, {TextInputType type = TextInputType.text, bool required = true}) {
    return TextFormField(
      keyboardType: type,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(icon, label),
      validator: required ? (v) => v!.isEmpty ? 'Required' : null : null,
      onSaved: (v) => onSave(v ?? ''),
    );
  }

  InputDecoration _inputDecoration(IconData icon, String label) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: DentalColors.primaryAccent, size: 20),
      labelText: label,
      labelStyle: const TextStyle(color: DentalColors.textSecondary, fontSize: 14),
      filled: true,
      fillColor: DentalColors.cardBg,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: DentalColors.primaryAccent)),
    );
  }
}
