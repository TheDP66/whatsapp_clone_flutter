import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseStorageRepositoryProvider = Provider(
  (ref) => FirebaseStorageRepository(
    firebaseStorage: FirebaseStorage.instance,
  ),
);

class FirebaseStorageRepository {
  FirebaseStorageRepository({required this.firebaseStorage});

  final FirebaseStorage firebaseStorage;

  storeFileToFirebase(String ref, var file) async {
    UploadTask? uploadTask;

    if (file is File) {
      uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    }

    if (file is Uint8List) {
      uploadTask = firebaseStorage.ref().child(ref).putData(file);
    }

    TaskSnapshot snapshot = await uploadTask!;
    String imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }
}
