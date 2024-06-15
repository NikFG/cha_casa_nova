import "package:flutter/material.dart";

class HomePageMobile extends StatelessWidget {
  const HomePageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Chá de casa nova",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'BlackMango',
            fontWeight: FontWeight.w900,
            color: Color.fromARGB(255, 219, 161, 145),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Laís e Nikollas",
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'BlackMango',
            fontStyle: FontStyle.italic,
            color: Color.fromARGB(255, 112, 89, 83),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          "01/07/2024",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'BlackMango',
            color: Color.fromARGB(255, 112, 89, 83),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        CircleAvatar(
          backgroundImage: AssetImage("assets/profile.png"),
          radius: 100,
        )
      ],
    );
  }
}
