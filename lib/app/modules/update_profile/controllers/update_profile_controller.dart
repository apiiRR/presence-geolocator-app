import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController nipController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storageRef = FirebaseStorage.instance.ref();
  final storage = FirebaseStorage.instance;

  final ImagePicker picker = ImagePicker();
  XFile? image;

  void pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    // if (image != null) {
    //   print(image!.name);
    //   print(image!.name.split(".").last);
    //   print(image!.path);
    // } else {
    //   print(image);
    // }

    update();
  }

  Future<void> updateProfile(String uid) async {
    if (nameController.text.isNotEmpty) {
      isLoading.value = true;
      try {
        Map<String, dynamic> data = {"nama": nameController.text};

        if (image != null) {
          // Directory appDocDir = await getApplicationDocumentsDirectory();
          // String filePath = '${appDocDir.absolute}/file-to-upload.png';
          File file = File(image!.path);
          final String ext = image!.name.split(".").last;

          final imageRef = storageRef.child("$uid/profile.$ext");
          await imageRef.putFile(file);
          final String urlImage = await imageRef.getDownloadURL();
          data.addAll({"profile": urlImage});
        }

        await firestore.collection("pegawai").doc(uid).update(data);
        image = null;
        Get.snackbar("Berhasil", "berhasil update profile");
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat update profile");
      } finally {
        isLoading.value = false;
      }
    }
  }

  void deleteProfile(String uid) async {
    try {
      await firestore
          .collection("pegawai")
          .doc(uid)
          .update({"profile": FieldValue.delete()});
      image = null;
      Get.snackbar("Berhasil", "berhasil delete profile");
      Get.back();
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Tidak dapat delete profile");
    } finally {
      update();
    }
  }
}
