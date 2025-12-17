import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'authentication/login.dart' show LoginPage;
import 'main.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _nameController = TextEditingController();
  final _headlineController = TextEditingController();
  final _cityController = TextEditingController();
  final _majorController = TextEditingController();
  final _universityController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _saving = false;
  File? _selectedImageFile;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    final user = supabase.auth.currentUser;
    if (user != null) {
      _nameController.text =
          user.userMetadata?['full_name'] ?? user.email?.split('@').first ?? '';
      _headlineController.text = user.userMetadata?['headline'] ?? '';
      _cityController.text = user.userMetadata?['city'] ?? '';
      _majorController.text = user.userMetadata?['major'] ?? '';
      _universityController.text = user.userMetadata?['university'] ?? '';
      _avatarUrl = user.userMetadata?['avatar_url'];
      _emailController.text = user.email ?? '';
      _phoneController.text = user.userMetadata?['phone'] ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _headlineController.dispose();
    _cityController.dispose();
    _majorController.dispose();
    _universityController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        _selectedImageFile = File(picked.path);
      });
    }
  }

  Future<String?> _uploadAvatar(File file) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      debugPrint('❌ User tidak login');
      return null;
    }
    
    final fileExt = file.path.split('.').last;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
    final filePath = '${user.id}/$fileName';

    debugPrint('📤 Uploading to: Profile_picture/$filePath');

    try {
      // ✅ Upload ke bucket Profile_picture
      await supabase.storage
          .from('Profile_picture')
          .upload(
            filePath,
            file,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
            ),
          );

      // ✅ Get public URL dari bucket Profile_picture
      final publicUrl = supabase.storage
          .from('Profile_picture')
          .getPublicUrl(filePath);
      
      debugPrint('✅ Upload berhasil! URL: $publicUrl');
      return publicUrl;
      
    } catch (e) {
      debugPrint('❌ Upload gagal: $e');
      
      // Cek apakah error karena file sudah ada (duplicate)
      if (e.toString().contains('Duplicate') || e.toString().contains('already exists')) {
        debugPrint('⚠️ File duplicate, coba dengan nama baru...');
        // Coba generate nama file baru dengan suffix random
        final newFileName = '${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}.$fileExt';
        final newFilePath = '${user.id}/$newFileName';
        
        try {
          await supabase.storage
              .from('Profile_picture')
              .upload(
                newFilePath,
                file,
                fileOptions: const FileOptions(
                  cacheControl: '3600',
                  upsert: false,
                ),
              );
          
          final publicUrl = supabase.storage
              .from('Profile_picture')
              .getPublicUrl(newFilePath);
          
          debugPrint('✅ Upload berhasil (retry)! URL: $publicUrl');
          return publicUrl;
        } catch (retryError) {
          debugPrint('❌ Retry upload gagal: $retryError');
          return null;
        }
      }
      
      return null;
    }
  }

  Future<void> _save() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
      return;
    }

    final name = _nameController.text.trim();
    final headline = _headlineController.text.trim();
    final city = _cityController.text.trim();
    final major = _majorController.text.trim();
    final university = _universityController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nama tidak boleh kosong')));
      return;
    }

    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email tidak boleh kosong')));
      return;
    }

    setState(() => _saving = true);

    try {
      String? avatarUrl = _avatarUrl;
      
      // Upload foto baru jika ada
      if (_selectedImageFile != null) {
        debugPrint('🔄 Mulai upload foto...');
        avatarUrl = await _uploadAvatar(_selectedImageFile!);
        
        if (avatarUrl == null) {
          throw Exception('Gagal upload foto. Coba lagi.');
        }
        debugPrint('✅ Foto berhasil diupload: $avatarUrl');
      }

      // Update user metadata
      debugPrint('🔄 Update user metadata...');
      await supabase.auth.updateUser(
        UserAttributes(
          email: email == user.email ? null : email,
          data: {
            'full_name': name,
            'headline': headline,
            'city': city,
            'major': major,
            'university': university,
            'phone': phone,
            'avatar_url': avatarUrl ?? '',
          },
        ),
      );

      debugPrint('✅ Profile berhasil diupdate!');

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil disimpan!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      // Kembali ke halaman sebelumnya dengan data baru
      Navigator.pop(context, {
        'name': name,
        'headline': headline,
        'city': city,
        'major': major,
        'university': university,
        'avatar_url': avatarUrl,
        'email': email,
        'phone': phone,
      });
    } catch (e) {
      debugPrint('❌ Error save: $e');
      
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(
        content: Text('Gagal menyimpan: $e'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Widget untuk menampilkan avatar
    final avatar = _selectedImageFile != null
        ? Image.file(_selectedImageFile!, fit: BoxFit.cover)
        : (_avatarUrl != null && _avatarUrl!.isNotEmpty
              ? Image.network(_avatarUrl!, fit: BoxFit.cover)
              : const Icon(Icons.person, size: 36, color: Colors.white));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Simpan'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar dengan tombol edit
            Stack(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.grey.shade300,
                  child: ClipOval(
                    child: SizedBox(width: 90, height: 90, child: avatar),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: InkWell(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 4),
                        ],
                      ),
                      child: const Icon(Icons.photo_camera, size: 18, color: Color(0xFFE89B8E)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Form fields
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nama lengkap',
                hintText: 'Masukkan nama',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _majorController,
              decoration: const InputDecoration(
                labelText: 'Jurusan / Major',
                hintText: 'Contoh: Akuntansi',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _universityController,
              decoration: const InputDecoration(
                labelText: 'Universitas',
                hintText: 'Contoh: Universitas Indonesia',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'nama@email.com',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Nomor telepon',
                hintText: '+62...',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _headlineController,
              decoration: const InputDecoration(
                labelText: 'Headline',
                hintText: 'Contoh: Mahasiswa Akuntansi',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'Kota / Domisili',
                hintText: 'Contoh: Jakarta',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
