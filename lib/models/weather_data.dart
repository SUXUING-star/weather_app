class WeatherData {
  final Map<String, dynamic> now;
  final Map<String, dynamic> location;

  WeatherData({required this.now, required this.location});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      now: json['now'] as Map<String, dynamic>,
      location: json['location'] as Map<String, dynamic>,
    );
  }
}