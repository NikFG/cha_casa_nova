import "package:cha_casa_nova/utils/constants.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:maps_launcher/maps_launcher.dart";

class HomePagePc extends StatelessWidget {
  const HomePagePc({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore db = FirebaseFirestore.instance;
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
                return Column(
                  children: [
                    Text(
                      snapshot.data?["data"],
                      style: TextStyle(
                        fontSize: 40,
                        color: Constants.primaryColor,
                      ),
                    ),
                    Text(
                      snapshot.data?["hora"],
                      style: TextStyle(
                        fontSize: 40,
                        color: Constants.primaryColor,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "RUA NICARÁGUA, 951, SANTA ROSA - DIVINÓPOLIS",
                          style:
                              TextStyle(color: Color.fromARGB(255, 112, 89, 83), fontSize: 30),
                        ),
                        IconButton(
                            onPressed: () {
                              MapsLauncher.launchQuery(
                                  'RUA NICARÁGUA, 951, SANTA ROSA - DIVINÓPOLIS');
                            },
                            icon: Icon(Icons.pin_drop))
                      ],
                    ),
                  ],
                );
              },
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
