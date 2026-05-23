import 'package:flutter/material.dart';

// Ürün data structure
class Product {
  final String name;
  final double price;
  final String imagePath;
  final String description;

  Product({required this.name, required this.price, required this.imagePath, required this.description});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: json['price'],
      imagePath: json['imagePath'],
      description: json['description'],
    );
  }
}

List<Product> cartItems = [];

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Katalog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      home: const DiscoverScreen(),
    );
  }
}

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  // Sahte json api ve ürünler
  final List<Map<String, dynamic>> jsonData = [
    {
      'name': 'AirPods Pro 2',
      'price': 8500.0,
      'imagePath': 'assets/airpods.jpg',
      'description': 'Aktif gürültü engelleme teknolojisi ile kristal netliğinde ses deneyimi sunan yeni nesil kablosuz kulaklık.'
    },
    {
      'name': 'AirPods Max',
      'price': 15000.0,
      'imagePath': 'assets/airpodsmax.jpg',
      'description': 'Yüksek kaliteli ses ve üstün konforu bir araya getiren premium kulak üstü kulaklık tasarımı.'
    },
    {
      'name': 'HomePod Mini',
      'price': 3500.0,
      'imagePath': 'assets/homepodmini.jpg',
      'description': 'Evinizin her köşesini 360 derece ses ile dolduran akıllı ve kompakt ev hoparlörü.'
    },
    {
      'name': 'iPhone 15 Pro',
      'price': 65000.0,
      'imagePath': 'assets/iphone15.jpg',
      'description': 'Titanyum kasa, gelişmiş kamera sistemi ve A17 Pro çip ile donatılmış en güçlü akıllı telefon.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Product> products = jsonData.map((data) => Product.fromJson(data)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keşfet'),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart_outlined),
                if (cartItems.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(cartItems.length.toString(), style: const TextStyle(fontSize: 10, color: Colors.white)),
                    ),
                  )
              ],
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen())).then((_) => setState(() {}));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.65,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Küçük görsel
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          product.imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('₺ ${product.price}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product))).then((_) => setState(() {}));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                        child: const Text('İncele'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Büyük görsel
            Center(
              child: SizedBox(
                height: 250,
                child: Image.asset(
                  product.imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 100),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(product.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('₺ ${product.price}', style: const TextStyle(fontSize: 22, color: Colors.blueAccent, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            const Text('Ürün Açıklaması', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            // Ürün açıklaması
            Text(product.description, style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5)),
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    cartItems.add(product);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ürün sepete eklendi!', style: TextStyle(color: Colors.white))));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                  child: const Text('Sepete Ekle', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sepetim')),
      body: cartItems.isEmpty
          ? const Center(child: Text('Sepetiniz boş', style: TextStyle(fontSize: 18, color: Colors.grey)))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  // Sepetteki küçük görsel
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.asset(
                      item.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
                    ),
                  ),
                  title: Text(item.name),
                  subtitle: Text('₺ ${item.price}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        cartItems.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}