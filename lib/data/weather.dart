class Weather {
  String date;
  int time;
  int pop;
  int pty;
  String pcp;
  int sky;
  double wsd;
  int tmp;
  int reh;

  Weather(
      {this.date,
      this.time,
      this.pop,
      this.pty,
      this.pcp,
      this.sky,
      this.wsd,
      this.tmp,
      this.reh});

  factory Weather.formJson(Map<String, dynamic> data) {
    return Weather(
      date: data["fcstDate"],
      time: int.tryParse(data["fcstTime"] ?? "") ?? 0,
      pop: int.tryParse(data["POP"] ?? "") ?? 0,
      pty: int.tryParse(data["PTY"] ?? "") ?? 0,
      sky: int.tryParse(data["SKY"] ?? "") ?? 0,
      wsd: double.tryParse(data["WSD"] ?? "") ?? 0,
    );
  }
}
