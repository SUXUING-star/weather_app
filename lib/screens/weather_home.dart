// weather_home.dart

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/weather_data.dart';
import '../widgets/weather_header.dart';
import '../widgets/weather_details.dart';
import '../widgets/Loading_widget.dart';
import '../requests/permission_request.dart';
import '../config/env_config.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({Key? key}) : super(key: key);

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final List<Map<String, String>> majorCities = [
    {"name": "北京", "id": "101010100"},
    {"name": "上海", "id": "101020100"},
    {"name": "广州", "id": "101280101"},
    {"name": "深圳", "id": "101280601"},
    {"name": "成都", "id": "101270101"}
  ];

  LocationData? _currentPosition;
  WeatherData? weatherData;
  bool isLoading = false; // 改为默认false
  String? errorMessage;

  Future<void> _getWeatherDataByCity(String locationId) async {
    setState(() => isLoading = true);

    try {
      final weatherResponse = await http.get(Uri.parse(
          'https://devapi.qweather.com/v7/weather/now?location=$locationId&key=${EnvConfig.apiKey}'))
          .timeout(const Duration(seconds: 10));

      if (weatherResponse.statusCode == 200) {
        final weatherJson = json.decode(weatherResponse.body);
        if (weatherJson['code'] == '200') {
          setState(() {
            weatherData = WeatherData.fromJson({
              'now': weatherJson['now'],
              'location': {
                'name': majorCities
                    .firstWhere((city) => city['id'] == locationId)['name']
              }
            });
            isLoading = false;
            errorMessage = null;
          });
          return;
        }
      }
      throw Exception('API请求失败');
    } catch (e) {
      setState(() {
        errorMessage = "获取天气数据失败: $e";
        isLoading = false;
      });
    }
  }

  Future<void> _getWeatherData() async {
    if (_currentPosition == null ||
        _currentPosition!.longitude == null ||
        _currentPosition!.latitude == null) {
      setState(() {
        errorMessage = "无法获取位置信息";
        isLoading = false;
        _getWeatherDataByCity('101010100'); // 北京城市编码
      });
      return;
    }

    const apiKey = '1a6cd3b2d58849afa150b13ba93be675';
    final location = '${_currentPosition!.longitude!.toStringAsFixed(4)},${_currentPosition!.latitude!.toStringAsFixed(4)}';

    try {
      final futures = await Future.wait([
        http.get(Uri.parse('https://devapi.qweather.com/v7/weather/now?location=$location&key=$apiKey')),
        http.get(Uri.parse('https://geoapi.qweather.com/v2/city/lookup?location=$location&key=$apiKey'))
      ]).timeout(const Duration(seconds: 10));

      final weatherResponse = futures[0];
      final locationResponse = futures[1];

      if (weatherResponse.statusCode != 200 || locationResponse.statusCode != 200) {
        throw Exception('API请求失败: ${weatherResponse.statusCode}, ${locationResponse.statusCode}');
      }

      final weatherJson = json.decode(weatherResponse.body);
      final locationJson = json.decode(locationResponse.body);

      print('Weather API Response: $weatherJson'); // 添加调试日志
      print('Location API Response: $locationJson'); // 添加调试日志

      if (weatherJson['code'] != '200' || locationJson['code'] != '200') {
        throw Exception('API返回错误: ${weatherJson['code']}, ${locationJson['code']}');
      }

      if (locationJson['location'] == null || locationJson['location'].isEmpty) {
        throw Exception('未能获取到位置信息');
      }

      setState(() {
        weatherData = WeatherData.fromJson({
          'now': weatherJson['now'],
          'location': locationJson['location'][0],
        });
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        errorMessage = "获取天气数据失败: $e";
        isLoading = false;
      });
    }
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              errorMessage?.replaceAll('[object ProgressEvent]', '') ?? "未知错误"),
          const SizedBox(height: 20),
          DropdownButton<String>(
            hint: const Text('选择城市'),
            items: majorCities
                .map((city) => DropdownMenuItem(
                      value: city['id'],
                      child: Text(city['name']!),
                    ))
                .toList(),
            onChanged: (String? cityId) {
              if (cityId != null) {
                _getWeatherDataByCity(cityId);
              }
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isLoading = true;
                errorMessage = null;
                weatherData = null;
              });
            },
            child: const Text("重试定位"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return Scaffold(body: _buildErrorWidget());
    }

    if (weatherData != null) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  weatherData!.location['name'],
                  style: const TextStyle(color: Colors.white),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue[700]!,
                        Colors.blue[500]!,
                      ],
                    ),
                  ),
                  child: WeatherHeader(data: weatherData!),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  WeatherDetailItem(
                    title: '湿度',
                    value: '${weatherData!.now['humidity']}%',
                    icon: Icons.water_drop,
                  ),
                  WeatherDetailItem(
                    title: '风速',
                    value: '${weatherData!.now['windSpeed']} km/h',
                    icon: Icons.air,
                  ),
                  WeatherDetailItem(
                    title: '风向',
                    value: weatherData!.now['windDir'],
                    icon: Icons.navigation,
                  ),
                  WeatherDetailItem(
                    title: '气压',
                    value: '${weatherData!.now['pressure']} hPa',
                    icon: Icons.speed,
                  ),
                ]),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          LocationPermissionRequest(
            onLocationReceived: (LocationData? position) {
              setState(() {
                _currentPosition = position;
                isLoading = true;
              });
              _getWeatherData();
            },
            onError: (String error) {
              setState(() {
                errorMessage = error;
                isLoading = false;
              });
            },
          ),
          if (isLoading) const LoadingWidget(message: "正在获取天气数据..."),
        ],
      ),
    );
  }
}
