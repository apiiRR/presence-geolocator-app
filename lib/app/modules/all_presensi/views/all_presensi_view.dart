import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../routes/app_pages.dart';
import '../controllers/all_presensi_controller.dart';

class AllPresensiView extends GetView<AllPresensiController> {
  const AllPresensiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SEMUA PRESENSI'),
        centerTitle: true,
      ),
      body: GetBuilder<AllPresensiController>(builder: (c) {
        return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: controller.getPresence(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snap.data == null || snap.data!.docs.isEmpty) {
                return const SizedBox(
                  height: 150,
                  child: Center(
                    child: Text("Belum ada history presensi."),
                  ),
                );
              }

              return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20),
                  itemCount: snap.data!.docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = snap.data!.docs[index].data();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200],
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(Routes.DETAIL_PRESENSI,
                                arguments: data);
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Masuk",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(DateFormat.yMMMEd()
                                        .format(DateTime.parse(data["date"]))),
                                  ],
                                ),
                                Text(DateFormat.jms().format(
                                    DateTime.parse(data["masuk"]["date"]))),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Keluar",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(data["keluar"] != null
                                    ? DateFormat.jms().format(
                                        DateTime.parse(data["keluar"]["date"]))
                                    : "-")
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            });
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(Dialog(
            child: Container(
              padding: const EdgeInsets.all(20),
              height: 400,
              child: SfDateRangePicker(
                monthViewSettings:
                    const DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                selectionMode: DateRangePickerSelectionMode.range,
                showActionButtons: true,
                onCancel: () => Get.back(),
                onSubmit: (object) {
                  if (object != null) {
                    if ((object as PickerDateRange).endDate != null) {
                      controller.pickDate(object.startDate!, object.endDate!);
                    }
                  }

                  Get.back();
                },
              ),
            ),
          ));
        },
        child: const Icon(Icons.format_list_bulleted_rounded),
      ),
    );
  }
}
