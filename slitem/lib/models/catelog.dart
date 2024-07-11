import 'package:cloud_firestore/cloud_firestore.dart';

class CatelogModel {
  static List<Item>? items;

  // Get Item by id
  Item getById(int? id) =>
      items!.firstWhere((element) => element.id == id, orElse: null);

  // Get Item by position
  Item getByPosition(int pos) => items![pos];

  // Get all products from Firebase Firestore
  Future<List<Item>> getProducts() async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection('product').get();

    items = querySnapshot.docs.map((documentSnapshot) {
      Map<String, dynamic> data = documentSnapshot.data();
      return Item.fromMap(data);
    }).toList();

    return items!;
  }

  // Stream all products from Firebase Firestore
  Stream<List<Item>> streamProducts() {
    return FirebaseFirestore.instance.collection('product').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Item.fromMap(doc.data())).toList());
  }
}

class Item {
  final int? id;
  final String? name;
  final String? desc;
  final String? desc2;
  final num price;
  final String? color;
  final String? image;
  final String? category;

  Item(
      {this.id,
      this.name,
      this.desc,
      this.desc2,
      required this.price,
      this.color,
      this.category,
      this.image});

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      desc: map['desc'],
      desc2: map['desc2'],
      price: map['price'],
      color: map['color'],
      category: map['category'],
      image: map['image'],
    );
  }

  toMap() => {
        'id': id,
        'name': name,
        'desc': desc,
        'desc2': desc2,
        'price': price,
        'color': color,
        'category': category,
        'image': image,
      };
}
