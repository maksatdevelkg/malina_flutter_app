import 'package:uuid/uuid.dart';

class CartItem {
  final String id;
  final String name;
  final String category;
  final String subcategory;
  final int price;
  final int quantity;
  final String? imageUrl;
  final String? description;

  CartItem({
    String? id,
    required this.name,
    required this.category,
    required this.subcategory,
    required this.price,
    required this.quantity,
    this.imageUrl,
    this.description,
  }) : id = id ?? const Uuid().v4();

  CartItem copyWith({
    int? quantity,
  }) {
    return CartItem(
      id: id,
      name: name,
      category: category,
      subcategory: subcategory,
      price: price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl,
      description: description,
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'subcategory': subcategory,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  /// ✅ Для загрузки из shared_preferences
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      subcategory: json['subcategory'],
      price: json['price'],
      quantity: json['quantity'],
      imageUrl: json['imageUrl'],
      description: json['description'],
    );
  }
}

