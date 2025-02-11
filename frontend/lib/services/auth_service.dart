import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://localhost:4001/api/auth';

  // Register function
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
    required String phone,
  }) async {
    final url = Uri.parse('$baseUrl/register');

    // Create request body
    final body = json.encode({
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'phone': phone,
    });

    try {
      // Send POST request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // Check if response is successful
      if (response.statusCode == 201) {
        // Decode the response
        return json.decode(response.body);
      } else {
        // Decode and return error message from response
        return json.decode(response.body);
      }
    } catch (error) {
      // Handle errors (e.g., no internet connection)
      return {'message': 'Something went wrong, try again later'};
    }
  }

  // Login function
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');

    // Create request body
    final body = json.encode({
      'email': email,
      'password': password,
    });

    try {
      // Send POST request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // Check if response is successful
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Save token to shared_preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        return data;
      } else {
        // Return error message
        return {'message': 'Invalid email or password'};
      }
    } catch (error) {
      // Handle errors (e.g., no internet connection)
      return {'message': 'Something went wrong, try again later'};
    }
  }
  // Fetch the token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Logout function
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
