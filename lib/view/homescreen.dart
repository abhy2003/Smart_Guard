import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_gaurd/controller/login_controller.dart';
import 'package:smart_gaurd/view/video_player.dart';
import '../controller/homescreen_controller.dart';
import '../model/homescreen_model.dart';

class Homescreen extends StatelessWidget {
  final LockController controller = Get.put(LockController());
  final LoginController logcontroller=Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Smart Guard', style: GoogleFonts.poppins(color: Colors.white54,fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey[900],
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () => _showProfileSheet(context),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Obx(() {
        if (controller.locks.isEmpty) {
          return Center(
            child: Text(
              'No locks added yet.\nTap the "+" button to add a lock.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.locks.length,
          itemBuilder: (context, index) {
            final lock = controller.locks[index];
            return _buildLockCard(lock);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showConnectSheet,
        backgroundColor: Colors.redAccent[700],
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: Colors.blueGrey[900],
        child: Obx(() {
          return Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Text(
                    'Smart Guard',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.locks.length,
                  itemBuilder: (context, index) {
                    final lock = controller.locks[index];
                    return ListTile(
                      title: Text(lock.name, style: TextStyle(color: Colors.white)),
                      subtitle: Text('Lock ID: ${lock.connection_id}', style: TextStyle(color: Colors.white70)),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => controller.removeLock(lock),
                      ),
                      onTap: () {
                        controller.selectLock(lock);
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
  Widget _buildLockCard(HomeScreenModel lock) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lock.name,
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              'Name: ${lock.name}',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Status: ',
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Obx(() => Text(
                  lock.lockStatus.value == 'Locked' ? 'Locked' : 'Open',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: lock.lockStatus.value == 'Locked' ? Colors.red : Colors.green,
                  ),
                )),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Tampering: ${lock.tamperingValue ?? "No"}',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
            ),
            Text(
              'Motion: ${lock.motion ?? "N/A"}',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
            ),
            Text(
              'Vibration: ${lock.vibration ?? 0.0.obs}',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
            ),
            SizedBox(height: 16),
            Obx(() => Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  lock.lockStatus.value = lock.lockStatus.value == 'Locked' ? 'Open' : 'Locked';
                  controller.updateLockStatus(lock.lockStatus.value);
                  Get.snackbar(
                    backgroundColor: Colors.teal,
                    "Lock Status",
                    lock.lockStatus.value == 'Locked' ? "Locked" : "Opened",
                  );
                },
                icon: Icon(
                  lock.lockStatus.value == 'Locked' ? Icons.lock : Icons.lock_open,
                  color: Colors.white,
                ),
                label: Text(
                  lock.lockStatus.value == 'Locked' ? "Open" : "Lock",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: lock.lockStatus.value == 'Locked' ? Colors.green : Colors.red,
                ),
              ),
            )),
            SizedBox(height: 16),
            // Live Video Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.snackbar("Live Video", "Opening live video...");
                  Get.to(() => VideoPlayer_live());
                },
                icon: Icon(Icons.videocam, color: Colors.white),
                label: Text(
                  "View Live Video",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _showConnectSheet() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        color: Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller.nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[700],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: controller.lockIdController,
              decoration: InputDecoration(
                labelText: 'Connection ID',
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[700],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                controller.connectLock();
                Get.back();
                if (controller.lockfound){
                  Get.snackbar(
                    'Success',
                    'Lock found',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    duration: Duration(seconds: 3),
                  );
                }else{
                  Get.snackbar(
                    'Error',
                    'Lock not found',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    duration: Duration(seconds: 3),
                  );
                }

              },
              child: Text('Add Lock', style: GoogleFonts.poppins(color:Colors.black,fontSize: 18, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
  void _showProfileSheet(BuildContext context) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          color: Colors.black,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile Details',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),

              Obx(() {
                final username = controller.username;
                final email = controller.email;

                return username != null && email != null
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Name: $username',
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Email: $email',
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                    ),
                  ],
                )
                    : Text(
                  'No profile data available.',
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                );
              }),

              SizedBox(height: 24),

              ElevatedButton(
                onPressed: controller.logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Logout',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }}