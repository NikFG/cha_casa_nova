import "package:cha_casa_nova/utils/constants.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";

class HomePageMobile extends StatelessWidget {
  const HomePageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore db = FirebaseFirestore.instance;
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
        FutureBuilder(
          future:
          db.collection("horario").doc("irgHtBu9UDpmgCfK0kwE").get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox(
                width: 0,
                height: 0,
              );
            }
            return Text(
              snapshot.data?["data"],
              style: TextStyle(
                fontSize: 20,
                color: Constants.primaryColor,
              ),
            );
          },
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
