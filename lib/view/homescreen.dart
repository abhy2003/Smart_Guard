// views/home_ui.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/homescreen_controller.dart';
import '../model/lock_model.dart';

class Homescreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Guard', style: TextStyle(color:Colors.red,fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal[700],
        elevation: 0,
        toolbarHeight: 60,
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () {

            },
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
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
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
        elevation: 10,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: Colors.teal[100],
        child: Obx(() {
          return Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.teal[800],
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30)),
                ),
                child: Center(
                  child: Text(
                    'Smart Guard',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.locks.length,
                  itemBuilder: (context, index) {
                    final lock = controller.locks[index];
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      title: Text(lock.nickname, style: TextStyle(color: Colors.teal[800])),
                      subtitle: Text('Lock ID: ${lock.lockId}', style: TextStyle(color: Colors.teal[600])),
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
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lock.nickname,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal[700]),
            ),
            SizedBox(height: 8),
            Text('Lock ID: ${lock.lockId}', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Status: ',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  lock.lockStatus == 'locked' ? 'Locked' : 'Unlocked',
                  style: TextStyle(
                    fontSize: 14,
                    color: lock.lockStatus == 'locked' ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('Tampering: ${lock.tamperingValue ?? "No"}', style: TextStyle(fontSize: 14, color: Colors.teal[600])),
            Text('Sensor: ${lock.sensorvalue ?? "N/A"}', style: TextStyle(fontSize: 14, color: Colors.teal[600])),
          ],
        ),
      ),
    );
  }

  void _showConnectSheet() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        color: Colors.teal[100],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller.nicknameController,
              decoration: InputDecoration(
                labelText: 'Nickname',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: controller.lockIdController,
              decoration: InputDecoration(
                labelText: 'Lock ID',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                controller.connectLock();
                Get.back();
              },
              child: Text('Add Lock'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}