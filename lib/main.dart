import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // Track the selected index

  // List of widgets to display based on the selected index
  final List<Widget> _widgetOptions = <Widget>[
    const Text('Product Page', style: TextStyle(fontSize: 24, color: Colors.orange)),
    const Text('Cart Page', style: TextStyle(fontSize: 24, color: Colors.orange)),
    const Text('Profile Page', style: TextStyle(fontSize: 24, color: Colors.orange)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const IconButton(
          icon: Icon(Icons.menu),
          tooltip: 'Navigation menu',
          onPressed: null,
        ),
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.blue),
        ),
        actions: const [
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: null,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: const Text('Cart'),
              onTap: () {
                // Handle item tap
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                // Handle item tap
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to Orange Digital Center',
              style: TextStyle(color: Colors.orange, fontSize: 24), // Set the text color to orange
            ),
            const SizedBox(height: 100), // Add some space between the text and the button
            ElevatedButton(
              onPressed: () {
                // Navigate to the second page when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondPage()),
                );
              },
              child: const Text('Press Me'),
              style: ElevatedButton.styleFrom(), // Set button color
            ),
            const SizedBox(height: 20), // Add some space
            _widgetOptions[_selectedIndex], // Display the selected widget
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add', // used by assistive technologies
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Alert'),
                content: const Text('Floating Action Button Pressed!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.orange, // Set the background color to orange
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.production_quantity_limits), // Product icon
            label: 'Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart), // Cart icon
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Profile icon
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex, // Set the current index
        selectedItemColor: Colors.orange, // Color for the selected item
        onTap: _onItemTapped, // Handle item tap
      ),
      backgroundColor: Colors.black, // Set the background color to black
    );
  }
}

// New Second Page
class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // First Column
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Stack for the squares
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    // Large orange square
                    Container(
                      width: 100, // Width of the large square
                      height: 100, // Height of the large square
                      color: Colors.orange,
                    ),
                    // Small white square positioned at the bottom center
                    Positioned(
                      bottom: 10, // Position from the bottom
                      child: Container(
                        width: 60, // Width of the small square
                        height: 10, // Height of the small square
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20), // Space between the stack and text
                // Column for the text beside the stack
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                  children: const <Widget>[
                    Text(
                      'Orange',
                      style: TextStyle(fontSize: 18, color: Colors.orange),
                    ),
                    Text(
                      'Digital',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      'Center',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20), // Space between the two columns
            // Second Column
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text(
                  'est là',
                  style: TextStyle(fontSize: 34, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}