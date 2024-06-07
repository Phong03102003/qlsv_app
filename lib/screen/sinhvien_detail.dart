// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:qlsv_app/screen/update_sinhvien_screen.dart';
import 'package:qlsv_app/services/sinhvien_view_model.dart';

import '../../models/sinh_vien.dart';

class SinhVienDetailPage extends StatefulWidget {
  final SinhVien sinhVien;

  const SinhVienDetailPage({
    Key? key,
    required this.sinhVien,
  }) : super(key: key);

  @override
  State<SinhVienDetailPage> createState() => _SinhVienDetailPageState();
}

class _SinhVienDetailPageState extends State<SinhVienDetailPage> {
  final viewModel = SinhVienViewModel(); // ViewModel cho SinhVien

  // Xác nhận xóa sv
  void _deleteSinhVien(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác nhận Xóa"),
          content: const Text("Bạn có chắc chắn muốn xóa sv này không?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                viewModel.removeSinhVien(
                    widget.sinhVien.msv); // Gọi hàm xóa sv từ ViewModel
                Navigator.of(context).popUntil(
                    (route) => route.isFirst); //Quay về trang đầu tiên
              },
              child: const Text("Xóa"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sinhVien.hoTen),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateSinhVienScreen(
                      sinhVien: widget.sinhVien), // chuyển đến trang chỉnh sửa
                ), // Truyền dữ liệu của sv từ SinhVienDetailPage sang UpdateSinhVienScreen
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteSinhVien(context), // gọi hàm xóa sv
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage(
                        'https://cdn.iconscout.com/icon/free/png-256/free-account-269-866236.png'),
                  ),
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: Text(
                    widget.sinhVien.hoTen,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20.0),
                // Hiển thị các thông tin cơ bản về sv:
                // MSV, Lớp, Ngày sinh, Giới tính, Số điện thoại, Email, Quê quán
                _buildInfoRow('MSV:', widget.sinhVien.msv.toString()),
                _buildDivider(),
                _buildInfoRow('Lớp:', widget.sinhVien.tenLop),
                _buildDivider(),
                _buildInfoRow('Ngày sinh:',
                    widget.sinhVien.ngaySinh.toString().split(' ')[0]),
                _buildDivider(),
                _buildInfoRow('Giới tính:', widget.sinhVien.gioiTinh),
                _buildDivider(),
                _buildInfoRow('Số điện thoại:', widget.sinhVien.sdt.toString()),
                _buildDivider(),
                _buildInfoRow('Email:', widget.sinhVien.email),
                _buildDivider(),
                _buildInfoRow('Quê quán:', widget.sinhVien.queQuan),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget để hiển thị mỗi dòng thông tin của sv
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget để tạo đường phân cách giữa các dòng thông tin
  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[400],
    );
  }
}
