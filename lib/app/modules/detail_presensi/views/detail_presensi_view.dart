import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  DetailPresensiView({Key? key}) : super(key: key);
  final Map<String, dynamic> data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('DetailPresensiView'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      DateFormat.yMMMMEEEEd()
                          .format(DateTime.parse(data["date"])),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Masuk",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                      "Jam : ${DateFormat.jms().format(DateTime.parse(data["masuk"]["date"]))}"),
                  Text(
                      "Posisi : ${data["masuk"]["lat"]}, ${data["masuk"]["long"]}"),
                  Text("Status : ${data["masuk"]["status"]}"),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Keluar",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                      "Jam : ${data["keluar"] != null ? DateFormat.jms().format(DateTime.parse(data["keluar"]["date"])) : "-"}"),
                  Text(data["keluar"] != null
                      ? "Posisi : ${data["masuk"]["lat"]}, ${data["masuk"]["long"]}"
                      : "Posisi : -"),
                  Text(
                      "Status : ${data["keluar"] != null ? data["keluar"]["status"] : "-"}"),
                ],
              ),
            ),
          ],
        ));
  }
}
