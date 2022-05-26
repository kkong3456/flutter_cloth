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
            return Container(
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
            ));
          }),
        ));
  }
}
