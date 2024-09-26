import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/admin/maindashboard.dart';
import 'firebase_options.dart';
final CartModel cart = CartModel();


class CartModel {
  final List<Product> _products = [];

  void addProduct(Product product) {
    _products.add(product);
  }

  void removeProduct(Product product) {
    _products.remove(product);
  }

  void clearCart() {
    _products.clear();
  }

  double getTotalPrice() {
    return _products.fold(0.0, (total, current) => total + current.price);
  }

  List<Product> getProducts() {
    return _products;
  }

  int getProductCount() {
    return _products.length;
  }

  bool containsProduct(Product product) {
    return _products.contains(product);
  }
}

class Product {
  final String name;
  final String imageAssetPath;
  final double price;

  Product({
    required this.name,
    required this.imageAssetPath,
    required this.price,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Product &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              imageAssetPath == other.imageAssetPath &&
              price == price;

  @override
  int get hashCode => name.hashCode ^ imageAssetPath.hashCode ^ price.hashCode;
}



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('darkMode') ?? false;
  runApp(MirchilyApp(isDarkMode: isDarkMode));
}

class MirchilyApp extends StatefulWidget {
  final bool isDarkMode;
  MirchilyApp({required this.isDarkMode});

  @override
  _MirchilyAppState createState() => _MirchilyAppState();
}

class _MirchilyAppState extends State<MirchilyApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  void _toggleTheme(bool value) async {
    setState(() {
      _isDarkMode = value;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', _isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mirchily',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: WelcomeScreen(
        toggleTheme: _toggleTheme,
        isDarkMode: _isDarkMode,
      ),
    );
  }
}


class WelcomeScreen extends StatelessWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  WelcomeScreen({required this.toggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Mirchily'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Switch(
            value: isDarkMode,
            onChanged: toggleTheme,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/finalback.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '𝓜𝓲𝓻𝓬𝓱𝓲𝓵𝔂🌶️',
                style: TextStyle(
                  fontSize: 47,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('𝓛𝓸𝓰𝓲𝓷'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                child: Text('𝓢𝓲𝓰𝓷𝓾𝓹'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    createSampleAdminUser(); // Call to create sample admin user
  }

  Future<void> createSampleAdminUser() async {
    try {
      // Create a sample admin user if it doesn't exist
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: 'admin@gmail.com',
        password: '123456',
      );
      print('Sample admin user created: ${userCredential.user?.email}');
    } catch (e) {
      // Handle the error if the user already exists
      if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
        print('Admin user already exists.');
      } else {
        print('Error creating admin user: $e');
      }
    }
  }

  Future<void> loginUser() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if the user is admin
      if (email == 'admin@gmail.com' && password == "123456") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPanel()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomeBackScreen()),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('𝓛𝓸𝓰𝓲𝓷'),
        backgroundColor: Colors.red,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/finalback.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  onChanged: (value) {
                    email = value;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  onChanged: (value) {
                    password = value;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('𝓛𝓸𝓰𝓲𝓷'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: loginUser,
                ),
                TextButton(
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResetPasswordScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  String name = '';
  String email = '';
  String mobileNumber = '';
  String password = '';

  Future<void> registerUser() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ThankYouScreen()),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Signup failed. Please try again later.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('𝓢𝓲𝓰𝓷𝓾𝓹'),
        backgroundColor: Colors.red,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/finalback.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  onChanged: (value) {
                    email = value;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  onChanged: (value) {
                    mobileNumber = value;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  onChanged: (value) {
                    password = value;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('𝓟𝓻𝓸𝓬𝓮𝓮𝓭'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: registerUser,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ThankYouScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thank You'),
        backgroundColor: Colors.red,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/finalback.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('𝕋𝕙𝕒𝕟𝕜 𝕪𝕠𝕦 𝕗𝕠𝕣 𝕛𝕠𝕚𝕟𝕚𝕟𝕘 𝕥𝕙𝕖 𝕄𝕚𝕣𝕔𝕙𝕚𝕝𝕪 𝕗𝕒𝕞𝕚𝕝𝕪!',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('𝓝𝓮𝔁𝓽'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PreferenceScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeBackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Back'),
        backgroundColor: Colors.red,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/finalback.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '𝕄𝕚𝕣𝕔𝕙𝕚𝕝𝕪 𝕨𝕖𝕝𝕔𝕠𝕞𝕖𝕤 𝕪𝕠𝕦 𝕓𝕒𝕔𝕜!',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('𝓝𝓮𝔁𝓽'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PreferenceScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ... (continue with PreferenceScreen, ResetPasswordScreen, Product model, and ProductListScreen) ...
class PreferenceScreen extends StatefulWidget {
  @override
  _PreferenceScreenState createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  String _choice = '';
  int _countdown = 5;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer?.cancel();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ProductListScreen(category: _choice),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Preference'),
        backgroundColor: Colors.red,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/finalback.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  visualDensity: VisualDensity(horizontal: 0, vertical: 4),
                  title: Text(
                    '𝓥𝓮𝓰',
                    style: TextStyle(fontSize: 28, color: Colors.deepOrange),
                  ),
                  leading: Radio<String>(
                    value: 'Veg',
                    groupValue: _choice,
                    onChanged: (String? value) {
                      setState(() {
                        _choice = value!;
                        _startCountdown();
                      });
                    },
                  ),
                ),
                ListTile(
                  visualDensity: VisualDensity(horizontal: 0, vertical: 4),
                  title: Text(
                    '𝓝𝓸𝓷-𝓥𝓮𝓰',
                    style: TextStyle(fontSize: 28, color: Colors.deepOrange),
                  ),
                  leading: Radio<String>(
                    value: 'Non-Veg',
                    groupValue: _choice,
                    onChanged: (String? value) {
                      setState(() {
                        _choice = value!;
                        _startCountdown();
                      });
                    },
                  ),
                ),
                if (_choice.isNotEmpty)
                  Column(
                    children: [
                      Text(
                        '𝑻𝒉𝒂𝒏𝒌 𝒚𝒐𝒖 𝒇𝒐𝒓 𝒍𝒆𝒕𝒕𝒊𝒏𝒈 𝒖𝒔 𝒌𝒏𝒐𝒘! 𝑾𝒂𝒊𝒕 𝒘𝒉𝒊𝒍𝒆 𝒘𝒆 𝒑𝒓𝒆𝒑𝒂𝒓𝒆 𝒚𝒐𝒖𝒓 𝒂𝒑𝒑 𝒆𝒙𝒑𝒆𝒓𝒊𝒆𝒏𝒄𝒆 𝒂𝒄𝒄𝒐𝒓𝒅𝒊𝒏𝒈 𝒕𝒐 𝒚𝒐𝒖𝒓 𝒄𝒉𝒐𝒊𝒄𝒆.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Preparing in $_countdown seconds...',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ResetPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
        backgroundColor: Colors.red,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/finalback.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Enter your registered email',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('𝓝𝓮𝔁𝓽'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PreferenceScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// ProductListScreen class
class ProductListScreen extends StatelessWidget {
  final String category;
  final List<Product> vegProducts = [
    Product(name: 'Paneer Lababdar', imageAssetPath: 'assets/images/paneer.jpg', price: 60),
    Product(name: 'Sambar Masala', imageAssetPath: 'assets/images/sambar.jpg', price: 45),
    Product(name: 'Shahi Biryani Masala', imageAssetPath: 'assets/images/shahibiryani.jpg', price: 70),
    Product(name: 'Paneer Chilly Masala', imageAssetPath: 'assets/images/paneerchilly.jpg', price: 65),
  ];

  final List<Product> nonVegProducts = [
    Product(name: 'Butter Chicken', imageAssetPath: 'assets/images/butter.jpg', price: 60),
    Product(name: 'Chicken Angara', imageAssetPath: 'assets/images/angara.jpg', price: 70),
    Product(name: 'Tandoori Chicken', imageAssetPath: 'assets/images/tandoori.jpg', price: 40),
    Product(name: 'Chicken Chilly', imageAssetPath: 'assets/images/paneerchilly.jpg', price: 65),
  ];

  ProductListScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Product> products = category == 'Veg' ? vegProducts : nonVegProducts;

    return Scaffold(
      appBar: AppBar(
        title: Text(category + ' Products'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: ImageIcon(AssetImage("assets/images/cart.jpg")),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.8,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          Product product = products[index];
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Image.asset(
                    product.imageAssetPath,
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '₹${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      cart.addProduct(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${product.name} added to cart')),
                      );
                    },
                    child: Text('Add to Cart'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      cart.addProduct(product);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PaymentPage()),
                      );
                    },
                    child: Text('Buy Now'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Product> cartProducts = cart.getProducts();

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        backgroundColor: Colors.red,
      ),
      body: ListView.separated(
        itemCount: cartProducts.length,
        separatorBuilder: (context, index) => Divider(color: Colors.grey),
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.asset(cartProducts[index].imageAssetPath),
            title: Text(cartProducts[index].name),
            subtitle: Text('₹${cartProducts[index].price}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                cart.removeProduct(cartProducts[index]);
                (context as Element).markNeedsBuild();
              },
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PaymentPage()),
            );
          },
          child: Text('Continue to Payment', style: TextStyle(color: Colors.white)),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black),
          ),
        ),
      ),
    );
  }
}class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedMethod = 'ICICI_Credit';

  @override
  Widget build(BuildContext context) {
    double totalAmount = cart.getTotalPrice();

    return Scaffold(
      appBar: AppBar(
          title: Text('Payment Methods'),
          backgroundColor: Colors.red
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Order Amount: ₹${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          RadioListTile<String>(
            title: const Text('ICICI Credit'),
            value: 'ICICI_Credit',
            groupValue: _selectedMethod,
            onChanged: (value) {
              setState(() {
                _selectedMethod = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Cash On Delivery'),
            value: 'COD',
            groupValue: _selectedMethod,
            onChanged: (value) {
              setState(() {
                _selectedMethod = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('UPI'),
            value: 'UPI',
            groupValue: _selectedMethod,
            onChanged: (value) {
              setState(() {
                _selectedMethod = value!;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: ElevatedButton(
              onPressed: () {
                // Handle payment action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Payment processed successfully!')),
                );
                cart.clearCart();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Proceed to Pay', style: TextStyle(color: Colors.white)),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}