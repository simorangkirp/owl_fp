import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          // Global
          'hello': 'Hello World',
          'seeAll': 'Show All',
          'setting': 'Settings',
          'chsOpt': 'Choose Options',
          'send': 'Send',
          'register': 'Register',
          'delete': 'Delete',
          'sync': 'Synchronize',
          'lastSync': 'Last Synchronize',
          'masterdataSync': 'Synchronize Master Data',
          'language': 'Language',
          'theme': 'Theme',
          'others': 'Others',
          'aboutApp': 'About',
          'help': 'Help',
          'darkmode': 'Dark Mode',
          'signIn': 'Sign In',
          'signOut': 'Sign Out',
          'confirm': 'Confirm',
          'cancel': 'Cancel',
          'auth': 'Authentication',
          'plSlcOpt': 'Please select an option',
          'notFound': 'Not Found',
          'minute': 'Minute',
          'ltsVer': 'Check Latest Version',

          // Appbar
          'appbarFingerSetting': 'Fingerprint Settings',
          'appbarProfile': 'Profile',
          'appbarChgUser': 'Change Other User',
          'templateList': 'Template List',
          'appbarAboutApp': 'About Application',

          // Profile
          'username': 'User Name',
          'password': 'Password',
          'location': 'Location',
          'unitnsub': 'Unit & Sub-unit',
          'position': 'Position',
          'name': 'Name',
          'unit': 'Unit',
          'division': 'Division',
          'emplNm': 'Employee Name',
          'selectLang': 'Select Language',
          'chOthrUser': 'Switch to other user',

          // Dialog
          'syncMstDataDialogBody':
              'Are you sure you want to synchronize Master Data?',
          'inputPassword': 'Insert Password!',

          // Bluetooth
          'btConnection': 'Bluetooth Connection',
          'deviceInfo': 'Device Info',
          'fingerList': 'Fingerprint List',
          'rndFinger': 'Register & Delete Fingerprints',
          'undFinger': 'Download & Upload Template Fingerprints',
          'privilege': 'Privilege',
          'stScan': 'Start Scan',
          'scanning': 'Scanning',
          'chsHour': 'Choose Time',
          'chsDt': 'Choose Date',
          'oldPin': 'Old PIN',
          'newPin': 'New PIN',
          'confirmPin': 'Confirm PIN',
          'idMachine': 'Machine ID',
          'productNm': 'Product Name',
          'softwareVer': 'Software Version',
          'macAdr': 'Mac Address',
          'downFirm': 'Download Firmware',
          'sendTemptoServer': 'Send Template to Server',
          'resetFinger': 'Reset Fingerprint',
          'resetMobileApp': 'Reset Mobile Application',
          'chooseEmply': 'Choose Employee',
          'findEmply': 'Find Employee',
          'addPriv': 'Add Privilage',
          'sendTemptoServerDialog':
              'This action will send all data\nin the application to the server.',
          'resetFingerDialog':
              'This action will erase all data and\nsettings on the device.\nThis action cannot be undone',
          'resetMobileDialog':
              'This action will erase all data\non mobile application.\nThis action cannot be undone',
        },
        'id_ID': {
          // Global
          'hello': 'Halo Dunia',
          'seeAll': 'Lihat Semua',
          'setting': 'Pengaturan',
          'chsOpt': 'Pilih Menu',
          'send': 'Kirim',
          'register': 'Daftar',
          'delete': 'Hapus',
          'sync': 'Synchronize',
          'lastSync': 'Sinkronisasi Terakhir',
          'masterdataSync': 'Sinkron Master Data',
          'language': 'Bahasa',
          'theme': 'Tema',
          'others': 'Lainnya',
          'aboutApp': 'Tentang Aplikasi',
          'help': 'Bantuan',
          'darkmode': 'Mode Malam',
          'signIn': 'Masuk',
          'signOut': 'Keluar',
          'confirm': 'Ya',
          'cancel': 'Batal',
          'auth': 'Otentikasi',
          'plSlcOpt': 'Silahkan pilih opsi',
          'notFound': 'Tidak Ditemukan',
          'minute': 'Menit',
          'ltsVer': 'Cek Versi Terbaru',

          // Appbar
          'appbarFingerSetting': 'Pengaturan Fingerprint',
          'appbarProfile': 'Profil',
          'appbarChgUser': 'Ubah Pengguna Lain',
          'templateList': 'Daftar Template',
          'appbarAboutApp': 'Tentang Aplikasi',

          // Profile
          'username': 'Nama Pengguna',
          'password': 'Sandi',
          'location': 'Lokasi',
          'unitnsub': 'Unit & Bagian',
          'position': 'Posisi',
          'name': 'Nama',
          'unit': 'Unit',
          'division': 'Divisi',
          'emplNm': 'Nama Karyawan',
          'selectLang': 'Pilih Bahasa',
          'chOthrUser': 'Ubah pengguna lain',

          // Dialog
          'syncMstDataDialogBody':
              'Apa anda yakin mau sinkroniasai Master Data?',
          'inputPassword': 'Masukkan Sandi!',

          // Bluetooth
          'btConnection': 'Koneksi Bluetooth',
          'deviceInfo': 'Informasi Perangkat',
          'fingerList': 'Daftar Fingerprint',
          'rndFinger': 'Daftar & Hapus Sidik Jari',
          'undFinger': 'Unduh & Kirim Template Sidik Jari',
          'privilege': 'Hak Istimewa',
          'stScan': 'Mulai Pindai',
          'scanning': 'Memindai',
          'chsHour': 'Pilih Jam',
          'chsDt': 'Pilih Tanggal',
          'oldPin': 'PIN Lama',
          'newPin': 'PIN Baru',
          'confirmPin': 'Konfirmasi PIN',
          'idMachine': 'ID Mesin',
          'productNm': 'Nama Produk',
          'softwareVer': 'Versi Software',
          'macAdr': 'Alamat Mac',
          'downFirm': 'Unduh Firmware',
          'sendTemptoServer': 'Kirim Template ke Server',
          'resetFinger': 'Setel Ulang Perangkat',
          'resetMobileApp': 'Setel Ulang Aplikasi Mobile',
          'chooseEmply': 'Pilih Karyawan',
          'findEmply': 'Cari Karyawan',
          'addPriv': 'Tambah Hak Akses',
          'sendTemptoServerDialog':
              'Aksi ini akan mengirim semua template\nyang ada di aplikasi mobile ke server.',
          'resetFingerDialog':
              'Aksi ini akan menghapus seluruh data dan pengaturan pada alat Fingerprint.\nAksi ini tidak dapat dibatalkan',
          'resetMobileDialog':
              'Aksi ini akan menghapus seluruh data yang ada pada aplikasi mobile.\nAksi ini tidak dapat dibatalkan',
        },
      };
}
