import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/page_index_controller.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageController = Get.find<PageIndexController>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('HomeView'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => Get.toNamed(Routes.PROFILE),
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
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.streamUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasData) {
                Map<String, dynamic> user = snapshot.data!.data()!;

                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: Container(
                            width: 75,
                            height: 75,
                            color: Colors.grey[200],
                            child: Image.network(
                              user["profile"] != null && user["profile"] != ""
                                  ? user["profile"]
                                  : "https://ui-avatars.com/api/?name=${user['nama']}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Welcome",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 200,
                              child: Text(
                                user["position"] != null
                                    ? "${user["address"]}"
                                    : "Belum ada lokasi",
                                textAlign: TextAlign.left,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user["job"],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            user["nip"],
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            user["nama"],
                            style: const TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[200]),
                      child: StreamBuilder<
                              DocumentSnapshot<Map<String, dynamic>>>(
                          stream: controller.streamTodayPresence(),
                          builder: (context, snapToday) {
                            Map<String, dynamic>? dataToday =
                                snapToday.data?.data();
                            if (snapToday.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    const Text("Masuk"),
                                    Text(dataToday != null &&
                                            dataToday["masuk"] != null
                                        ? DateFormat.jms().format(
                                            DateTime.parse(
                                                dataToday["masuk"]["date"]))
                                        : "-")
                                  ],
                                ),
                                Container(
                                  width: 2,
                                  height: 40,
                                  color: Colors.grey,
                                ),
                                Column(
                                  children: [
                                    const Text("Keluar"),
                                    Text(dataToday != null &&
                                            dataToday["keluar"] != null
                                        ? DateFormat.jms().format(
                                            DateTime.parse(
                                                dataToday["keluar"]["date"]))
                                        : "-")
                                  ],
                                ),
                              ],
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Divider(
                      color: Colors.grey[300],
                      thickness: 2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Last 5 days",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.ALL_PRESENSI);
                            },
                            child: const Text(
                              "See more",
                            ))
                      ],
                    ),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: controller.streamLastPresence(),
                        builder: (context, snapPresence) {
                          if (snapPresence.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapPresence.data == null ||
                              snapPresence.data!.docs.isEmpty) {
                            return const SizedBox(
                              height: 150,
                              child: Center(
                                child: Text("Belum ada history presensi"),
                              ),
                            );
                          }

                          return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapPresence.data!.docs.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> data =
                                    snapPresence.data!.docs[index].data();
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
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "Masuk",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(DateFormat.yMMMEd().format(
                                                    DateTime.parse(
                                                        data["date"]))),
                                              ],
                                            ),
                                            Text(DateFormat.jms().format(
                                                DateTime.parse(
                                                    data["masuk"]["date"]))),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text(
                                              "Keluar",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(data["keluar"] != null
                                                ? DateFormat.jms().format(
                                                    DateTime.parse(
                                                        data["keluar"]["date"]))
                                                : "-")
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        })
                  ],
                );
              } else {
                return const Center(
                  child: Text("Tidak dapat memuat database user"),
                );
              }
            }),
        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.fixedCircle,
          items: const [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.fingerprint, title: 'Add'),
            TabItem(icon: Icons.people, title: 'Profile'),
          ],
          initialActiveIndex: pageController.pageIndex.value,
          onTap: (int i) => pageController.changePage(i),
        )
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     await FirebaseAuth.instance.signOut();
        //     Get.offAllNamed(Routes.LOGIN);
        //   },
        //   child: const Icon(Icons.logout),
        // ),
        );
  }
}
