import 'package:flutter/material.dart';
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

  Ticket({
    required this.eventName,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.eventImage,
  });
}

class Tickets extends StatefulWidget {
  const Tickets({Key? key}) : super(key: key);

  @override
  _TicketsState createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  int _selectedIndex = 1;

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
          MaterialPageRoute(builder: (context) => const Map())
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

  @override
  Widget build(BuildContext context) {
    List<Ticket> tickets = [
      Ticket(
        eventName: 'Nos Alive 2023',
        startDate: '6/06/2023',
        endDate: '8/06/2023',
        location: 'Passeio Maritimo de Algés',
        eventImage: 'assets/nos.jpg',
      ),
      Ticket(
        eventName: 'Enterro 2023',
        startDate: '15/06/2023',
        endDate: '17/06/2023',
        location: 'Universidade do Aveiro',
        eventImage: 'assets/enterro.jpg',
      ),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color.fromRGBO(28, 32, 37, 100),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 42),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const <Widget>[
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
          SizedBox(
            height: 400,
            child: ListView.builder(
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _handleTicketClick(context, tickets[index]);
                },
                child: Card(
                  elevation: 4,
                  child: ListTile(
                    title: Text(tickets[index].eventName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Begin: ${tickets[index].startDate}'),
                        Text('End: ${tickets[index].endDate}'),
                        Text('Location: ${tickets[index].location}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () {
                        _handleCalendarIconClick(context, tickets[index]);
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          ),
      ]),
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

  void _handleCalendarIconClick(BuildContext context, Ticket ticket) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cartaz'),
          content: Image.asset(ticket.eventImage),
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
        title: Text(ticket.eventName),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Local: ' + ticket.location),
            Text('Begin: ' + ticket.startDate),
            Text('End: ' + ticket.endDate),
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
