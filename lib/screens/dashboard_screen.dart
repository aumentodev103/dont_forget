import 'package:dont_forget/widgets/custom_app_bar_widget.dart';
import 'package:dont_forget/widgets/item_list_widget.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = "/dashboard";
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey customAppBarKey = GlobalKey();
    return Scaffold(
      body: SizedBox(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red,
                    Colors.purple,
                    Colors.purple,
                    Colors.redAccent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  stops: [0, 0.5, 0.5, 1],
                ),
              ),
            ),
            Column(
              children: [
                CustomAppBar(
                  title: "Your items",
                  selfKey: customAppBarKey,
                ),
                ItemListWidget(customAppBarKey: customAppBarKey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
