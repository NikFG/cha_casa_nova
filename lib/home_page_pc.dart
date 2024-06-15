import "package:flutter/material.dart";

class HomePagePc extends StatelessWidget {
  const HomePagePc({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Chá de casa nova",
              style: TextStyle(
                fontSize: 50,
                fontFamily: 'BlackMango',
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 219, 161, 145),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              "Laís e Nikollas",
              style: TextStyle(
                fontSize: 45,
                fontFamily: 'BlackMango',
                fontStyle: FontStyle.italic,
                color: Color.fromARGB(255, 112, 89, 83),
              ),
            ),
            SizedBox(
              height: 70,
            ),
            Text(
              "01/07/2024",
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'BlackMango',
                color: Color.fromARGB(255, 112, 89, 83),
              ),
            ),
          ],
        ),
        CircleAvatar(
          backgroundImage: AssetImage("assets/profile.png"),
          radius: 100,
        )
      ],
    );
  }
}
