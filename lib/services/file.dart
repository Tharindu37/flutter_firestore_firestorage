import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FileService {
  // Upload Files to Storage
  // Future<void> uploadFile(
  //   Uint8List filePath,
  //   String fileName,
  // ) async {
  //   try {
  //     await FirebaseStorage.instance.ref().child(fileName).putData(filePath);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Get the Download URL
  // Future<String> getDownloadURL(String fileName) async {
  //   try {
  //     return await FirebaseStorage.instance
  //         .ref()
  //         .child(fileName)
  //         .getDownloadURL();
  //   } catch (e) {
  //     return "";
  //   }
  // }

  // Delete the file
  // Future<void> deleteFile(String fileName) async {
  //   try {
  //     await FirebaseStorage.instance.ref().child(fileName).delete();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

// import 'dart:typed_data';

// import 'package:firebase_storage/firebase_storage.dart';

// class StorageService {
//   Future<void> uploadFile(
//     Uint8List filePath,
//     String fileName,
//   ) async {
//     try {
//       await FirebaseStorage.instance.ref().child(fileName).putData(filePath);
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<String> getDownloadURL(String fileName) async {
//     try {
//       return await FirebaseStorage.instance
//           .ref()
//           .child(fileName)
//           .getDownloadURL();
//     } catch (e) {
//       return "";
//     }
//   }

//   Future<void> deleteFile(String fileName) async {
//     try {
//       await FirebaseStorage.instance.ref().child(fileName).delete();
//     } catch (e) {
//       print(e);
//     }
//   }
// }

  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Future<String> uploadFile(File file, String path) async {
  //   print('service, $file');
  //   try {
  //     // Upload the file to the specified path in Firebase Storage
  //     UploadTask uploadTask = _storage.ref().child(path).putFile(file);

  //     // Wait for the upload to complete
  //     TaskSnapshot snapshot = await uploadTask;

  //     // Get the download URL of the uploaded file
  //     String downloadUrl = await snapshot.ref.getDownloadURL();
  //     print('download Url: $downloadUrl');

  //     return downloadUrl;
  //   } catch (e) {
  //     // Handle any errors
  //     print("File upload failed: $e");
  //     throw e;
  //   }
  // }

  Future<String> uploadFile(File file, String path) async {
    try {
      // Create a reference to the desired location in Firebase Storage
      Reference ref = FirebaseStorage.instance.ref(path);
      print(ref);

      // Upload the file
      UploadTask uploadTask = ref.putFile(file);

      // Wait for the upload to complete
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL of the uploaded file
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Error uploading file: $e');
      // Consider rethrowing the error or returning a specific error message
      rethrow; // Or return 'error';
    }
  }

  Future<void> deleteFileByDownloadUrl(String downloadURL) async {
    try {
      // Extract the path from the download URL
      final RegExp regex = RegExp(r'\/o\/(.+)\?alt=');
      final RegExpMatch? match = regex.firstMatch(downloadURL);

      if (match != null && match.groupCount > 0) {
        final String? path = Uri.decodeFull(match.group(1)!);

        // Create a reference to the file in Firebase Storage
        Reference ref = FirebaseStorage.instance.ref().child(path!);

        // Delete the file
        await ref.delete();

        print('File deleted successfully');
      } else {
        print('Error: Invalid download URL');
      }
    } catch (e) {
      print('Error deleting file: $e');
      rethrow; // Rethrow the error or handle it as needed
    }
  }
}
