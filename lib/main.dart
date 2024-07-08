import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MaterialApp(home: ImagePage()));
}

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  List<File> _images = [];
  File? _selectedWidgetImage;
  final picker = ImagePicker();

  Future getImages() async {
    final pickedFiles = await picker.pickMultiImage();

    setState(() {
      _images = pickedFiles.map((file) => File(file.path)).toList();
    });
  }

  Future setWidgetImage(File image) async {
    // 공유 컨테이너 디렉토리 가져오기
    final directory = await getApplicationDocumentsDirectory();
    final appGroupDirectory = Directory('${directory.path}/../../group.imagewidget');
    if (!await appGroupDirectory.exists()) {
      await appGroupDirectory.create(recursive: true);
    }

    // 이미지를 공유 컨테이너에 저장
    final fileName = 'widget_image_${DateTime.now().millisecondsSinceEpoch}.png';
    final savedImage = await image.copy('${appGroupDirectory.path}/$fileName');

    // 위젯 데이터 업데이트
    WidgetKit.setItem(
      'widgetData',
      jsonEncode(WidgetData(
        imagePath: savedImage.path,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      )),
      'group.imagewidget',
    );

    // 모든 위젯 타임라인 갱신
    WidgetKit.reloadAllTimelines();

    setState(() {
      _selectedWidgetImage = image;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('위젯 이미지가 설정되었습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Widget Demo'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: _images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => setWidgetImage(_images[index]),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(
                  _images[index],
                  fit: BoxFit.cover,
                ),
                if (_selectedWidgetImage == _images[index])
                  const Positioned(
                    top: 5,
                    right: 5,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImages,
        child: const Icon(Icons.add_photo_alternate),
      ),
    );
  }
}

class WidgetData {
  final String imagePath;
  final int timestamp;
  WidgetData({required this.imagePath, required this.timestamp});

  WidgetData.fromJson(Map<String, dynamic> json)
      : imagePath = json['imagePath'],
        timestamp = json['timestamp'];

  Map<String, dynamic> toJson() => {
    'imagePath': imagePath,
    'timestamp': timestamp
  };
}