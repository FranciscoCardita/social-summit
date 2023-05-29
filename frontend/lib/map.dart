import 'package:flutter/material.dart';
import 'tickets.dart';
import 'profile.dart';
import 'wallet.dart';
import 'navbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Person {
  final String nome;
  final String distance;
  final String personImage;

  Person({
    required this.nome,
    required this.distance,
    required this.personImage,
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
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MapScreen()));
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
    List<Person> persons = [
      Person(
        nome: 'Alice',
        distance: '50m ',
        personImage: 'assets/alice.jpg',
      ),
      Person(
        nome: 'Jamal',
        distance: '130 m',
        personImage: 'assets/jamal.jpg',
      ),
      Person(
        nome: 'Bob',
        distance: '130 m',
        personImage: 'assets/bob.jpg',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF151515),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 42),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const <Widget>[
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
            child: Container(
              width: double.infinity,
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
                    showGroup(context, persons);
                  },
                  child: const Text('My group'),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
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
          Row(
            children: [
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
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

  void showGroup(BuildContext context, List<Person> persons) {
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
              children: persons.map((person) {
                return ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: Text(person.nome),
                  subtitle: Text(person.distance),
                  leading: SizedBox(
                    width: 60,
                    height: 60,
                    child: Image.asset(
                      person.personImage,
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
        String friendEmail;

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
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog without adding the friend
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
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
