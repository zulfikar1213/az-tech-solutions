import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'owner_bookings_screen.dart';

class BusinessScreen extends StatefulWidget {
  final String token;
  const BusinessScreen({super.key, required this.token});

  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {
  List services = [];
  List bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final serviceRes = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/services'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
      final bookingRes = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/bookings'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
      if (serviceRes.statusCode == 200) {
        services = jsonDecode(serviceRes.body);
      }
      if (bookingRes.statusCode == 200) {
        bookings = jsonDecode(bookingRes.body);
      }
    } catch (e) {
      // If server is off, keep empty lists
    }
    setState(() {
      isLoading = false;
    });
  }

  int get newCount {
    return bookings.where((b) => b['status'] == 'new').length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('A.Z Tech Solutions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Owner View Requests Button with Red Badge
                  Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.inbox),
                          label: const Text('View Requests'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OwnerBookingsScreen(token: widget.token),
                              ),
                            ).then((_) => loadData());
                          },
                        ),
                      ),
                      if (newCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$newCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'My Services',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: services.isEmpty
                        ? const Center(child: Text('No services yet'))
                        : ListView.builder(
                            itemCount: services.length,
                            itemBuilder: (context, index) {
                              final s = services[index];
                              return Card(
                                child: ListTile(
                                  title: Text(s['name'] ?? 'Service'),
                                  subtitle: Text(s['description'] ?? ''),
                                  trailing: Text(
                                    '\$${s['price']}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}