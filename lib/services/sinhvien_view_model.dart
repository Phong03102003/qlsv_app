import 'package:flutter/material.dart';

import '../models/sinh_vien.dart';
import 'sinhvien_services.dart';

class SinhVienViewModel extends ChangeNotifier {
  static final _instance = SinhVienViewModel._internal();
  factory SinhVienViewModel() => _instance;

  SinhVienViewModel._internal() {
    // Constructor
    // Load DSSV từ localstore khi ViewModel được khởi tạo
    sinhVienServices.loadItems().then((value) {
      sinhViens.clear(); // Xóa dssv cũ
      sinhViens.addAll(value); // Thêm dssv mới từ localstore
      notifyListeners(); // Thông báo đến các widget lắng nghe để cập nhật giao diện
    });
  }

  final List<SinhVien> sinhViens = []; // dssv
  final SinhVienServices sinhVienServices =
      SinhVienServices(); // đối tương sv services

  // Phương thức để thêm một sv mới
  Future addSinhVien(String hoTen, int msv, String tenLop, DateTime ngaySinh,
      String gioiTinh, String sdt, String email, String queQuan) async {
    final sinhVien = SinhVien(
      hoTen: hoTen,
      msv: msv,
      tenLop: tenLop,
      ngaySinh: ngaySinh,
      gioiTinh: gioiTinh,
      sdt: sdt,
      email: email,
      queQuan: queQuan,
    );
    sinhViens.add(sinhVien); // thêm sv vào ds
    notifyListeners();

    // Thêm sv vào localstore
    await sinhVienServices.addSinhVien(sinhVien);
    return sinhVien;
  }

  // Phương thức để xóa một sv
  Future removeSinhVien(int msv) async {
    sinhViens.removeWhere((sinhVien) => sinhVien.msv == msv); // Xóa sv khỏi ds
    notifyListeners();

    // Xóa sv khỏi localstore
    await sinhVienServices.removeSinhVien(msv);
  }

  // Phương thức để cập nhật thông tin của một sv
  Future updateSinhVien(int msv, String hoTen, String tenLop, DateTime ngaySinh,
      String gioiTinh, String sdt, String email, String queQuan) async {
    try {
      final sinhVien = sinhViens
          .firstWhere((sinhVien) => sinhVien.msv == msv); // Tìm sv cần cập nhật
      sinhVien.hoTen = hoTen; // Cập nhật thông tin sv
      sinhVien.tenLop = tenLop;
      sinhVien.ngaySinh = ngaySinh;
      sinhVien.gioiTinh = gioiTinh;
      sinhVien.sdt = sdt;
      sinhVien.email = email;
      sinhVien.queQuan = queQuan;
      notifyListeners();

      // Cập nhật thông tin sv trong localstore
      await sinhVienServices.updateSinhVien(sinhVien);
    } catch (e) {
      // Xử lý nếu không tìm thấy sv với msv tương ứng
      debugPrint("Không tìm thấy sv với msv: $msv");
    }
  }
}
