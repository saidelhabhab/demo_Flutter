import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart'; // Import the Product model


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/', // Set the initial route
      routes: {
        '/': (context) => const SplashScreen(),
        '/sign-in': (context) => const SignInPage(), // Define the route for Sign In
        '/sign-up': (context) => const SignUpPage(), // Define the route for Sign Up
        '/home': (context) => const MyHomePage(), // Define the route for Home Page
      },
    );
  }
}


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a Future to navigate after a delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    });

    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // Large orange square
            Container(
              width: 100,
              height: 100,
              color: Colors.orange,
            ),
            // Small white square positioned at the bottom center
            Positioned(
              bottom: 10,
              child: Container(
                width: 60,
                height: 10,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
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
    const ProductPage(), // Update this to use the ProductPage widget
    const Text('Cart Page', style: TextStyle(fontSize: 24, color: Colors.orange)),
    ProfilePage(), // Use the ProfilePage widget here
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
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Navigate to Sign In page
              Navigator.pushNamed(context, '/sign-in');
            },
            child: const Text(
              'Sign In',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          TextButton(
            onPressed: () {
              // Navigate to Sign Up page
              Navigator.pushNamed(context, '/sign-up');
            },
            child: const Text(
              'Sign Up',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          const SizedBox(width: 10), // Add some space between buttons
          const IconButton(
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
      body: _widgetOptions[_selectedIndex], // Display the selected widget
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
            label: ' Profile',
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


class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}
class _ProductPageState extends State<ProductPage> {
  late Future<List<Product>> products;

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((product) {
        return Product.fromJson(product);
      }).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    super.initState();
    products = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Page'),
      ),
      body: FutureBuilder<List<Product>>(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final productList = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two products per row
                childAspectRatio: 0.6, // Adjust aspect ratio for better layout
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              padding: const EdgeInsets.all(10),
              itemCount: productList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to the ProductDetailPage when a product is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(product: productList[index]),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Image with Add to Cart Icon
                        Stack(
                          children: [
                            // Product Image
                            SizedBox(
                              height: 200, // Set a fixed height for the image
                              width: double.infinity, // Set width to match the card
                              child: Image.network(
                                productList[index].image,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Add to Cart Icon
                            Positioned(
                              right: 8,
                              bottom: 8,
                              child: GestureDetector(
                                onTap: () {
                                  // Add product to cart
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Added to cart!')),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Icon(
                                    Icons.add_shopping_cart,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productList[index].name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${productList[index].price.toStringAsFixed(2)} MAD ', // Change to MAD
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}



class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}
class _ProductDetailPageState extends State<ProductDetailPage> {
  bool _isPressed = false; // Track button press state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with Hero Animation
              Hero(
                tag: widget.product.id, // Unique tag for the hero animation
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.product.image,
                    fit: BoxFit.cover,
                    height: 250,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Product Name
              Text(
                widget.product.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),
              // Product Price
              Text(
                '\$${widget.product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Product Description
              Text(
                widget.product.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              // Add to Cart Button with Animation
              Center(
                child: GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      _isPressed = true; // Change state on press down
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      _isPressed = false; // Change state on press up
                    });
                    // Handle add to cart action
                     ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to cart!')),
                    );
                  },
                  onTapCancel: () {
                    setState(() {
                      _isPressed = false; // Reset state if the tap is canceled
                    });
                  },
                  child: Container(
                    width: 150,
                    margin: const EdgeInsets.symmetric(horizontal: 20), // Add margin around the button
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(vertical: 16), // Padding inside the button
                      decoration: BoxDecoration(
                        color: _isPressed ? const Color.fromARGB(255, 20, 67, 3) : Colors.orange,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: _isPressed
                            ? []
                            : [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
              crossAxisAlignment: CrossAxisAlignment.end,
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


class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}
class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true; // For password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Log In Text
                  Image.asset(
                    'assets/icon/icon.png',
                    height: 100,
                  ),
                  const SizedBox(height: 24),

                // Email Field
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email address',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword; // Toggle password visibility
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Sign In Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Simulate a successful sign-in
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Sign In Successful'),
                            content: const Text('You have successfully signed in!'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the alert
                                  // Navigate to the home page
                                  Navigator.of(context).pushReplacementNamed('/home'); // Adjust the route name as needed
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text('Sign In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);


  @override
  State<SignUpPage> createState() => _SignUpPageState();
}
class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;
  bool _obscurePassword = true; // For password visibility
  bool _obscureConfirmPassword = true; // For confirm password visibility
  bool _termsAccepted = false; // Checkbox state


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Log In Text
                  Image.asset(
                    'assets/icon/icon.png',
                    height: 100,
                  ),
                  const SizedBox(height: 24),

                  // First Name and Last Name in same row
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: firstNameController,
                          decoration: const InputDecoration(
                            labelText: 'First Name *',
                            hintText: 'Enter your first name', // Placeholder
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: lastNameController,
                          decoration: const InputDecoration(
                            labelText: 'Last Name *',
                            hintText: 'Enter your last name', // Placeholder
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email *',
                      hintText: 'Enter your email address', // Placeholder
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                 TextFormField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password *',
                      hintText: 'Enter your password', // Placeholder
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password Field
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password *',
                      hintText: 'Re-enter your password', // Placeholder
                      border: const OutlineInputBorder (),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  // Terms and Conditions Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _termsAccepted,
                        onChanged: (value) {
                          setState(() {
                            _termsAccepted = value ?? false;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'I agree to the terms and conditions',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Sign Up Button with Loader
 isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate() && _termsAccepted) {
                              setState(() {
                                isLoading = true;
                              });

                              // Simulate loading
                              await Future.delayed(const Duration(seconds: 2));

                              setState(() {
                                isLoading = false;
                              });

                              // Show Success Alert
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Sign Up Successful'),
                                    content: const Text('You have successfully signed up!'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Close the alert
                                          Navigator.of(context).pushReplacementNamed('/sign-in'); // Navigate to Sign In page
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else if (!_termsAccepted) {
                              // Show alert if terms are not accepted
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Terms Not Accepted'),
                                    content: const Text('You must accept the terms and conditions to sign up.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: const Text('Sign Up'),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Sample user data
  String name = "John Doe";
  String email = "john.doe@example.com";
  String phone = "+1234567890";
  String photoUrl = "https://via.placeholder.com/150"; // Placeholder image

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Photo
            Center(
              child: GestureDetector(
                onTap: () {
                  // Add functionality to change photo
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(photoUrl),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Name
            Text(
              "Name: $name",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            // Email
            Text(
              "Email: $email",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),

            // Phone
            Text(
              "Phone: $phone",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Change Photo Button
            ElevatedButton(
              onPressed: () {
                // Add functionality to change photo
              },
              child: Text("Change Photo"),
            ),
            SizedBox(height: 10),

            // Change Password Button
            ElevatedButton(
              onPressed: () {
                // Add functionality to change password
              },
              child: Text("Change Password"),
            ),
            SizedBox(height: 10),

            // Delete Account Button
            ElevatedButton(
              onPressed: () {
                // Add functionality to delete account
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Delete Account"),
                    content: Text("Are you sure you want to delete your account?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Confirm deletion
                          Navigator.of(context).pop();
                        },
                        child: Text("Yes"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("No"),
                      ),
                    ],
                  ),
                );
              },
              child: Text("Delete Account"),
            ),
          ],
        ),
      ),
    );
  }
}