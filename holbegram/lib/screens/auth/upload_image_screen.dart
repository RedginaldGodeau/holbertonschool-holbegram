import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'methods/user_storage.dart';

class AddPicture extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  const AddPicture({
    super.key,
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
  Uint8List? _image;

  void selectImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _image = bytes;
      });
    }
  }

  void selectImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _image = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Holbegram',
                style: TextStyle(
                  fontFamily: 'Billabong',
                  fontSize: 50,
                ),
              ),
              const SizedBox(height: 12),
              Image.asset(
                'assets/images/logo.png',
                width: 80,
                height: 60,
              ),
              const SizedBox(height: 20),
              const Text(
                'Hello, John Doe Welcome to Holbegram.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                'Choose an image from your gallery or take a new one.',
              ),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 64,
                backgroundImage: _image != null ? MemoryImage(_image!) : null,
                backgroundColor: Colors.grey[300],
                child: _image == null
                    ? const Icon(Icons.person, size: 64, color: Colors.black)
                    : null,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.image, color: Color(0xFFE22518)),
                    onPressed: selectImageFromGallery,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.camera_alt, color: Color(0xFFE22518)),
                    onPressed: selectImageFromCamera,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Tu pourras appeler StorageMethods ici pour uploader si besoin
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Image sélectionnée !")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE22518),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
