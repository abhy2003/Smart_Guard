import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/homescreen_controller.dart';
import '../model/lock_model.dart';

class LoginPage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Smart Guard', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey[900],
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: controller.logout,
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
        backgroundColor: Colors.teal,
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
                      title: Text(lock.nickname, style: TextStyle(color: Colors.white)),
                      subtitle: Text('Lock ID: ${lock.lockId}', style: TextStyle(color: Colors.white70)),
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
              lock.nickname,
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 8),
            Text('Lock ID: ${lock.lockId}', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70)),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Status: ',
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  lock.lockStatus == 'locked' ? 'Locked' : 'Unlocked',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: lock.lockStatus == 'locked' ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('Tampering: ${lock.tamperingValue ?? "No"}', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70)),
            Text('Sensor: ${lock.sensorvalue ?? "N/A"}', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  void _showConnectSheet() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        color: Colors.grey[850],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller.nicknameController,
              decoration: InputDecoration(
                labelText: 'Nickname',
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
                labelText: 'Lock ID',
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
              },
              child: Text('Add Lock', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }
}