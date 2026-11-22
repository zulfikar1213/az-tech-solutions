import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'services/auth_service.dart';

class OwnerBookingsScreen extends StatefulWidget {
  const OwnerBookingsScreen({super.key});

  @override
  State<OwnerBookingsScreen> createState() => _OwnerBookingsScreenState();
}

class _OwnerBookingsScreenState extends State<OwnerBookingsScreen> {
  List<dynamic> bookings = [];
  bool loading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  Future<void> loadBookings() async {
    setState(() {
      loading = true;
      error = '';
    });
    try {
      final token = await AuthService.getToken();
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/bookings'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          bookings = json.decode(response.body);
          loading = false;
        });
      } else {
        setState(() {
          error = 'Server said: ${response.statusCode}';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  Future<void> updateStatus(int id, String status) async {
    final token = await AuthService.getToken();
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/bookings/$id/status'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'status': status}),
    );
    if (response.statusCode != 200) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: ${response.statusCode} ${response.body}')),
      );
      return;
    }
    await loadBookings();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Requests')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (error.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Requests')),
        body: Center(child: Text(error)),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text('Requests (${bookings.length})')),
      body: bookings.isEmpty
          ? const Center(child: Text('No requests yet'))
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index] as Map<String, dynamic>;
                final name = booking['customer_name'] ?? booking['name'] ?? 'Customer';
                final phone = booking['customer_phone'] ?? booking['phone'] ?? '';
                final note = booking['note'] ?? '';
                final serviceName = booking['service_name'] ?? booking['service'] ?? 'Service';
                final status = booking['status'] ?? 'new';
                final id = booking['id'] as int;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.red,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(child: Text('$name - $serviceName')),
                            Text(status, style: const TextStyle(color: Colors.red)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Phone: $phone'),
                        Text('Note: $note'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => updateStatus(id, 'accepted'),
                              child: const Text('Accept'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => updateStatus(id, 'done'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              child: const Text('Done'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}