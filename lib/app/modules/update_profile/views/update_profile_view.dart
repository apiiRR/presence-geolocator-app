import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  UpdateProfileView({Key? key}) : super(key: key);
  final Map<String, dynamic> user = Get.arguments;
  @override
  Widget build(BuildContext context) {
    controller.nipController.text = user["nip"];
    controller.nameController.text = user["nama"];
    controller.emailController.text = user["email"];
    return Scaffold(
        appBar: AppBar(
          title: const Text('UPDATE PROFILE'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              readOnly: true,
              controller: controller.nipController,
              decoration: const InputDecoration(
                  labelText: "NIP", border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              readOnly: true,
              controller: controller.emailController,
              decoration: const InputDecoration(
                  labelText: "Email", border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(
                  labelText: "Name", border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Photo Profile",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                user["profile"] != null && user["profile"] != ""
                    ? const Text("foto profil")
                    : const Text("No choosen.."),
                TextButton(onPressed: () {}, child: const Text("choose"))
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  controller.updateProfile(user["uid"]);
                },
                child: Text(controller.isLoading.isFalse
                    ? "UPDATE PROFILE"
                    : "LOADING..."))
          ],
        ));
  }
}
