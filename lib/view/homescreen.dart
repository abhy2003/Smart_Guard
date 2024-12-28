// views/home_ui.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_gaurd/controller/login_controller.dart';
import '../controller/homescreen_controller.dart';
import '../model/homescreen_model.dart';

class Homescreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final LoginController logcontroller=Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Smart Guard', style: GoogleFonts.poppins(color: Colors.redAccent[900],fontWeight: FontWeight.bold)),
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
        color: Colors.black,
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
                final name = logcontroller.name;
                final email = logcontroller.email;

                return name != null && email != null
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nickname: $name',
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