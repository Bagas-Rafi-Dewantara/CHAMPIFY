# 🏆 Champify

<div align="center">
  <img src="https://github.com/user-attachments/assets/a7fe9ba5-74aa-4cbc-9356-b2d81eb8a43d" alt="Champify Banner" width="100%"/>
  
  <p align="center">
    <strong>Be a Champion with the Right Preparation!</strong>
  </p>
  
  <p align="center">
    Platform e-learning dan komunitas kompetisi untuk mahasiswa dan pelajar
  </p>

  [![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=flat&logo=flutter)](https://flutter.dev)
  [![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?style=flat&logo=supabase)](https://supabase.com)
  [![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
</div>

## 📖 About Project

**Champify** adalah aplikasi Android berbasis Flutter yang dirancang sebagai *all-in-one learning & competition platform* untuk membantu mahasiswa dan pelajar mempersiapkan diri mengikuti berbagai kompetisi akademik.

### 🎯 Main Feature

- 🔐 **Autentikasi Aman** - Login, Sign Up, dan Logout dengan Supabase Auth
- 📚 **Course Interaktif** - Materi pembelajaran terstruktur dengan video dan quiz
- 📝 **Quiz & Assessment** - Penilaian otomatis dengan review pembahasan
- 🎥 **Video Learning** - Playlist pembelajaran dengan YouTube Player
- 🎓 **Mentoring Live** - Sesi bimbingan via Zoom dengan mentor berpengalaman
- 🏆 **Info Kompetisi** - Database kompetisi akademik terkini (Ongoing, Almost Over, Closed)
- 💳 **Payment System** - Sistem pembayaran untuk paket Regular & Premium
- 👤 **User Profile** - Manajemen profil dan tracking progress belajar
- 🌗 **Dark/Light Mode** - Tema yang dapat disesuaikan

### 🌍 SDGs Contribution

Champify mendukung **SDGs Poin 4: Quality Education** dengan menyediakan akses pendidikan yang inklusif, merata, dan berkualitas untuk semua kalangan.

## 🛠️ Tech Stack

<table>
  <tr>
    <td align="center"><b>Frontend</b></td>
    <td align="center"><b>Backend</b></td>
    <td align="center"><b>Database</b></td>
    <td align="center"><b>Tools</b></td>
  </tr>
  <tr>
    <td>Flutter (Dart)</td>
    <td>Supabase</td>
    <td>PostgreSQL</td>
    <td>Git & GitHub</td>
  </tr>
  <tr>
    <td>YouTube Player</td>
    <td>Supabase Auth</td>
    <td>Row Level Security</td>
    <td>VS Code</td>
  </tr>
  <tr>
    <td>Google Nav Bar</td>
    <td>REST API</td>
    <td>Relational Tables</td>
    <td>Android Studio</td>
  </tr>
</table>

### 🏗️ Architecture

Aplikasi ini menggunakan **MVVM (Model-View-ViewModel) + Repository Pattern**:

```
┌─────────────┐
│    View     │ ← UI Layer (Screens/Widgets)
└──────┬──────┘
       │
┌──────▼──────┐
│  ViewModel  │ ← Business Logic & State Management
└──────┬──────┘
       │
┌──────▼──────┐
│ Repository  │ ← Data Layer (Single Source of Truth)
└──────┬──────┘
       │
┌──────▼──────┐
│  Supabase   │ ← Backend (Auth, Database, API)
└─────────────┘
```

## 🚀 How to Install

### Requirement

Pastikan perangkat Anda telah terpasang:

- ✅ [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi 3.0 atau lebih baru)
- ✅ Dart SDK
- ✅ Android Studio / Visual Studio Code
- ✅ Android Emulator atau perangkat Android fisik
- ✅ Git

### Installation Steps

1. **Clone Repository**

```bash
git clone https://github.com/Bagas-Rafi-Dewantara/CHAMPIFY.git
cd CHAMPIFY
```

2. **Install Dependencies**

```bash
flutter pub get
```

3. **Konfigurasi Supabase**

   - Buat project di [Supabase](https://supabase.com)
   - Salin **SUPABASE_URL** dan **SUPABASE_ANON_KEY**
   - Konfigurasi credentials di file `main.dart` atau service layer

4. **Verifikasi Environment**

```bash
flutter doctor
```

Pastikan tidak ada error sebelum melanjutkan.


## ▶️ How to Run

1. **Aktifkan Emulator/Perangkat**

Pastikan Android Emulator atau perangkat fisik sudah terhubung:

```bash
flutter devices
```

2. **Run Aplikasi**

```bash
flutter run
```

3. **Build APK (Optional)**

Untuk membuat file APK:

```bash
flutter build apk --release
```

File APK akan tersimpan di `build/app/outputs/flutter-apk/app-release.apk`


## 📁 Folder Structure

```
lib/
├── authentication/              # 🔐 Autentikasi & Onboarding
│   ├── login.dart              # Halaman login (Supabase Auth)
│   ├── signup.dart             # Form pendaftaran tahap 1
│   ├── signup2.dart            # Form pendaftaran tahap 2
│   ├── verification_page.dart  # Verifikasi akun
│   └── welcome_page.dart       # Landing page
│
├── course/                      # 📚 Modul Pembelajaran
│   ├── courses.dart            # Daftar course (Available & My Course)
│   ├── detail_course.dart      # Detail & pembelian course
│   ├── mycourse.dart           # Card navigasi My Course
│   ├── mycourse_playlist.dart  # Playlist video, quiz, Zoom
│   ├── mycourse_quiz.dart      # Halaman pengerjaan quiz
│   └── mycourse_score.dart     # Hasil & review quiz
│
├── competition.dart             # 🏆 Informasi kompetisi
├── homepage.dart                # 🏠 Dashboard utama
├── main.dart                    # 🚀 Entry point aplikasi
├── mentoring.dart               # 🎓 Detail sesi mentoring (Zoom)
├── navbar.dart                  # 📱 Bottom navigation bar
├── notification_settings.dart   # 🔔 Pengaturan notifikasi
├── payment.dart                 # 💳 Alur pembayaran course
├── privacy_policy.dart          # 📄 Kebijakan privasi
├── profile_page.dart            # 👤 Profil pengguna
├── profile_edit_page.dart       # ✏️ Edit profil
├── recommendation_settings.dart # ⚙️ Preferensi rekomendasi
├── settings.dart                # ⚙️ Pengaturan utama
├── terms_conditions.dart        # 📜 Syarat & ketentuan
└── theme_provider.dart          # 🎨 Manajemen tema (Dark/Light)
```

## 👥 Developer Team Class C Team 5

<table>
  <tr>
    <th>Nama</th>
    <th>NRP</th>
    <th>GitHub</th>
  </tr>
  <tr>
    <td>Nesha Shafwana</td>
    <td>5026231013</td>
    <td><a href="https://github.com/neshafwana30">@neshafwana30</a></td>
  </tr>
  <tr>
    <td>Arrivo Arsa Mevano</td>
    <td>5026231071</td>
    <td><a href="https://github.com/ipoyiii">@ipoyiii</a></td>
  </tr>
  <tr>
    <td>Bagas Rafi Dewantara</td>
    <td>5026231091</td>
    <td><a href="https://github.com/Bagas-Rafi-Dewantara">@Bagas-Rafi-Dewantara</a></td>
  </tr>
  <tr>
    <td>Auliya Malika Idi</td>
    <td>5026231141</td>
    <td><a href="https://github.com/Auliyaamalik">@Auliyaamalik</a></td>
  </tr>
  <tr>
    <td>Kayla Nathania Azzahra</td>
    <td>5026231151</td>
    <td><a href="https://github.com/nathaniazzr">@nathaniazzr</a></td>
  </tr>
  <tr>
    <td>Tahiyyah Mufhimah</td>
    <td>5026231170</td>
    <td><a href="https://github.com/tiamufh">@tiamufh</a></td>
  </tr>
</table>


<div align="center">
  <p><strong>✨ Be a Champion with the Right Preparation! ✨</strong></p>
</div>
