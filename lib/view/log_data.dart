import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogData extends StatelessWidget {
  final List<Map<String, String>> lockLogs = [
    {'name': 'Front Door', 'id': '001', 'status': 'Locked', 'time': '10:30 AM', 'date': '2024-02-01'},
    {'name': 'Front Door', 'id': '001', 'status': 'Unlocked', 'time': '02:45 PM', 'date': '2024-02-01'},
    {'name': 'Garage', 'id': '002', 'status': 'Unlocked', 'time': '11:00 AM', 'date': '2024-02-01'},
    {'name': 'Garage', 'id': '002', 'status': 'Locked', 'time': '04:20 PM', 'date': '2024-02-01'},
    {'name': 'Back Door', 'id': '003', 'status': 'Locked', 'time': '12:15 PM', 'date': '2024-02-01'},
    {'name': 'Back Door', 'id': '003', 'status': 'Unlocked', 'time': '03:10 PM', 'date': '2024-02-01'},
    {'name': 'Office', 'id': '004', 'status': 'Unlocked', 'time': '01:45 PM', 'date': '2024-02-01'},
    {'name': 'Office', 'id': '004', 'status': 'Locked', 'time': '05:30 PM', 'date': '2024-02-01'},
    {'name': 'Storage', 'id': '005', 'status': 'Locked', 'time': '02:30 PM', 'date': '2024-02-01'},
    {'name': 'Storage', 'id': '005', 'status': 'Unlocked', 'time': '06:15 PM', 'date': '2024-02-01'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'All Lock Records',
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: ListView.builder(
          itemCount: lockLogs.length,
          itemBuilder: (context, index) {
            final log = lockLogs[index];
            return Card(
              color: Colors.grey[850],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(
                  log['status'] == 'Locked' ? Icons.lock : Icons.lock_open,
                  color: log['status'] == 'Locked' ? Colors.red : Colors.green,
                  size: 30,
                ),
                title: Text(
                  log['name']!,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Lock ID: ${log['id']}\nStatus: ${log['status']}\nDate: ${log['date']}\nTime: ${log['time']}',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                isThreeLine: true,
                trailing: Icon(Icons.history, color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }
}