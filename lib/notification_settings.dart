import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'main.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _loading = true;
  bool _saving = false;

  // State untuk toggle notifikasi utama
  bool enableNotifications = true;

  // State untuk notifikasi kursus
  bool courseUpdates = true;
  bool newCourseAvailable = true;
  bool courseReminders = true;
  bool assignmentDeadlines = true;

  // State untuk notifikasi kompetisi
  bool competitionUpdates = true;
  bool competitionReminders = true;
  bool competitionResults = true;
  bool newCompetition = true;

  // State untuk notifikasi mentoring
  bool mentoringSchedule = true;
  bool mentorMessages = true;
  bool sessionReminders = true;

  // State untuk notifikasi sistem
  bool systemUpdates = true;
  bool promotions = false;
  bool newsletter = false;

  // State untuk notifikasi suara & getar
  bool soundEnabled = true;
  bool vibrationEnabled = true;

  // Waktu quiet hours
  TimeOfDay quietHoursStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay quietHoursEnd = const TimeOfDay(hour: 7, minute: 0);
  bool quietHoursEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: _loading ? const NeverScrollableScrollPhysics() : null,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_loading)
                const LinearProgressIndicator(
                  color: Color(0xFFE89B8E),
                  minHeight: 2,
                ),
              if (_loading) const SizedBox(height: 16),
              // Header Description
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE89B8E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE89B8E).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.notifications_active_outlined,
                      color: Color(0xFFE89B8E),
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Kelola notifikasi untuk tetap update dengan aktivitas Anda',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Master Toggle
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE89B8E).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.notifications,
                        color: Color(0xFFE89B8E),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Text(
                        'Aktifkan Notifikasi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Switch(
                      value: enableNotifications,
                      onChanged: (value) {
                        setState(() {
                          enableNotifications = value;
                        });
                      },
                      activeColor: const Color(0xFFE89B8E),
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Notifikasi Kursus
              const Text(
                'Notifikasi Kursus',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 15),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildToggleItem(
                      icon: Icons.update,
                      title: 'Update Kursus',
                      subtitle: 'Materi baru, pengumuman dari instruktur',
                      value: courseUpdates,
                      enabled: enableNotifications,
                      onChanged: (value) {
                        setState(() {
                          courseUpdates = value;
                        });
                      },
                      isFirst: true,
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildToggleItem(
                      icon: Icons.library_add_outlined,
                      title: 'Kursus Baru Tersedia',
                      subtitle: 'Notifikasi kursus yang mungkin Anda suka',
                      value: newCourseAvailable,
                      enabled: enableNotifications,
                      onChanged: (value) {
                        setState(() {
                          newCourseAvailable = value;
                        });
                      },
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildToggleItem(
                      icon: Icons.alarm,
                      title: 'Pengingat Kursus',
                      subtitle: 'Pengingat untuk melanjutkan belajar',
                      value: courseReminders,
                      enabled: enableNotifications,
                      onChanged: (value) {
                        setState(() {
                          courseReminders = value;
                        });
                      },
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildToggleItem(
                      icon: Icons.assignment_late_outlined,
                      title: 'Deadline Tugas',
                      subtitle: 'Pengingat batas waktu pengumpulan tugas',
                      value: assignmentDeadlines,
                      enabled: enableNotifications,
                      onChanged: (value) {
                        setState(() {
                          assignmentDeadlines = value;
                        });
                      },
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Notifikasi Kompetisi
              const Text(
                'Notifikasi Kompetisi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 15),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildToggleItem(
                      icon: Icons.campaign_outlined,
                      title: 'Update Kompetisi',
                      subtitle: 'Informasi terbaru kompetisi Anda',
                      value: competitionUpdates,
                      enabled: enableNotifications,
                      onChanged: (value) {
                        setState(() {
                          competitionUpdates = value;
                        });
                      },
                      isFirst: true,
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildToggleItem(
                      icon: Icons.event_note_outlined,
                      title: 'Pengingat Kompetisi',
                      subtitle: 'Pengingat sebelum kompetisi dimulai',
                      value: competitionReminders,
                      enabled: enableNotifications,
                      onChanged: (value) {
                        setState(() {
                          competitionReminders = value;
                        });
                      },
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildToggleItem(
                      icon: Icons.emoji_events_outlined,
                      title: 'Hasil Kompetisi',
                      subtitle: 'Pengumuman pemenang dan skor',
                      value: competitionResults,
                      enabled: enableNotifications,
                      onChanged: (value) {
                        setState(() {
                          competitionResults = value;
                        });
                      },
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildToggleItem(
                      icon: Icons.new_releases_outlined,
                      title: 'Kompetisi Baru',
                      subtitle: 'Notifikasi kompetisi yang bisa Anda ikuti',
                      value: newCompetition,
                      enabled: enableNotifications,
                      onChanged: (value) {
                        setState(() {
                          newCompetition = value;
                        });
                      },
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Notifikasi Mentoring
              const Text(
                'Notifikasi Mentoring',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 15),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildToggleItem(
                      icon: Icons.calendar_today_outlined,
                      title: 'Jadwal Mentoring',
                      subtitle: 'Konfirmasi dan perubahan jadwal',
                      value: mentoringSchedule,
                      enabled: enableNotifications,
                      onChanged: (value) {
                        setState(() {
                          mentoringSchedule = value;
                        });
                      },
                      isFirst: true,
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildToggleItem(
                      icon: Icons.message_outlined,
                      title: 'Pesan dari Mentor',
                      subtitle: 'Pesan dan feedback dari mentor',
                      value: mentorMessages,
                      enabled: enableNotifications,
                      onChanged: (value) {
                        setState(() {
                          mentorMessages = value;
                        });
                      },
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildToggleItem(
                      icon: Icons.access_time,
                      title: 'Pengingat Sesi',
                      subtitle: 'Pengingat sebelum sesi dimulai',
                      value: sessionReminders,
                      enabled: enableNotifications,
                      onChanged: (value) {
                        setState(() {
                          sessionReminders = value;
                        });
                      },
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Notifikasi Lainnya
              const Text(
                'Notifikasi Lainnya',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 15),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildToggleItem(
                      icon: Icons.system_update_outlined,
                      title: 'Update Sistem',
                      subtitle: 'Fitur baru dan pembaruan aplikasi',
                      value: systemUpdates,
                      enabled: enableNotifications,
                      onChanged: (value) {
                        setState(() {
                          systemUpdates = value;
                        });
                      },
                      isFirst: true,
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildToggleItem(
                      icon: Icons.local_offer_outlined,
                      title: 'Promosi & Penawaran',
                      subtitle: 'Diskon dan penawaran spesial',
                      value: promotions,
                      enabled: enableNotifications,
                      onChanged: (value) {
                        setState(() {
                          promotions = value;
                        });
                      },
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildToggleItem(
                      icon: Icons.email_outlined,
                      title: 'Newsletter',
                      subtitle: 'Tips belajar dan artikel edukatif',
                      value: newsletter,
                      enabled: enableNotifications,
                      onChanged: (value) {
                        setState(() {
                          newsletter = value;
                        });
                      },
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Pengaturan Suara & Getar
              const Text(
                'Suara & Getar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 15),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildToggleItem(
                      icon: Icons.volume_up_outlined,
                      title: 'Suara Notifikasi',
                      subtitle: 'Putar suara saat notifikasi masuk',
                      value: soundEnabled,
                      enabled: enableNotifications,
                      onChanged: (value) {
                        setState(() {
                          soundEnabled = value;
                        });
                      },
                      isFirst: true,
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildToggleItem(
                      icon: Icons.vibration,
                      title: 'Getar',
                      subtitle: 'Getar saat notifikasi masuk',
                      value: vibrationEnabled,
                      enabled: enableNotifications,
                      onChanged: (value) {
                        setState(() {
                          vibrationEnabled = value;
                        });
                      },
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Quiet Hours
              const Text(
                'Quiet Hours',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Nonaktifkan notifikasi pada waktu tertentu',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 15),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.nights_stay_outlined,
                            color: Colors.black87,
                            size: 24,
                          ),
                          const SizedBox(width: 15),
                          const Expanded(
                            child: Text(
                              'Aktifkan Quiet Hours',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Switch(
                            value: quietHoursEnabled,
                            onChanged: enableNotifications
                                ? (value) {
                                    setState(() {
                                      quietHoursEnabled = value;
                                    });
                                  }
                                : null,
                            activeColor: const Color(0xFFE89B8E),
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.grey.shade300,
                          ),
                        ],
                      ),
                    ),
                    if (quietHoursEnabled) ...[
                      const Divider(height: 1),
                      _buildTimeSelector(
                        icon: Icons.bedtime_outlined,
                        title: 'Mulai',
                        time: quietHoursStart,
                        onTap: () => _selectTime(context, true),
                      ),
                      const Divider(height: 1, indent: 56),
                      _buildTimeSelector(
                        icon: Icons.wb_sunny_outlined,
                        title: 'Selesai',
                        time: quietHoursEnd,
                        onTap: () => _selectTime(context, false),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Save Button
              GestureDetector(
                onTap: () {
                  if (_saving) return;
                  _saveSettings();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE89B8E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Simpan Pengaturan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadSettings() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      setState(() => _loading = false);
      return;
    }

    final meta = user.userMetadata ?? {};
    final existing = meta['notification_settings'];

    if (existing is Map) {
      setState(() {
        enableNotifications = existing['enable_notifications'] as bool? ?? true;
        courseUpdates = existing['course_updates'] as bool? ?? true;
        newCourseAvailable = existing['new_course_available'] as bool? ?? true;
        courseReminders = existing['course_reminders'] as bool? ?? true;
        assignmentDeadlines = existing['assignment_deadlines'] as bool? ?? true;
        competitionUpdates = existing['competition_updates'] as bool? ?? true;
        competitionReminders =
            existing['competition_reminders'] as bool? ?? true;
        competitionResults = existing['competition_results'] as bool? ?? true;
        newCompetition = existing['new_competition'] as bool? ?? true;
        mentoringSchedule = existing['mentoring_schedule'] as bool? ?? true;
        mentorMessages = existing['mentor_messages'] as bool? ?? true;
        sessionReminders = existing['session_reminders'] as bool? ?? true;
        systemUpdates = existing['system_updates'] as bool? ?? true;
        promotions = existing['promotions'] as bool? ?? false;
        newsletter = existing['newsletter'] as bool? ?? false;
        soundEnabled = existing['sound_enabled'] as bool? ?? true;
        vibrationEnabled = existing['vibration_enabled'] as bool? ?? true;
        quietHoursEnabled = existing['quiet_hours_enabled'] as bool? ?? false;
        quietHoursStart = _parseTimeOfDay(
          existing['quiet_hours_start'] as String?,
          quietHoursStart,
        );
        quietHoursEnd = _parseTimeOfDay(
          existing['quiet_hours_end'] as String?,
          quietHoursEnd,
        );
      });
    }

    setState(() => _loading = false);
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required bool enabled,
    required ValueChanged<bool> onChanged,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: Padding(
        padding: EdgeInsets.only(
          top: isFirst ? 12 : 12,
          bottom: isLast ? 12 : 12,
          left: 16,
          right: 16,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black87, size: 24),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Switch(
              value: value,
              onChanged: enabled ? onChanged : null,
              activeColor: const Color(0xFFE89B8E),
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector({
    required IconData icon,
    required String title,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.black87, size: 24),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                time.format(context),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE89B8E),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? quietHoursStart : quietHoursEnd,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFFE89B8E),
            colorScheme: const ColorScheme.light(primary: Color(0xFFE89B8E)),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          quietHoursStart = picked;
        } else {
          quietHoursEnd = picked;
        }
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  TimeOfDay _parseTimeOfDay(String? value, TimeOfDay fallback) {
    if (value == null || !value.contains(':')) return fallback;
    final parts = value.split(':');
    if (parts.length != 2) return fallback;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return fallback;
    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> _saveSettings() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan login untuk menyimpan pengaturan'),
          backgroundColor: Color(0xFFE89B8E),
        ),
      );
      return;
    }

    setState(() => _saving = true);

    final payload = {
      'enable_notifications': enableNotifications,
      'course_updates': courseUpdates,
      'new_course_available': newCourseAvailable,
      'course_reminders': courseReminders,
      'assignment_deadlines': assignmentDeadlines,
      'competition_updates': competitionUpdates,
      'competition_reminders': competitionReminders,
      'competition_results': competitionResults,
      'new_competition': newCompetition,
      'mentoring_schedule': mentoringSchedule,
      'mentor_messages': mentorMessages,
      'session_reminders': sessionReminders,
      'system_updates': systemUpdates,
      'promotions': promotions,
      'newsletter': newsletter,
      'sound_enabled': soundEnabled,
      'vibration_enabled': vibrationEnabled,
      'quiet_hours_enabled': quietHoursEnabled,
      'quiet_hours_start': _formatTimeOfDay(quietHoursStart),
      'quiet_hours_end': _formatTimeOfDay(quietHoursEnd),
    };

    final updatedMeta = {
      ...(user.userMetadata ?? {}),
      'notification_settings': payload,
    };

    try {
      await supabase.auth.updateUser(UserAttributes(data: updatedMeta));
      await supabase.auth.refreshSession();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('Pengaturan notifikasi berhasil disimpan!'),
            ],
          ),
          backgroundColor: const Color(0xFFE89B8E),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      Navigator.pop(context, payload);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: $e'),
          backgroundColor: Colors.red.shade400,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
