import 'package:flutter/material.dart';

class ItemListWidget extends StatelessWidget {
  final GlobalKey customAppBarKey;
  const ItemListWidget({Key? key, required this.customAppBarKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double itemContainerHeight = MediaQuery.of(context).size.height - 111 / 1;
    return Container(
      color: Colors.white,
      height: itemContainerHeight,
      child: GridView.count(
        crossAxisCount: 2,
        children: List.generate(20, (index) {
          return const SizedBox(
            // transform: Matrix4.translationValues(0, -50, 0),
            child: Card(
              color: Colors.blue,
            ),
          );
        }),
      ),
    );
  }
}
