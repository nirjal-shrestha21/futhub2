import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:futhub2/screens/futsal/add_futsal.dart';
import 'package:futhub2/screens/futsal/book_own_futsal_page.dart';
import 'package:futhub2/screens/futsal/history_page.dart';
import 'package:futhub2/screens/futsal/manage_bookings_page.dart';
import 'package:futhub2/screens/futsal/profile_page.dart';
import 'package:futhub2/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FutsalOwnerDashboard extends StatefulWidget {
  const FutsalOwnerDashboard({super.key});

  @override
  _FutsalOwnerDashboardState createState() => _FutsalOwnerDashboardState();
}

class _FutsalOwnerDashboardState extends State<FutsalOwnerDashboard> {
  List<dynamic> futsals = [];
  List<String> _notifications = [
    "New booking at 3:00 PM",
    "Payment received: \$50",
    "Futsal maintenance scheduled for Sunday",
    "Upcoming match reminder",
  ];
  bool isLoading = true;
  bool _showNotifications = false;

  @override
  void initState() {
    fetchFutsals();

    super.initState();
  }

  Future<void> fetchFutsals() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    debugPrint('Token Data: $token');
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/bookings'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Response: ${response.body}'); // Debugging response
        setState(() {
          futsals = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        print('Failed to load futsals: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching futsals: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalBookings = futsals.length; // Total number of booking records
    
    // Get unique futsal IDs to count total futsals
    Set<String> uniqueFutsalIds = futsals
        .map((booking) => booking['futsalId']['_id'].toString())
        .toSet();
    int totalFutsals = uniqueFutsalIds.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Futsal Owner Dashboard",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Notification Icon with Dropdown
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.orange),
                onPressed: () {
                  setState(() {
                    _showNotifications = !_showNotifications;
                  });
                },
              ),
              if (_notifications.isNotEmpty)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _notifications.length.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Text(
                "Menu",
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            _buildDrawerItem(context, "Add Futsal", const AddFutsalPage()),
            _buildDrawerItem(
                context, "Manage Bookings", const ManageBookingsPage()),
            _buildDrawerItem(
                context, "Book Own Futsal", const BookOwnFutsalPage()),
            _buildDrawerItem(context, "View History", const HistoryPage()),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Analytics",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          children: [
                            _buildAnalyticsCard(
                                "Total Bookings", totalBookings.toString()),
                            _buildAnalyticsCard(
                                "Total Futsals", totalFutsals.toString()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (_showNotifications)
                  Positioned(
                    top: 60,
                    right: 10,
                    child: Material(
                      color: Colors.black,
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 250,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: _notifications.map((notif) {
                            return ListTile(
                              title: Text(notif,
                                  style: const TextStyle(color: Colors.white)),
                              leading: const Icon(Icons.notifications,
                                  color: Colors.orange),
                              onTap: () {
                                setState(() {
                                  _notifications.remove(notif);
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }

  Widget _buildAnalyticsCard(String title, String value) {
    return Card(
      color: Colors.grey[900],
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 10),
            Text(value,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange)),
          ],
        ),
      ),
    );
  }
}
