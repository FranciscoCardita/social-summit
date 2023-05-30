import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tickets.dart';
import 'profile.dart';
import 'wallet.dart';
import 'navbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Person {
  final String id;
  final String name;
  final String avatar;

  Person({
    required this.id,
    required this.name,
    required this.avatar,
  });
}

class Info {
  final String info;
  final String time;

  Info({required this.info, required this.time});
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MapScreen> {
  List<Person> group = [];
  int _selectedIndex = 2;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _addMarker(
      const LatLng(40.631462, -8.663808),
      'Alice',
      '50m',
    );
    _addMarker(
      const LatLng(40.632062, -8.662985),
      'Jamal',
      '130 m',
    );
    _addMarker(
      const LatLng(40.631850, -8.662545),
      'Bob',
      '130 m',
    );
    getGroup();
  }

  void _addMarker(LatLng position, String title, String snippet) {
    final markerId = MarkerId(position.toString());
    final marker = Marker(
      markerId: markerId,
      position: position,
      infoWindow: InfoWindow(title: title, snippet: snippet),
    );

    setState(() {
      _markers.add(marker);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Wallet()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Tickets()));
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Profile()));
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151515),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 42),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 20),
              Text(
                'Map',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(40.631462, -8.663808),
                    zoom: 16,
                  ),
                  markers: _markers,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  }),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showImageDialog(context);
                  },
                  child: const Text('Venue info'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    showGroup(context, group);
                  },
                  child: const Text('My group'),
                ),
              ],
            ),
          ),
          const Row(
            children: [
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alice is coming to meet you',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    '3:50 AM',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bob and Jamal left the venue',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    '3:23 AM',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: NavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<void> getGroup() async {
    final url = Uri.parse('https://social-summit.edid.dev/api/group');
    final groupHeaders = {
      'Content-Type': 'application/json',
      'Authorization': await _getToken()
    };
    final response = await http.get(url, headers: groupHeaders);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body)['users'];
      for (var response in jsonResponse) {
        final id = response['id'];
        final name = response['name'];
        final avatar = response['avatar']
            .replaceFirst(RegExp('data:image/[^;]+;base64,'), '');
        final element = Person(id: id, name: name, avatar: avatar);
        if (!group.any((e) => e.id == id)) {
          setState(() {
            group.add(element);
          });
        }
      }
    } else {
      print('Failed to load group');
    }
  }

  void showGroup(BuildContext context, List<Person> group) {
    getGroup();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 51, 60, 69),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: const Text('My Group'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: group.map((person) {
                return ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: Text(person.name),
                  leading: SizedBox(
                    width: 60,
                    height: 60,
                    child: Image.memory(
                      base64.decode(person.avatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {},
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                addFriends(context);
              },
              child: const Text('Add Friends'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void addFriends(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String friendEmail = '';

        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 51, 60, 69),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: const Text('Add Friends'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) {
                  friendEmail = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                addUser(friendEmail);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> addUser(String email) async {
    final url = Uri.parse('https://social-summit.edid.dev/api/group/users');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': await _getToken()
    };
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(<String, String>{'email': email}),
    );

    if (response.statusCode == 200) {
      getGroup();
    } else {
      print('Failed to add user');
    }
  }

  void showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 51, 60, 69),
          title: const Text('Venue Info'),
          content: Image.asset(
            'assets/venue1.png',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
