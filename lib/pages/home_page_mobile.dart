import "package:cha_casa_nova/utils/constants.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:maps_launcher/maps_launcher.dart";

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
          future: db.collection("horario").doc("irgHtBu9UDpmgCfK0kwE").get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox(
                width: 0,
                height: 0,
              );
            }
            return Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_month),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    snapshot.data?["data"],
                    style: TextStyle(
                      fontSize: 20,
                      color: Constants.primaryColor,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.watch_later_outlined),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    snapshot.data?["hora"],
                    style: TextStyle(
                      fontSize: 20,
                      color: Constants.primaryColor,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      MapsLauncher.launchQuery(
                          'RUA NICARÁGUA, 951, SANTA ROSA - DIVINÓPOLIS');
                    },
                    icon: Icon(Icons.pin_drop),
                  ),
                  Text(
                    "RUA NICARÁGUA, 951, SANTA ROSA - DIVINÓPOLIS",
                    style: TextStyle(
                        color: Color.fromARGB(255, 112, 89, 83), fontSize: 12),
                  ),
                ],
              )
            ]);
          },
        ),
        const CircleAvatar(
          backgroundImage: AssetImage("assets/profile.png"),
          radius: 90,
        )
      ],
    );
  }
}
