import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Để sử dụng DateFormat

import '../../models/sinh_vien.dart';
import '../services/sinhvien_view_model.dart';

class AddSinhVienForm extends StatefulWidget {
  const AddSinhVienForm({super.key});

  @override
  State<AddSinhVienForm> createState() => _AddSinhVienFormState();
}

class _AddSinhVienFormState extends State<AddSinhVienForm> {
  final _formKey = GlobalKey<
      FormState>(); // Khởi tạo GlobalKey cho Form, truy cập và thực hiện các phương thức của Form

  // Khai báo các TextEditingController cho từng trường nhập
  final TextEditingController _msvController = TextEditingController();
  final TextEditingController _hoTenController = TextEditingController();
  final TextEditingController _ngaySinhController = TextEditingController();
  final TextEditingController _tenLopController = TextEditingController();
  final TextEditingController _gioiTinhController = TextEditingController();
  final TextEditingController _sdtController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _queQuanController = TextEditingController();

  // Phương thức để xử lý khi form được submit
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Lấy dữ liệu từ các trường nhập và tạo một đối tượng SinhVien
      final newSinhVien = SinhVien(
        msv: int.parse(_msvController.text),
        hoTen: _hoTenController.text,
        ngaySinh: DateTime.parse(_ngaySinhController.text),
        tenLop: _tenLopController.text,
        gioiTinh: _gioiTinhController.text,
        sdt: _sdtController.text,
        email: _emailController.text,
        queQuan: _queQuanController.text,
      );

      // Thêm sv vào ds và cập nhật view model
      SinhVienViewModel().addSinhVien(
        newSinhVien.hoTen,
        newSinhVien.msv,
        newSinhVien.tenLop,
        newSinhVien.ngaySinh!,
        newSinhVien.gioiTinh,
        newSinhVien.sdt,
        newSinhVien.email,
        newSinhVien.queQuan,
      );

      // Đóng form sau khi thêm sv thành công
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Sinh Viên'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Gán GlobalKey cho Form
          child: ListView(
            children: [
              // Các trường nhập dữ liệu cho SinhVien
              TextFormField(
                controller: _msvController,
                decoration:
                    const InputDecoration(labelText: 'Mã Sinh Viên'), // Mô tả
                keyboardType: TextInputType.number, // Loại bàn phím
                validator: (value) {
                  // Hàm kiểm tra tính hợp lệ của dữ liệu nhập vào
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mã sv';
                  }
                  return null;
                },
              ),
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
                controller:
                    _ngaySinhController, // Controller để quản lý dữ liệu của trường nhập
                decoration:
                    const InputDecoration(labelText: 'Ngày Sinh'), // Mô tả
                onTap: () async {
                  // Khi trường nhập được chạm vào, mở DatePicker để chọn ngày sinh
                  DateTime? date =
                      DateTime(1900); // Khởi tạo giá trị mặc định cho ngày sinh
                  FocusScope.of(context).requestFocus(
                      FocusNode()); // Ẩn bàn phím khi mở DatePicker
                  date = await showDatePicker(
                    context: context,
                    initialEntryMode: DatePickerEntryMode
                        .calendarOnly, // Chế độ lịch hiển thị ban đầu
                    firstDate: DateTime(1900), // Ngày đầu tiên có thể chọn
                    lastDate: DateTime(2100), // Ngày cuối cùng có thể chọn
                  );
                  if (date != null) {
                    // Nếu ngày được chọn, cập nhật giá trị vào trường nhập
                    _ngaySinhController.text =
                        DateFormat('yyyy-MM-dd').format(date);
                  }
                },
                validator: (value) {
                  // Hàm kiểm tra tính hợp lệ của dữ liệu nhập vào
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập ngày sinh';
                  }
                  try {
                    DateFormat('yyyy-MM-dd').parse(
                        value); // Kiểm tra xem ngày có đúng định dạng không
                    return null;
                  } catch (e) {
                    return 'Ngày sinh không hợp lệ';
                  }
                },
              ),

              TextFormField(
                controller: _tenLopController,
                decoration:
                    const InputDecoration(labelText: 'Tên Lớp'), // Mô tả
                keyboardType: TextInputType.text, // Loại bàn phím
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên lớp';
                  }
                  return null;
                }, //Kiểm tra nhập dữ liệu có đúng định dạng ko
              ),
              TextFormField(
                controller: _gioiTinhController,
                decoration: const InputDecoration(labelText: 'Giới Tính'),
                keyboardType: TextInputType.text, // Loại bàn phím
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập giới tính';
                  }
                  return null;
                }, //Kiểm tra nhập dữ liệu có đúng định dạng ko
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
                }, //Kiểm tra nhập dữ liệu có đúng định dạng ko
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
                }, //Kiểm tra nhập dữ liệu có đúng định dạng ko
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
                onPressed: _submitForm, // thực thi
                child: const Text('Thêm Sinh Viên'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
