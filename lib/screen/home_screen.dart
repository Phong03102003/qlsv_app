import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlsv_app/screen/add_sinhvien_screen.dart';

import '../../models/sinh_vien.dart';
import '../services/sinhvien_view_model.dart';
import 'sinhvien_detail.dart';

// Widget hiển thị danh sách sv
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _searchController;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _importFromJson() async {
    // Sử dụng file picker để chọn file JSON
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String jsonString = await file.readAsString();
      List<dynamic> jsonResponse = jsonDecode(jsonString);

      // Cập nhật dữ liệu vào ViewModel
      // ignore: use_build_context_synchronously
      final viewModel = Provider.of<SinhVienViewModel>(context, listen: false);

      for (var json in jsonResponse) {
        final sinhVien = SinhVien.fromJson(json);
        await viewModel.addSinhVien(
          sinhVien.hoTen,
          sinhVien.msv,
          sinhVien.tenLop,
          sinhVien.ngaySinh!,
          sinhVien.gioiTinh,
          sinhVien.sdt,
          sinhVien.email,
          sinhVien.queQuan,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            border:
                Border.all(color: Colors.grey), // Màu sắc và độ dày của border
            borderRadius: BorderRadius.circular(10.0), // Độ cong của border
          ),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Tìm kiếm theo tên hoặc msv hoặc lớp',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.0), // Padding cho nội dung trong ô tìm kiếm
            ),
            onChanged: (value) {
              setState(() {
                _searchText = value; // Cập nhật giá trị tìm kiếm
              });
            },
          ),
        ),
      ),
      // Sử dụng Consumer để lắng nghe và phản ứng với các thay đổi trong SinhVienViewModel
      body: Consumer<SinhVienViewModel>(
        builder: (context, viewModel, child) {
          final filteredSinhViens = _searchText.isEmpty
              ? viewModel.sinhViens
              : viewModel.sinhViens.where((sinhVien) {
                  final searchTextLower = _searchText.toLowerCase();
                  // Lọc danh sách sv dựa trên giá trị tìm kiếm
                  return sinhVien.hoTen
                          .toLowerCase()
                          .contains(searchTextLower) ||
                      sinhVien.msv.toString().contains(_searchText) ||
                      sinhVien.tenLop.toLowerCase().contains(searchTextLower);
                }).toList();

          return ListView.builder(
            itemCount: filteredSinhViens.length,
            itemBuilder: (context, index) {
              final sinhVien = filteredSinhViens[index];
              return SinhVienCard(
                  sinhVien: sinhVien); // Hiển thị mỗi sv dưới dạng card
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddSinhVienForm(),
                ),
              );
            },
            heroTag: "btnAdd", // Xác định tag cho hiệu ứng hero animation
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _importFromJson,
            heroTag: "btnUpload", // Xác định tag cho hiệu ứng hero animation
            child: const Icon(Icons.file_upload),
          ),
        ],
      ),
    );
  }
}

// Widget hiển thị thông tin sv dưới dạng thẻ
class SinhVienCard extends StatelessWidget {
  final SinhVien sinhVien;

  const SinhVienCard({super.key, required this.sinhVien});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          // Chuyển đến trang chi tiết của sv khi nhấp vào thẻ
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SinhVienDetailPage(sinhVien: sinhVien),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sinhVien.hoTen,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.confirmation_number,
                        color: Colors.blue, // Màu sắc xanh cho icon và chữ
                      ),
                      const SizedBox(width: 8), // Khoảng cách giữa icon và chữ
                      Text(
                        'MSV: ${sinhVien.msv}',
                        style: const TextStyle(
                            color: Colors.blue), // Màu sắc xanh cho icon và chữ
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: Colors.blue, // Màu sắc xanh cho icon và chữ
                      ),
                      const SizedBox(width: 8), // Khoảng cách giữa icon và chữ
                      Text(
                        'Giới tính: ${sinhVien.gioiTinh}',
                        style: const TextStyle(
                            color: Colors.blue), // Màu sắc xanh cho icon và chữ
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.phone,
                        color: Colors.blue, // Màu sắc xanh cho icon và chữ
                      ),
                      const SizedBox(width: 8), // Khoảng cách giữa icon và chữ
                      Text(
                        'SĐT: ${sinhVien.sdt}',
                        style: const TextStyle(
                            color: Colors.blue), // Màu sắc xanh cho icon và chữ
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.school,
                        color: Colors.blue, // Màu sắc xanh cho icon và chữ
                      ),
                      const SizedBox(width: 8), // Khoảng cách giữa icon và chữ
                      Text(
                        'Lớp: ${sinhVien.tenLop}',
                        style: const TextStyle(
                            color: Colors.blue), // Màu sắc xanh cho icon và chữ
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
