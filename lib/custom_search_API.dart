import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(ProductSearchApp());
}

class ProductSearchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductSearchScreen(),
    );
  }
}

class ProductSearchScreen extends StatefulWidget {
  @override
  _ProductSearchScreenState createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  String imageUrl = '';
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;

  Future<void> fetchProductImage(String query) async {
    setState(() {
      isLoading = true;
    });

    // Replace YOUR_API_KEY and YOUR_CX with your actual API Key and Search Engine ID
    String apiUrl = 'https://www.googleapis.com/customsearch/v1?q=$query&searchType=image&cx=c63fff3e039f04940&key=AIzaSyAsr-5ntBOpkjiek7pzBfLpOsBk1gdEHu8';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        if (data['items'] != null && data['items'].length > 0) {
          imageUrl = data['items'][0]['link'];  // Getting the first image link from the search results
        } else {
          imageUrl = '';
        }
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter product name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                fetchProductImage(_controller.text);
              },
              child: Text('Search'),
            ),
            SizedBox(height: 20),
            if (isLoading) CircularProgressIndicator(),
            if (imageUrl.isNotEmpty)
              Column(
                children: [
                  Text('Product Image:'),
                  SizedBox(height: 10),
                  Image.network(imageUrl),
                ],
              )
            else if (!isLoading && imageUrl.isEmpty)
              Text('No image found for this product'),
          ],
        ),
      ),
    );
  }
}
