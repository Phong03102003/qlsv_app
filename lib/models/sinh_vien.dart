class SinhVien {
  // Các thuộc tính của lớp SinhVien
  int msv;
  String hoTen;
  DateTime? ngaySinh;
  String tenLop;
  String gioiTinh;
  String sdt;
  String email;
  String queQuan;

  // Constructor để khởi tạo đối tượng SinhVien
  // required bắt buộc cung cấp giá trị cho các tham số
  SinhVien({
    required this.msv,
    required this.hoTen,
    required this.ngaySinh,
    required this.tenLop,
    required this.gioiTinh,
    required this.sdt,
    required this.email,
    required this.queQuan,
  });

  // Phương thức để chuyển đổi đối tượng SinhVien thành Map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'msv': msv,
      'hoTen': hoTen,
      'ngaySinh': ngaySinh?.millisecondsSinceEpoch,
      'tenLop': tenLop,
      'gioiTinh': gioiTinh,
      'sdt': sdt,
      'email': email,
      'queQuan': queQuan,
    };
  }

  // Factory constructor để tạo đối tượng SinhVien từ Map
  // as ép kiểu
  factory SinhVien.fromMap(Map<String, dynamic> map) {
    return SinhVien(
      msv: map['msv'] as int,
      hoTen: map['hoTen'] as String,
      ngaySinh: map['ngaySinh'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['ngaySinh'] as int)
          : null,
      tenLop: map['tenLop'] as String,
      gioiTinh: map['gioiTinh'] as String,
      sdt: map['sdt'] as String,
      email: map['email'] as String,
      queQuan: map['queQuan'] as String,
    );
  }
  // Phương thức fromJson để chuyển đổi từ JSON thành SinhVien
  factory SinhVien.fromJson(Map<String, dynamic> json) {
    return SinhVien(
      msv: json['msv'],
      hoTen: json['hoTen'],
      ngaySinh: DateTime.parse(json['ngaySinh']),
      tenLop: json['tenLop'],
      gioiTinh: json['gioiTinh'],
      sdt: json['sdt'],
      email: json['email'],
      queQuan: json['queQuan'],
    );
  }
}
