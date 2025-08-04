import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../auth/methods/user_storage.dart'; // Assure-toi que ce chemin est correct

class PostStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String caption,
    String uid,
    String username,
    String profImage,
    Uint8List image,
  ) async {
    try {
      String postId = const Uuid().v4();

      // Upload de l'image sur Cloudinary
      final cloudinaryUrl = await uploadImageToCloudinary(image);
      if (cloudinaryUrl == null) return 'Image upload failed';

      await _firestore.collection('posts').doc(postId).set({
        'caption': caption,
        'uid': uid,
        'username': username,
        'likes': [],
        'postId': postId,
        'datePublished': DateTime.now().toIso8601String(),
        'postUrl': cloudinaryUrl['secure_url'],
        'public_id': cloudinaryUrl['public_id'],
        'profImage': profImage,
      });

      return "Ok";
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> deletePost(String postId, String publicId) async {
    try {
      // Supprimer le post dans Firestore
      await _firestore.collection('posts').doc(postId).delete();

      // Optionnel : supprimer l'image de Cloudinary (si tu as l'API setup)
      // À faire si tu as une méthode deleteCloudinaryImage(publicId)
    } catch (e) {
      print('Erreur suppression post: $e');
    }
  }
}
