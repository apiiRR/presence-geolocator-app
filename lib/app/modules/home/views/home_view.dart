import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => Get.toNamed(Routes.PROFILE ),
              icon: const Icon(Icons.person))
          // StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          //   stream: controller.streamRole(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return const SizedBox();
          //     }

          //     String role = snapshot.data!.data()!["role"];
          //     return IconButton(
          //         onPressed: () => Get.toNamed(Routes.ADD_PEGAWAI),
          //         icon: const Icon(Icons.person));
          //   },
          // )
        ],
      ),
      body: const Center(
        child: Text(
          'HomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          Get.offAllNamed(Routes.LOGIN);
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}
