import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final GlobalKey selfKey;
  const CustomAppBar({Key? key, required this.title, required this.selfKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deviceDetails = MediaQuery.of(context);

    void openBottomSheet() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Colors.black,
            width: 50,
            height: 50,
            child: const Text("Surprise.."),
          );
        },
      );
    }

    return Container(
      width: deviceDetails.size.width,
      key: selfKey,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.3),
      ),
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).systemGestureInsets.top + 20,
          bottom: MediaQuery.of(context).systemGestureInsets.top + 20),
      child: Container(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).systemGestureInsets.top + 20, left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                debugPrint("Add a new task");

                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //     content: Text("Show Bottom Sheet..."),
                //   ),
                // );
                openBottomSheet();
              },
              child: Container(
                margin: const EdgeInsets.only(right: 25),
                child: Icon(
                  Icons.add_circle_outline_sharp,
                  color:
                      const Color.fromRGBO(255, 255, 255, 1).withOpacity(0.8),
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
