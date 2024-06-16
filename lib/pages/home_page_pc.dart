import "package:cha_casa_nova/utils/constants.dart";
import "package:flutter/material.dart";

class HomePagePc extends StatelessWidget {
  const HomePagePc({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Chá de casa nova",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w900,
                color: Constants.secondaryColor,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              "Laís e Nikollas",
              style: TextStyle(
                fontSize: 45,
                fontStyle: FontStyle.italic,
                color: Constants.primaryColor,
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            Text(
              "01/07/2024",
              style: TextStyle(
                fontSize: 40,
                color: Constants.primaryColor,
              ),
            ),
          ],
        ),
        const CircleAvatar(
          backgroundImage: AssetImage("assets/profile.png"),
          radius: 100,
        )
      ],
    );
  }
}
