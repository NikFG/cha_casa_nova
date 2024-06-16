import "package:cha_casa_nova/utils/constants.dart";
import "package:flutter/material.dart";

class HomePageMobile extends StatelessWidget {
  const HomePageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Chá de casa nova",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
           
            fontWeight: FontWeight.w900,
            color: Constants.secondaryColor,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          "Laís e Nikollas",
          style: TextStyle(
            fontSize: 25,
           
            fontStyle: FontStyle.italic,
            color: Constants.primaryColor,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          "01/07/2024",
          style: TextStyle(
            fontSize: 20,
           
            color:Constants.primaryColor,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const CircleAvatar(
          backgroundImage: AssetImage("assets/profile.png"),
          radius: 90,
        )
      ],
    );
  }
}
