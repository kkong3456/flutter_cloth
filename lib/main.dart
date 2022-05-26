import 'package:cloth/cloth.dart';
import 'package:cloth/data/api.dart';
import 'package:cloth/data/preference.dart';
import 'package:cloth/data/weather.dart';
import 'package:cloth/location.dart';
import 'package:cloth/util.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LocationData location =
      LocationData(lat: 37.5941904, lng: 126.99552, name: "우리집", x: 0, y: 0);
  List<String> clothes = [
    "assets/img/shirts.png",
    "assets/img/jumper.png",
    "assets/img/pants.png",
  ];

  List<Weather> weather = [];
  List<ClothTmp> tmpCloth = [];

  List<String> sky = [
    "assets/img/sky1.png",
    "assets/img/sky2.png",
    "assets/img/sky3.png",
    "assets/img/sky4.png"
  ];

  List<Color> color = const [
    //배경화면 색깔
    Color(0xFFF78144), //맑음
    Color(0xFF1D9FEA),
    Color(0xFF523DE4),
    Color(0xFF597d9a),
  ];

  List<String> status = [
    "날이 아주좋아요!",
    "산책하기 좋겠어요",
    "오늘은 흐리네요",
    "우산 꼭 챙기세요",
  ];

  int level = 0;

  Weather current;

  void getWeather() async {
    final api = WeatherApi();

    final now = DateTime.now();

    Map<String, int> xy = Utils.latLngToXY(location.lat, location.lng);

    final pref = Preference();
    tmpCloth = await pref.getTmp();

    int time2 = int.parse("${now.hour}10");

    String _time = "";

    if (time2 > 2300) {
      _time = "2300";
    } else if (time2 > 1700) {
      _time = "2000";
    } else if (time2 > 1400) {
      _time = "1400";
    } else if (time2 > 1100) {
      _time = "1100";
    } else if (time2 > 800) {
      _time = "0800";
    } else if (time2 > 500) {
      _time = "0500";
    } else {
      _time = "0200";
    }
    weather = await api.getWeather(
        xy["nx"], xy["ny"], Utils.getFormatTime(DateTime.now()), _time);

    int time = int.parse("${now.hour}00");
    weather.removeWhere((w) => w.time < time); //현재 시 보다 작은 시간들은 삭제

    current = weather.first;

    level = getLevel(current);

    clothes = tmpCloth.firstWhere((t) => t.tmp < current.tmp).cloth;

    setState(() {});
  }

  int getLevel(Weather w) {
    if (w.sky > 8) {
      return 3;
    } else if (w.sky > 5) {
      return 2;
    } else if (w.sky > 2) {
      return 1;
    }
    return 0;
  }

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color[level],
      appBar:
          AppBar(backgroundColor: Colors.transparent, elevation: 0, actions: [
        IconButton(
            icon: Icon(Icons.category),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => ClothPage()));
              getWeather();
            })
      ]),
      body: weather.isEmpty
          ? Container(child: Text("날씨정보를 불러오고있어요"))
          : Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 50,
                  ),
                  Text(
                    "${location.name}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20.0),
                    child: Image.asset(sky[level]),
                    alignment: Alignment.centerRight,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text("${current.tmp}°C",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                          )),
                      Column(
                        children: [
                          Text(
                            "${current.date}",
                            // "${Utils.stringToDateTime(current.date).month}월 ${Utils.stringToDateTime(current.date).day}일",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            status[level],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(
                    height: 30,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10.0),
                    child: const Text(
                      "오늘 어울리는복장을 추천해 드려요",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(clothes.length, (idx) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          clothes[idx],
                          fit: BoxFit.contain,
                        ),
                      );
                    }),
                  ),
                  Container(
                    height: 30,
                  ),
                  Expanded(
                    child: Container(
                      height: 150,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                          weather.length,
                          (idx) {
                            final w = weather[idx];
                            int _level = getLevel(w);

                            return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("${w.tmp}°C",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        )),
                                    Text("${w.pop}%",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        )),
                                    Container(
                                      width: 50.0,
                                      height: 50.0,
                                      child: Image.asset(sky[_level]),
                                    ),
                                    Text("${w.time}",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 10)),
                                  ],
                                ));
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 80,
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          LocationData data = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => LocationPage()));

          if (data != null) {
            location = data;
            print(location);
            getWeather();
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.location_on),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
