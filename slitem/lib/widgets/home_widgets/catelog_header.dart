import 'package:shared_preferences/shared_preferences.dart';
import 'package:slitem/widgets/home_widgets/profilepage.dart';
import 'package:slitem/widgets/themes.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CatelogHeader extends StatefulWidget {
  final String email;
  final String userId;

  const CatelogHeader({Key? key, required this.email, required this.userId})
      : super(key: key);

  @override
  _CatelogHeaderState createState() => _CatelogHeaderState();
}

class _CatelogHeaderState extends State<CatelogHeader> {
  bool state = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfilePage(email: widget.email, userId: widget.userId),
                  ),
                );
              },
              icon: Icon(Icons.person),
            ),
            SizedBox(width: 10),
            Text(
              'SL ITEMS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: context.theme.accentColor,
              ),
              textScaleFactor: 3,
            ),
            Flexible(child: ChangeThemeButton()),
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  icon: Icon(Icons.logout),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          'Products',
          style: TextStyle(
            color: context.theme.accentColor,
          ),
          textScaleFactor: 1.5,
        ),
      ],
    );
  }
}
