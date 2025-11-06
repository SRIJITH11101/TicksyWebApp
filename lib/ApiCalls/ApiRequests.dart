import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ticksy_web/Models/AuthRes.dart';
import 'package:ticksy_web/Models/LoginReq.dart';
import 'package:ticksy_web/Models/Message.dart';
import 'package:ticksy_web/Models/SignUpReq.dart';
import 'package:ticksy_web/Models/Ticket.dart';

class ApiRequests {
  final String baseUrl = 'http://localhost:8080';

  Future<AuthRes?> signupStaff(SignUpReq request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/staff-register'),
      headers: {'Content-Type': 'application/json'},

      body: request.toRawJson(),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return AuthRes.fromJson(jsonResponse);
    } else {
      print('SignUp failed: ${response.statusCode}');
      print(response.body);
      return null; // or throw an exception
    }
  }

  Future<AuthRes?> loginStaff(LoginReq request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/staff-login'),
      headers: {'Content-Type': 'application/json'},
      body: request.toRawJson(),
    );

    print('🛰️ [Login] Status: ${response.statusCode}');
    print('🛰️ [Login] Response Body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        if (response.body.isEmpty) {
          print('⚠️ Empty response body.');
          return null;
        }

        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic> &&
            decoded.containsKey('accessToken')) {
          print('✅ Valid AuthRes JSON detected.');
          return AuthRes.fromJson(decoded);
        } else {
          print('⚠️ Unexpected response structure: $decoded');
          return null;
        }
      } catch (e) {
        print('❌ Error decoding login response: $e');
        return null;
      }
    } else {
      print('❌ Login failed [${response.statusCode}]: ${response.body}');
      return null;
    }
  }

  Future<List<Ticket>> fetchUserTickets(
    String department,
    String accessToken,
  ) async {
    final url = Uri.parse(
      '$baseUrl/api/tickets/dept-fetch?department=$department',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Ticket.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tickets: ${response.statusCode}');
    }
  }

  Future<List<Message>> getMessagesByTicketId(
    String ticketId,
    String accessToken,
  ) async {
    final url = Uri.parse(
      '$baseUrl/api/messages/fetch-agent?ticketId=$ticketId',
    );

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken', // add if required
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Message.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<List<Ticket>> searchTicket(String query, String accessToken) async {
    final url = Uri.parse('$baseUrl/api/tickets/search/$query');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken', // add if required
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Ticket.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tickets: ${response.statusCode}');
    }
  }
}
