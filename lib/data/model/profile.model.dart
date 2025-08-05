import 'package:equatable/equatable.dart';
import 'package:owl_fp/domain/entity/profile.entity.dart';

class ProfileModel extends Equatable {
  const ProfileModel({
    required this.name,
    required this.sex,
    required this.birthday,
    required this.birthplace,
    required this.address,
    required this.noktp,
    required this.nopaspor,
    required this.nationality,
    required this.religion,
    required this.statusperkawinan,
    required this.kodejabatan,
    required this.jabatan,
    required this.bagian,
    required this.tipekaryawan,
    required this.kodeorganisasi,
    required this.namaorganisasi,
    required this.lokasitugas,
    required this.tipelokasitugas,
    required this.subbagian,
    required this.kodeorganisasiTemp,
    required this.namaorganisasiTemp,
    required this.lokasitugasTemp,
    required this.tipelokasitugasTemp,
    required this.subbagianTemp,
    required this.poh,
    required this.signdate,
    required this.resigndate,
    required this.sistemgaji,
    required this.email,
    required this.phone,
    required this.regional,
  });

  final String? name;
  final String? sex;
  final String? birthday;
  final String? birthplace;
  final String? address;
  final String? noktp;
  final String? nopaspor;
  final String? nationality;
  final String? religion;
  final String? statusperkawinan;
  final String? kodejabatan;
  final String? jabatan;
  final String? bagian;
  final String? tipekaryawan;
  final String? kodeorganisasi;
  final String? namaorganisasi;
  final String? lokasitugas;
  final String? tipelokasitugas;
  final String? subbagian;
  final String? kodeorganisasiTemp;
  final String? namaorganisasiTemp;
  final String? lokasitugasTemp;
  final String? tipelokasitugasTemp;
  final String? subbagianTemp;
  final String? poh;
  final String? signdate;
  final String? resigndate;
  final String? sistemgaji;
  final String? email;
  final String? phone;
  final String? regional;

