import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../lib copy/auth/methods/user_storege.dart';
import '../../../lib copy/pages/methods/post_storage.dart';
import '../../../models/user.dart';
import '../../../providers/user_provider.dart';

class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  Uint8List? _image;
  final TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;

  void selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Pick from Gallery'),
              onTap: () async {
                final file = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                Navigator.pop(context, file);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Picture'),
              onTap: () async {
                final file = await picker.pickImage(source: ImageSource.camera);
                Navigator.pop(context, file);
              },
            ),
          ],
        ),
      ),
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() => _image = bytes);
    }
  }

  void uploadPostImage(Users user) async {
    if (_image == null) return;

    setState(() => _isLoading = true);

    final result = await PostStorage().uploadPost(
      _captionController.text,
      user.uid,
      user.username,
      user.photoUrl,
      _image!,
    );

    setState(() {
      _isLoading = false;
      _image = null;
      _captionController.clear();
    });

    if (result == "Ok") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post uploaded successfully')),
      );
      Navigator.of(context).pop(); // Retour à Home
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $result')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Users user = Provider.of<UserProvider>(context).getUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Image'),
        actions: [
          TextButton(
            onPressed: () => uploadPostImage(user),
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.pinkAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Add Image',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Choose an image from your gallery or take a one.',
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _captionController,
                    decoration: const InputDecoration(
                      hintText: 'Write a caption...',
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: selectImage,
                    child: _image != null
                        ? Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: MemoryImage(_image!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.add_photo_alternate,
                              size: 50,
                            ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
