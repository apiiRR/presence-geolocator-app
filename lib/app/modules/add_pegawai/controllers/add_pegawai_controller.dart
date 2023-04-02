import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPegawaiController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController nipController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordAdminController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prosesAddPegawai() async {
    if (passwordAdminController.text.isNotEmpty) {
      try {
        final String emailAdmin = auth.currentUser!.email!;
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: emailAdmin, password: passwordAdminController.text);

        final pegawaiCredential = await auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: "password",
        );

        if (pegawaiCredential.user != null) {
          String uid = pegawaiCredential.user!.uid;

          FirebaseFirestore.instance.collection("pegawai").doc(uid).set({
            "nip": nipController.text,
            "nama": nameController.text,
            "email": emailController.text,
            "job": jobController.text,
            "uid": uid,
            "role": "pegawai",
            "createdAt": DateTime.now().toIso8601String()
          });

          await pegawaiCredential.user!.sendEmailVerification();
          await auth.signOut();

          await auth.signInWithEmailAndPassword(
              email: emailAdmin, password: passwordAdminController.text);

          Get.back();
          Get.back();
          Get.snackbar("Berhasil", "Berhasil menambahkan pegawai");
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar(
              "Terjadi Kesalahan", "Password yang digunakan terlalu lemah");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Terjadi Kesalahan",
              "Pegawai sudah ada, anda tidak dapat menambahkan pegawai dengan email yang sama");
        } else if (e.code == 'wrong-password') {
          Get.snackbar(
              "Terjadi Kesalahan", "Password yang dimasukkan tidak valid!");
        } else {
          Get.snackbar("Terjadi Kesalahan", e.code);
        }
      } catch (e) {
        print(e);
      }
    } else {
      Get.snackbar(
          "Terjadi Kesalahan", "Password wajib diisi untuk keperluan validasi");
    }
  }

  void addPegawai() async {
    if (nameController.text.isNotEmpty &&
        jobController.text.isNotEmpty &&
        nipController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      Get.defaultDialog(
          title: "Validasi Akun",
          content: Column(
            children: [
              const Text("Masukkan password untuk validasi admin"),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: passwordAdminController,
                autocorrect: false,
                obscureText: true,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ],
          ),
          actions: [
            OutlinedButton(
                onPressed: () => Get.back(), child: const Text("CANCEL")),
            ElevatedButton(
                onPressed: () async {
                  await prosesAddPegawai();
                },
                child: const Text("ADD PEGAWAI"))
          ]);
    } else {
      Get.snackbar("Terjadi Kesalahan", "NIP, Nama, Job dan Email harus diisi");
    }
  }
}
