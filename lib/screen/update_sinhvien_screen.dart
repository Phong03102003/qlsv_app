import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/sinh_vien.dart';
import '../services/sinhvien_view_model.dart';

class UpdateSinhVienScreen extends StatefulWidget {
  final SinhVien sinhVien;

  const UpdateSinhVienScreen({Key? key, required this.sinhVien})
      : super(key: key);

  @override
  State<UpdateSinhVienScreen> createState() => _UpdateSinhVienScreenState();
}

class _UpdateSinhVienScreenState extends State<UpdateSinhVienScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _hoTenController = TextEditingController();
  final TextEditingController _ngaySinhController = TextEditingController();
  final TextEditingController _tenLopController = TextEditingController();
  final TextEditingController _gioiTinhController = TextEditingController();
  final TextEditingController _sdtController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _queQuanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Đặt giá trị mặc định cho các trường nhập liệu từ đối tượng sinhVien được truyền vào
    _hoTenController.text = widget.sinhVien.hoTen;
    _ngaySinhController.text =
        DateFormat('yyyy-MM-dd').format(widget.sinhVien.ngaySinh!);
    _tenLopController.text = widget.sinhVien.tenLop;
    _gioiTinhController.text = widget.sinhVien.gioiTinh;
    _sdtController.text = widget.sinhVien.sdt;
    _emailController.text = widget.sinhVien.email;
    _queQuanController.text = widget.sinhVien.queQuan;
  }

  void _submitForm() {
    // Nếu form hợp lệ, tạo đối tượng SinhVien mới với dữ liệu đã được chỉnh sửa
    if (_formKey.currentState!.validate()) {
      final updatedSinhVien = SinhVien(
        msv: widget.sinhVien.msv,
        hoTen: _hoTenController.text,
        ngaySinh: DateTime.parse(_ngaySinhController.text),
        tenLop: _tenLopController.text,
        gioiTinh: _gioiTinhController.text,
        sdt: _sdtController.text,
        email: _emailController.text,
        queQuan: _queQuanController.text,
      );
      // Gọi phương thức để cập nhật thông tin sv trong ViewModel
      SinhVienViewModel().updateSinhVien(
        widget.sinhVien.msv,
        updatedSinhVien.hoTen,
        updatedSinhVien.tenLop,
        updatedSinhVien.ngaySinh!,
        updatedSinhVien.gioiTinh,
        updatedSinhVien.sdt,
        updatedSinhVien.email,
        updatedSinhVien.queQuan,
      );
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận chỉnh sửa'),
          content: const Text('Bạn có chắc chắn muốn chỉnh sửa sv này không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                _submitForm();
                Navigator.of(context).popUntil((route) => route
                    .isFirst); // đóng tất cả các màn hình hiện đang mở và quay về màn hình đầu tiên
              },
              child: const Text('Lưu'),
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
        title: const Text('Chỉnh Sửa Sinh Viên'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _hoTenController,
                decoration: const InputDecoration(labelText: 'Họ và Tên'),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập họ và tên';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ngaySinhController,
                decoration: const InputDecoration(labelText: 'Ngày Sinh'),
                onTap: () async {
                  DateTime? date = DateTime(1900);
                  FocusScope.of(context).requestFocus(FocusNode());
                  date = await showDatePicker(
                      context: context,
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    _ngaySinhController.text =
                        DateFormat('yyyy-MM-dd').format(date);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập ngày sinh';
                  }
                  try {
                    DateFormat('yyyy-MM-dd').parse(value);
                    return null;
                  } catch (e) {
                    return 'Ngày sinh không hợp lệ';
                  }
                },
              ),
              TextFormField(
                controller: _tenLopController,
                decoration: const InputDecoration(labelText: 'Tên Lớp'),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên lớp';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _gioiTinhController,
                decoration: const InputDecoration(labelText: 'Giới Tính'),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập giới tính';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sdtController,
                decoration: const InputDecoration(labelText: 'Số Điện Thoại'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _queQuanController,
                decoration: const InputDecoration(labelText: 'Quê Quán'),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập quê quán';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _showConfirmationDialog();
                },
                child: const Text('Xác nhận'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
