import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminViewOrders extends StatefulWidget {
  const AdminViewOrders({Key? key}) : super(key: key);

  @override
  _AdminViewOrdersState createState() => _AdminViewOrdersState();
}

class _AdminViewOrdersState extends State<AdminViewOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var document = snapshot.data!.docs[index];
              var data = document.data() as Map<String, dynamic>;
              var name = data['name'];
              var phone = data['phone_number'];
              var address = data['address'];
              var postalCode = data['postal_code'];
              var email = data['email'];
              var total = data['total_amount'];

              return Card(
                elevation: 4.0,
                margin: EdgeInsets.all(16.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: $name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Phone: $phone',
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Address: $address',
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Postal Code: $postalCode',
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Email: $email',
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Total: ${total.toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Confirm Accept'),
                                    content: Text(
                                        'Are you sure you want to accept this order?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('No'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Yes'),
                                        onPressed: () async {
                                          // Send email to confirm acceptance
                                          String url =
                                              'mailto:$email?subject=Order Accepted&body=Your order has been accepted.';
                                          await launch(url);

                                          // Update order status in Firestore
                                          await FirebaseFirestore.instance
                                              .collection('orders')
                                              .doc(document.id)
                                              .update({'status': 'Accepted'});

                                          // Close dialog box and show success snackbar
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content:
                                                      Text('Order Accepted')));
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text('Accept'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Confirm Reject'),
                                    content: Text(
                                        'Are you sure you want to reject this order?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('No'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Yes'),
                                        onPressed: () async {
                                          // Send email to confirm rejection
                                          String url =
                                              'mailto:$email?subject=Order Rejected&body=Your order has been rejected.';
                                          await launch(url);
                                          // Update order status in Firestore
                                          await FirebaseFirestore.instance
                                              .collection('orders')
                                              .doc(document.id)
                                              .update({'status': 'Rejected'});

                                          // Close dialog box and show success snackbar
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content:
                                                      Text('Order Rejected')));
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text('Reject'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
