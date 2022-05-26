import 'package:cloth/data/preference.dart';
import 'package:cloth/data/weather.dart';
import 'package:flutter/material.dart';

class ClothPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ClothPageState();
  }
}

class _ClothPageState extends State<ClothPage> {
  List<ClothTmp> clothes = [];

  List<List<String>> sets = [
    ["assets/img/jumper.png", "assets/img/long.png", "assets/img/shirts.png"],
    [
      "assets/img/jumper1.png",
      "assets/img/skirts1.png",
      "assets/img/shirts1.png"
    ],
  ];

  void getCloth() async {
    final pref = Preference();
    clothes = await pref.getTmp();
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    getCloth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: List.generate(clothes.length, (idx) {
            return InkWell(
                child: Container(
                    child: Column(
                  children: [
                    Text("${clothes[idx].tmp}°C "),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        clothes[idx].cloth.length,
                        (_idx) {
                          return Container(
                              padding: const EdgeInsets.all(8),
                              width: 100,
                              height: 100,
                              child: Image.asset(
                                clothes[idx].cloth[_idx],
                                fit: BoxFit.contain,
                              ));
                        },
                      ),
                    ),
                  ],
                )),
                onTap: () {
                  showDialog(
                      context: context,
                      // ignore: missing_return
                      builder: (ctx) {
                        return AlertDialog(
                          content: Column(
                            children: List.generate(sets.length, (_idx) {
                              return InkWell(
                                  child: Container(
                                      child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: List.generate(sets[_idx].length,
                                        (__idx) {
                                      return Container(
                                          padding: const EdgeInsets.all(8),
                                          width: 50,
                                          height: 50,
                                          child: Image.asset(
                                            sets[_idx][__idx],
                                            fit: BoxFit.contain,
                                          ));
                                    }),
                                  )),
                                  onTap: () async {
                                    clothes[idx].cloth = sets[_idx];
                                    final pref = Preference();
                                    pref.setTmp(clothes[idx]);
                                    setState(() {});
                                  });
                            }),
                          ),
                          actions: [
                            TextButton(
                              child: Text("닫기"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                });
          }),
        ));
  }
}
