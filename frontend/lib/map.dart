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
      LatLng(40.631462, -8.663808), // Coordinates for marker 1
      'Alice',
      '50m',
    );
    _addMarker(
      LatLng(40.632062, -8.662985), // Coordinates for marker 2
      'Jamal',
      '130 m',
    );
    _addMarker(
      LatLng(40.631850, -8.662545), // Coordinates for marker 2
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
      backgroundColor: const Color.fromRGBO(28, 32, 37, 100),
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
                  initialCameraPosition: CameraPosition(
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
                  child: Text('Venue info'),
                ),
                SizedBox(width: 10), // Adjust the spacing between buttons
                ElevatedButton(
                  onPressed: () {
                    showGroup(context, persons);
                  },
                  child: Text('My group'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
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
          title: Text('My Group'),
          content: SingleChildScrollView(
            child: Container(
              height: 300, // Adjust the height to make the dialog smaller
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: persons.map((person) {
                  return ListTile(
                    title: Text(person.nome),
                    subtitle: Text(person.distance),
                    leading: SizedBox(
                      width: 60, // Specify the desired width
                      height: 60, // Specify the desired height
                      child: Image.asset(
                        person.personImage,
                        fit: BoxFit.cover, // Adjust the image fit as needed
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: Text('Add Friends'),
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
          title: const Text('Venue Info'),
          content: Image.asset(
            'assets/venue1.png', // Replace with your image path
            width: 300,
            height: 200,
          ),
          actions: [
            ElevatedButton(
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