  ProfileModel copyWith({
    String? name,
    String? sex,
    String? birthday,
    String? birthplace,
    String? address,
    String? noktp,
    String? nopaspor,
    String? nationality,
    String? religion,
    String? statusperkawinan,
    String? kodejabatan,
    String? jabatan,
    String? bagian,
    String? tipekaryawan,
    String? kodeorganisasi,
    String? namaorganisasi,
    String? lokasitugas,
    String? tipelokasitugas,
    String? subbagian,
    String? kodeorganisasiTemp,
    String? namaorganisasiTemp,
    String? lokasitugasTemp,
    String? tipelokasitugasTemp,
    String? subbagianTemp,
    String? poh,
    String? signdate,
    String? resigndate,
    String? sistemgaji,
    String? email,
    String? phone,
    String? regional,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      sex: sex ?? this.sex,
      birthday: birthday ?? this.birthday,
      birthplace: birthplace ?? this.birthplace,
      address: address ?? this.address,
      noktp: noktp ?? this.noktp,
      nopaspor: nopaspor ?? this.nopaspor,
      nationality: nationality ?? this.nationality,
      religion: religion ?? this.religion,
      statusperkawinan: statusperkawinan ?? this.statusperkawinan,
      kodejabatan: kodejabatan ?? this.kodejabatan,
      jabatan: jabatan ?? this.jabatan,
      bagian: bagian ?? this.bagian,
      tipekaryawan: tipekaryawan ?? this.tipekaryawan,
      kodeorganisasi: kodeorganisasi ?? this.kodeorganisasi,
      namaorganisasi: namaorganisasi ?? this.namaorganisasi,
      lokasitugas: lokasitugas ?? this.lokasitugas,
      tipelokasitugas: tipelokasitugas ?? this.tipelokasitugas,
      subbagian: subbagian ?? this.subbagian,
      kodeorganisasiTemp: kodeorganisasiTemp ?? this.kodeorganisasiTemp,
      namaorganisasiTemp: namaorganisasiTemp ?? this.namaorganisasiTemp,
      lokasitugasTemp: lokasitugasTemp ?? this.lokasitugasTemp,
      tipelokasitugasTemp: tipelokasitugasTemp ?? this.tipelokasitugasTemp,
      subbagianTemp: subbagianTemp ?? this.subbagianTemp,
      poh: poh ?? this.poh,
      signdate: signdate ?? this.signdate,
      resigndate: resigndate ?? this.resigndate,
      sistemgaji: sistemgaji ?? this.sistemgaji,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      regional: regional ?? this.regional,
    );
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json["name"],
      sex: json["sex"],
      birthday: json["birthday"] ?? "",
      birthplace: json["birthplace"],
      address: json["address"],
      noktp: json["noktp"],
      nopaspor: json["nopaspor"],
      nationality: json["nationality"],
      religion: json["religion"],
      statusperkawinan: json["statusperkawinan"],
      kodejabatan: json["kodejabatan"],
      jabatan: json["jabatan"],
      bagian: json["bagian"],
      tipekaryawan: json["tipekaryawan"],
      kodeorganisasi: json["kodeorganisasi"],
      namaorganisasi: json["namaorganisasi"],
      lokasitugas: json["lokasitugas"],
      tipelokasitugas: json["tipelokasitugas"],
      subbagian: json["subbagian"],
      kodeorganisasiTemp: json["kodeorganisasi_temp"],
      namaorganisasiTemp: json["namaorganisasi_temp"],
      lokasitugasTemp: json["lokasitugas_temp"],
      tipelokasitugasTemp: json["tipelokasitugas_temp"],
      subbagianTemp: json["subbagian_temp"],
      poh: json["poh"],
      signdate: json["signdate"] ?? "",
      resigndate: json["resigndate"],
      sistemgaji: json["sistemgaji"],
      email: json["email"],
      phone: json["phone"],
      regional: json["regional"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "sex": sex,
        "birthday": birthday,
        "birthplace": birthplace,
        "address": address,
        "noktp": noktp,
        "nopaspor": nopaspor,
        "nationality": nationality,
        "religion": religion,
        "statusperkawinan": statusperkawinan,
        "kodejabatan": kodejabatan,
        "jabatan": jabatan,
        "bagian": bagian,
        "tipekaryawan": tipekaryawan,
        "kodeorganisasi": kodeorganisasi,
        "namaorganisasi": namaorganisasi,
        "lokasitugas": lokasitugas,
        "tipelokasitugas": tipelokasitugas,
        "subbagian": subbagian,
        "kodeorganisasi_temp": kodeorganisasiTemp,
        "namaorganisasi_temp": namaorganisasiTemp,
        "lokasitugas_temp": lokasitugasTemp,
        "tipelokasitugas_temp": tipelokasitugasTemp,
        "subbagian_temp": subbagianTemp,
        "poh": poh,
        "signdate": signdate,
        "resigndate": resigndate,
        "sistemgaji": sistemgaji,
        "email": email,
        "phone": phone,
        "regional": regional,
      };

  factory ProfileModel.fromEntity(ProfileEntity empl) => ProfileModel(
        name: empl.name,
        sex: empl.sex,
        birthday: empl.birthday,
        birthplace: empl.birthplace,
        address: empl.address,
        noktp: empl.noktp,
        nopaspor: empl.nopaspor,
        nationality: empl.nationality,
        religion: empl.religion,
        statusperkawinan: empl.statusperkawinan,
        kodejabatan: empl.kodejabatan,
        jabatan: empl.jabatan,
        bagian: empl.bagian,
        tipekaryawan: empl.tipekaryawan,
        kodeorganisasi: empl.kodeorganisasi,
        namaorganisasi: empl.namaorganisasi,
        lokasitugas: empl.lokasitugas,
        tipelokasitugas: empl.tipelokasitugas,
        subbagian: empl.subbagian,
        kodeorganisasiTemp: empl.kodeorganisasiTemp,
        namaorganisasiTemp: empl.namaorganisasiTemp,
        lokasitugasTemp: empl.lokasitugasTemp,
        tipelokasitugasTemp: empl.tipelokasitugasTemp,
        subbagianTemp: empl.subbagianTemp,
        poh: empl.poh,
        signdate: empl.signdate,
        resigndate: empl.resigndate,
        sistemgaji: empl.sistemgaji,
        email: empl.email,
        phone: empl.phone,
        regional: empl.regional,
      );

  ProfileEntity toEntity() => ProfileEntity(
        name: name,
        sex: sex,
        birthday: birthday,
        birthplace: birthplace,
        address: address,
        noktp: noktp,
        nopaspor: nopaspor,
        nationality: nationality,
        religion: religion,
        statusperkawinan: statusperkawinan,
        kodejabatan: kodejabatan,
        jabatan: jabatan,
        bagian: bagian,
        tipekaryawan: tipekaryawan,
        kodeorganisasi: kodeorganisasi,
        namaorganisasi: namaorganisasi,
        lokasitugas: lokasitugas,
        tipelokasitugas: tipelokasitugas,
        subbagian: subbagian,
        kodeorganisasiTemp: kodeorganisasiTemp,
        namaorganisasiTemp: namaorganisasiTemp,
        lokasitugasTemp: lokasitugasTemp,
        tipelokasitugasTemp: tipelokasitugasTemp,
        subbagianTemp: subbagianTemp,
        poh: poh,
        signdate: signdate,
        resigndate: resigndate,
        sistemgaji: sistemgaji,
        email: email,
        phone: phone,
        regional: regional,
      );

  @override
  List<Object?> get props => [
        name,
        sex,
        birthday,
        birthplace,
        address,
        noktp,
        nopaspor,
        nationality,
        religion,
        statusperkawinan,
        kodejabatan,
        jabatan,
        bagian,
        tipekaryawan,
        kodeorganisasi,
        namaorganisasi,
        lokasitugas,
        tipelokasitugas,
        subbagian,
        kodeorganisasiTemp,
        namaorganisasiTemp,
        lokasitugasTemp,
        tipelokasitugasTemp,
        subbagianTemp,
        poh,
        signdate,
        resigndate,
        sistemgaji,
        email,
        phone,
        regional,
      ];
}
