import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:futhub2/models/futsal_model.dart';
import 'package:futhub2/screens/profile/profile_page.dart';
import 'package:futhub2/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PlayerHomePage extends StatefulWidget {
  const PlayerHomePage({super.key});

  @override
  _PlayerHomePageState createState() => _PlayerHomePageState();
}

class _PlayerHomePageState extends State<PlayerHomePage> {
  final String apiUrl = 'http://localhost:4001/api/futsals';

  Future<List<Futsal>> fetchFutsals() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      final response = await http.get(
        Uri.parse("${AuthService.baseUrl}futsals"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((futsalJson) => Futsal.fromJson(futsalJson)).toList();
      } else {
        throw Exception('Failed to load futsals');
      }
    } catch (e) {
      throw Exception('Error fetching futsals: $e');
    }
  }

  void _onFutsalBooked(Futsal futsal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Booking Confirmation',
            style: TextStyle(color: Colors.orange)),
        content: Text(
          'You have successfully booked ${futsal.location ?? "this futsal"}.',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(
          onPageSelected: (Widget page) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => page));
          },
          onLogout: () => _logout(context)),
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'FUTHUB',
          style: TextStyle(
              color: Colors.orange, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.orange),
        actions: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Futsal>>(
        future: fetchFutsals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.orange));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No futsals available',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final futsals = snapshot.data!;

          return ListView.builder(
            itemCount: futsals.length,
            itemBuilder: (context, index) {
              final futsal = futsals[index];
              return Card(
                color: const Color(0xFF1E1E1E),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            futsal.location ?? 'Unknown Futsal',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Location: ${futsal.location ?? 'Unknown'}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '\$${futsal.price ?? 'N/A'}',
                            style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => _onFutsalBooked(futsal),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Book',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SideMenu extends StatelessWidget {
  final Function(Widget) onPageSelected;
  final VoidCallback onLogout;

  const SideMenu({required this.onPageSelected, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF121212),
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text(
              'FUTHUB',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.sports_soccer, color: Colors.orange),
            title: const Text('Available Futsal',
                style: TextStyle(color: Colors.white)),
            onTap: () => onPageSelected(PlayerHomePage()),
          ),
          ListTile(
            leading: const Icon(Icons.history, color: Colors.orange),
            title: const Text('Booking History',
                style: TextStyle(color: Colors.white)),
            onTap: () => onPageSelected(BookingHistoryPage()),
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}

class BookingHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Booking History',
            style: TextStyle(color: Colors.orange)),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: const Center(
        child:
            Text('Booking History Page', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
