import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'map.dart';
import 'profile.dart';
import 'wallet.dart';
import 'navbar.dart';

class Ticket {
  final String eventName;
  final String startDate;
  final String endDate;
  final String location;
  final String eventImage;
  final String ticketType;

  Ticket({
    required this.eventName,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.eventImage,
    required this.ticketType,
  });
}

class Tickets extends StatefulWidget {
  const Tickets({Key? key}) : super(key: key);

  @override
  _TicketsState createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  int _selectedIndex = 1;
  List<Ticket> _tickets = [];

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Wallet())
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Tickets())
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MapScreen())
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Profile())
        );
        break;
      default:
    }
  }

  Future<void> _fetchTickets() async {
    final url = Uri.parse('https://social-summit.edid.dev/api/events');
    final headers = {'Content-Type': 'application/json', 'Authorization': await _getToken()};
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        for (var ticket in data) {
          final timestampStart = ticket['startDate'] as int;
          final dateStart = DateTime.fromMillisecondsSinceEpoch(timestampStart);
          final formattedDateStart = '${dateStart.day.toString().padLeft(2, '0')}-${dateStart.month.toString().padLeft(2, '0')}-${dateStart.year.toString()}';

          final timestampEnd = ticket['endDate'] as int;
          final dateEnd = DateTime.fromMillisecondsSinceEpoch(timestampEnd);
          final formattedDateEnd = '${dateEnd.day.toString().padLeft(2, '0')}-${dateEnd.month.toString().padLeft(2, '0')}-${dateEnd.year.toString()}';

          setState(() {
              _tickets.add(Ticket(
                eventName: ticket['name'],
                startDate: formattedDateStart,
                endDate: formattedDateEnd,
                location: ticket['location'],
                eventImage: ticket['image'].replaceFirst(RegExp('data:image/[^;]+;base64,'), ''),
                ticketType: ticket['type'].toString().split('_').map((e) => e[0].toUpperCase() + e.substring(1).toLowerCase()).join(' '),
              ));
          });

        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color.fromRGBO(28, 32, 37, 100),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 42),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 20),
              Text(
                'Tickets',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            alignment: Alignment.center,
            height: 520,
            width: 370,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: const Color.fromRGBO(51, 60, 69, 100),
              elevation: 4,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _tickets.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _handleTicketClick(context, _tickets[index]);
                    },
                    child: Card(
                      color: const Color.fromARGB(255, 87, 95, 105),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                      child: ListTile(
                        title: Text(_tickets[index].eventName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_tickets[index].ticketType} Ticket',
                              style: const TextStyle(
                                color: Color(0xFFBD93F9),
                              )
                            ),
                          ],
                        ),
                        trailing: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          color: const Color.fromRGBO(87, 95, 105, 100),
                          elevation: 2,
                          child: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () {
                              _handleCalendarIconClick(context, _tickets[index]);
                            },
                        ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ),
      ]),
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

  void _handleCalendarIconClick(BuildContext context, Ticket ticket) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: const Color.fromARGB(255, 51, 60, 69),
          title: const Text('Lineup'),
          content: Image.memory(base64.decode(ticket.eventImage)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _handleTicketClick(BuildContext context, Ticket ticket) {
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: const Color.fromARGB(255, 51, 60, 69),
        title: Text(ticket.eventName),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/qr.png',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Place: ', style: TextStyle(fontWeight: FontWeight.w100)),
                Text(ticket.location, style: const TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Date: ', style: TextStyle(fontWeight: FontWeight.w100)),
                Text(ticket.startDate, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Text(' - ', style: TextStyle(fontWeight: FontWeight.w100)),
                Text(ticket.endDate, style: const TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
