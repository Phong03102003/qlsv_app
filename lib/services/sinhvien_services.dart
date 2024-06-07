import 'package:localstore/localstore.dart';

import '../models/sinh_vien.dart';

class SinhVienServices {
  // Phương thức để tải danh sách SinhVien
  Future<List<SinhVien>> loadItems() async {
    // Tải danh sách SinhVien từ cả localstore và file JSON
    List<SinhVien> sinhViensFromLocal = await _loadItemsFromLocal();

    return sinhViensFromLocal; // Trả về danh sách kết hợp
  }

  // Future xử lý bất đồng bộ, không phải chờ đợi những tác vụ mất tgian
  // Phương thức để tải danh sách SinhVien từ localstore
  Future<List<SinhVien>> _loadItemsFromLocal() async {
    try {
      var db =
          Localstore.getInstance(useSupportDir: true); // Khởi tạo localstore
      var mapDssv =
          await db.collection('dssv').get(); // Lấy dữ liệu từ localstore

      if (mapDssv != null && mapDssv.isNotEmpty) {
        // Nếu có dữ liệu, chuyển đổi thành danh sách đối tượng SinhVien
        var dssv = mapDssv.entries
            .map<SinhVien>((e) => SinhVien.fromMap(e.value))
            .toList();
        return dssv;
      }
      return []; // Nếu không có dữ liệu, trả về danh sách trống
    } catch (e) {
      // Xử lý nếu có lỗi xảy ra khi tải dữ liệu
      print('Error loading SinhVien items from local: $e');
      return []; // Trả về danh sách trống
    }
  }

  // Thêm SV vào localstore
  Future addSinhVien(SinhVien sinhVien) async {
    var db = Localstore.getInstance(useSupportDir: true); // Khởi tạo localstore
    db
        .collection('dssv')
        .doc(sinhVien.msv.toString())
        .set(sinhVien.toMap()); // Thêm đối tượng SinhVien vào localstore
  }

  // Xóa SV khỏi localstore
  Future removeSinhVien(int msv) async {
    var db = Localstore.getInstance(useSupportDir: true); // Khởi tạo localstore
    db.collection('dssv').doc(msv.toString()).delete();
  }

  // Cập nhật thông tin SV trong localstore
  Future updateSinhVien(SinhVien sinhVien) async {
    var db = Localstore.getInstance(useSupportDir: true); // Khởi tạo localstore
    await db
        .collection('dssv')
        .doc(sinhVien.msv.toString())
        .set(sinhVien.toMap(), SetOptions(merge: true));
  }
}
