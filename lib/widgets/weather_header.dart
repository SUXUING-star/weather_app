import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/weather_data.dart';

class WeatherHeader extends StatelessWidget {
  final WeatherData data;

  const WeatherHeader({Key? key, required this.data}) : super(key: key);

  String _getWeatherIcon(String iconId) {
    final icons = {
      'sunny': '''
        <circle cx="150" cy="150" r="60" fill="#FFD700"/>
        <g stroke="#FFD700" stroke-width="15">
          <line x1="150" y1="50" x2="150" y2="20"/>
          <line x1="150" y1="280" x2="150" y2="250"/>
          <line x1="50" y1="150" x2="20" y2="150"/>
          <line x1="280" y1="150" x2="250" y2="150"/>
          <line x1="80" y1="80" x2="60" y2="60"/>
          <line x1="240" y1="240" x2="220" y2="220"/>
          <line x1="80" y1="220" x2="60" y2="240"/>
          <line x1="240" y1="60" x2="220" y2="80"/>
        </g>
      ''',
      'cloudy': '''
        <circle cx="100" cy="120" r="40" fill="#FFD700"/>
        <path d="M80,160 Q140,130 180,160 Q220,190 180,220 H80 Q40,190 80,160" fill="#E0E0E0"/>
      ''',
      'overcast': '''
        <path d="M60,140 Q120,110 160,140 Q200,170 160,200 H60 Q20,170 60,140" fill="#9E9E9E"/>
        <path d="M120,120 Q180,90 220,120 Q260,150 220,180 H120 Q80,150 120,120" fill="#757575"/>
      ''',
      'rainy': '''
        <path d="M80,120 Q140,90 180,120 Q220,150 180,180 H80 Q40,150 80,120" fill="#9E9E9E"/>
        <g stroke="#4FC3F7" stroke-width="3">
          <line x1="100" y1="200" x2="90" y2="230"/>
          <line x1="140" y1="200" x2="130" y2="230"/>
          <line x1="180" y1="200" x2="170" y2="230"/>
        </g>
      ''',
      'snowy': '''
        <path d="M80,120 Q140,90 180,120 Q220,150 180,180 H80 Q40,150 80,120" fill="#9E9E9E"/>
        <g fill="#E0E0E0">
          <circle cx="100" cy="210" r="5"/>
          <circle cx="140" cy="220" r="5"/>
          <circle cx="180" cy="210" r="5"/>
        </g>
      '''
    };
    return icons[iconId] ?? icons['sunny'] ?? '';
  }

  String _getWeatherIconId(String weather) {
    final weatherMap = {
      '晴': 'sunny',
      '多云': 'cloudy',
      '阴': 'overcast',
      '小雨': 'rainy',
      '中雨': 'rainy',
      '大雨': 'rainy',
      '雪': 'snowy',
      '晴れ': 'sunny',
      '曇り': 'cloudy',
    };
    return weatherMap[weather] ?? 'sunny';
  }

  String _getWeatherDescription(String weather) {
    final descriptions = {
      '晴': '天气晴朗,适合外出活动',
      '多云': '天空有云,温度适宜',
      '阴': '天色较暗,记得开灯',
      '小雨': '外出记得带伞',
      '中雨': '雨势渐大,谨慎出行',
      '大雨': '雨势较大,注意防护',
      '雪': '注意保暖,小心路滑',
      '晴れ': '天气晴朗,适合外出活动',
      '曇り': '天空有云,温度适宜',
    };
    return descriptions[weather] ?? '天气变幻莫测';
  }

  @override
  Widget build(BuildContext context) {
    String weatherText = data.now['text'];
    String iconId = _getWeatherIconId(weatherText);

    return SingleChildScrollView(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/weather_icons/icon.png',
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '由和风天气提供支持',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  '${data.now['temp']}°',
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
                Text(
                  weatherText,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '体感温度: ${data.now['feelsLike']}°',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _getWeatherDescription(weatherText),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 60,
            right: 20,
            child: SvgPicture.string(
              '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 300 300">
                 ${_getWeatherIcon(iconId)}
               </svg>''',
              width: 100,
              height: 100,
            ),
          ),
        ],
      ),
    );
  }
}