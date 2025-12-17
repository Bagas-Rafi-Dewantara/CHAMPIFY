import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'authentication/login.dart' show LoginPage;
import 'main.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

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
  Uint8List? _selectedImageBytes;

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
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
          _selectedImageFile = null;
        });
      } else {
        setState(() {
          _selectedImageFile = File(picked.path);
          _selectedImageBytes = null;
        });
      }
    }
  }

  Future<String?> _uploadAvatar({
    File? file,
    Uint8List? bytes,
    String? fileName,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final ext =
        fileName?.split('.').last ??
        (file != null ? file.path.split('.').last : 'jpg');
    final path = '${user.id}.$ext';

    final data = bytes ?? await file!.readAsBytes();

    await supabase.storage
        .from('Profile_picture')
        .uploadBinary(
          path,
          data,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
        );

    final url = supabase.storage.from('Profile_picture').getPublicUrl(path);
    return url;
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
      if (_selectedImageFile != null || _selectedImageBytes != null) {
        avatarUrl = await _uploadAvatar(
          file: kIsWeb ? null : _selectedImageFile,
          bytes: kIsWeb ? _selectedImageBytes : null,
          fileName: kIsWeb ? 'avatar_${user.id}.jpg' : _selectedImageFile?.path,
        );
      }

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
            if (avatarUrl != null) 'avatar_url': avatarUrl,
          },
        ),
      );

      await supabase.auth.refreshSession();

      final Map<String, dynamic> profileUpdate = {
        'id_pengguna': user.id,
        'full_name': name,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
      };

      try {
        await supabase
            .from('pengguna')
            .upsert(profileUpdate, onConflict: 'id_pengguna');
        debugPrint('✓ Berhasil update tabel pengguna');
      } catch (e) {
        debugPrint('✗ Gagal update tabel pengguna: $e');
      }

      if (!mounted) return;
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatar = _selectedImageFile != null
        ? Image.file(_selectedImageFile!, fit: BoxFit.cover)
        : _selectedImageBytes != null
        ? Image.memory(_selectedImageBytes!, fit: BoxFit.cover)
        : (_avatarUrl != null
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
                      child: const Icon(Icons.photo_camera, size: 18),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
