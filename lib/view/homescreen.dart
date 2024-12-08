import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/homescreen_controller.dart';

class Homescreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  Widget _buildLockStatus(HomeController controller) {
    final lockStatus = controller.currentLock.value?.lockStatus ?? "Not Connected";
    final statusColor = controller.statusColors[lockStatus] ?? Colors.grey;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 8,
          backgroundColor: statusColor,
        ),
        SizedBox(width: 8),
        Text(
          lockStatus,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }

  void _showProfileSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
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
              final lock = controller.currentLock.value;
              return lock != null
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nickname: ${controller.name}',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Email: ${controller.email}',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                  ),
                ],
              )
                  : Text(
                'No lock connected.',
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
    );
  }

  void _showConnectSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        color: Colors.black,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Connect',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: controller.nicknameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Nickname',
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: controller.lockIdController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Lock ID',
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                controller.connectLock();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Connect',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Smart Guard',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () => _showProfileSheet(context),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.grey[900],
          child: Obx(() {
            final lock = controller.currentLock.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.black),
                  child: Center(
                    child: Text(
                      'Smart Guard',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Name: ${controller.name}',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Email: ${controller.email}',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Lock ID: ${lock?.lockId ?? "Not Connected"}',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
      body: Obx(() {
        final lock = controller.currentLock.value;
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (lock != null)
                Card(
                  margin: EdgeInsets.all(16),
                  color: Colors.black, // Black background for the card
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Slightly rounded corners for a modern feel
                  ),
                  elevation: 8, // Added shadow to make the card stand out
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left for clarity
                      children: [
                        Text(
                          'Connected to ${lock.nickname} (Lock ID: ${lock.lockId})',
                          style: GoogleFonts.poppins(
                            color: Colors.white, // White text for clarity
                            fontSize: 20, // Increased font size for better readability
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start, // Align text to the left
                        ),
                        SizedBox(height: 10),
                        _buildLockStatus(controller),
                        SizedBox(height: 10),
                        Text(
                          'Tampering: ${lock.tamperingValue ?? "No"}',
                          style: GoogleFonts.poppins(
                            color: Colors.redAccent, // Red color for highlighting tampering status
                            fontSize: 20, // Increased font size for better visibility
                            fontWeight: FontWeight.w600, // Slightly lighter weight for variety
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Alcamation: ${lock.acclamationValue ?? "No"}',
                          style: GoogleFonts.poppins(
                            color: Colors.redAccent, // Red color for highlighting alarmation status
                            fontSize: 20, // Increased font size for better visibility
                            fontWeight: FontWeight.w600, // Slightly lighter weight for variety
                          ),
                        ),
                        SizedBox(height: 20),
                        // ElevatedButton(
                        //   onPressed: () {},
                        //   style: ElevatedButton.styleFrom(
                        //     foregroundColor: Colors.white, backgroundColor: Colors.red, // White text on the button
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(8),
                        //     ),
                        //     padding: EdgeInsets.symmetric(vertical: 16, horizontal: 30), // Added padding to the button
                        //   ),
                        //   child: Text(
                        //     'Live Video',
                        //     style: GoogleFonts.poppins(
                        //       color: Colors.white, // White text color
                        //       fontSize: 20, // Increased font size for button text
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),

              Text(
                'Tap the button to connect',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showConnectSheet(context),
        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
