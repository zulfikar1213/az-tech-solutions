import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'services/auth_service.dart';
import 'owner_bookings_screen.dart';

class BusinessScreen extends StatefulWidget {
  const BusinessScreen({super.key});

  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {
  List<dynamic> services = [];
  List<dynamic> bookings = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final token = await AuthService.getToken();
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    try {
      final sRes = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/services'),
        headers: headers,
      );
      final bRes = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/bookings'),
        headers: headers,
      );
      setState(() {
        if (sRes.statusCode == 200) {
          services = json.decode(sRes.body);
        }
        if (bRes.statusCode == 200) {
          bookings = json.decode(bRes.body);
        }
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  int get newCount {
    return bookings.where((b) => b['status'] == 'new').length;
  }

  Future<void> logout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Business')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Business'),
        actions: [
          IconButton(onPressed: logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OwnerBookingsScreen()),
                ).then((_) => loadData());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('View Requests'),
                  const SizedBox(width: 8),
                  if (newCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$newCount',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final s = services[index] as Map<String, dynamic>;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    title: Text(s['name'] ?? ''),
                    trailing: Text('\$${s['price'] ?? ''}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}