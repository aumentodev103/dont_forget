import 'package:flutter/material.dart';

class SocialIconsWidget extends StatelessWidget {
  const SocialIconsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        GestureDetector(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(50)),
            ),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.transparent,
              child: Image.asset(
                'assets/images/google.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(50)),
            ),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.transparent,
              child: Image.asset(
                'assets/images/facebook.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(50)),
            ),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.transparent,
              child: Image.asset(
                "assets/images/twitter.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
