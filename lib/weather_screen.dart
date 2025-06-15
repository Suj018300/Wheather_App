import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secreat.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double tempC = 0;
  double tempF = 0;
  
    Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
    String cityName= 'Kalyān,in';
    final res = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey&units=metric'));

    final data = jsonDecode(res.body);

    if (data['cod']!= '200') {
      throw 'An error occurred';
    }
    return data;
    } catch (e) {
      throw e.toString();
    }
  }


  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kalyan Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black26,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                
              });
            },
            icon: Icon(
              Icons.refresh
            )
          )
        ],
      ),

      body:// (tempC == 0 && tempF == 0) ? const CircularProgressIndicator(): 
      FutureBuilder(
        future: getCurrentWeather() ,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data;

          final currentWeather = data!['list'][0];
          final celsiusTemp = currentWeather['main']['temp'];
          final tempC = celsiusTemp;
          final tempF = (celsiusTemp * 9 / 5) + 32;
          final currentSky = currentWeather['weather'][0]['main'];
          final currentP = currentWeather['main']['pressure'];
          final currentWindS = currentWeather['wind']['speed'];
          final currentH = currentWeather['main']['humidity'];

          return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Main card
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 0,
                        sigmaY: 0
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              '${tempC.toStringAsFixed(1)} °C / ${tempF.toStringAsFixed(1)} °F',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            Icon(
                              currentSky == 'Clouds' && currentSky == 'Rain' ? Icons.cloud : Icons.sunny,
                              size: 64
                            ),
                            SizedBox(height: 16),
                            Text(
                              '$currentSky',
                              style: TextStyle(
                                fontSize: 20
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              //weather forcast cards
              const Text(
                'Hourly Forecast',
                style: TextStyle(
                  fontSize: 24,
                 fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     spacing: 4,
              //     children: [
              //       for (int i=0; i < 39; i++)
              //       HourlyForecastItem(
              //         time: data['list'][i + 1]['dt'].toString(),
              //         icon: data['list'][i + 1]['weather'][0]['main'] == 'clouds' || data['list'][i + 1]['weather'][0]['main'] == 'rain' ? Icons.cloud: Icons.sunny,
              //         temperture: data['list'][i + 1]['main']['temp'].toString(),
              //       ),
              //     ],
              //   )
              // ),

                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        itemCount: 5,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final hourlyForecastList = data['list'][index + 1];
                          final hourlyForecastIcon = data['list'][index + 1]['weather'][0]['main'];
                          final Time = DateTime.parse(hourlyForecastList['dt_txt'].toString());
                          return HourlyForecastItem(
                            icon: hourlyForecastIcon == 'cloud' || hourlyForecastIcon == 'clear' ? Icons.cloud : Icons.sunny,
                            temperture: hourlyForecastList['main']['temp'].toString(),
                            time: DateFormat('j').format(Time),
                            );
                        }
                        ),
                    ),

              const SizedBox(height: 20),
              //additional information cards
              const Text(
                'Additional Information',
                style: TextStyle(
                  fontSize: 24,
                 fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInfoItem(
                    icon: Icons.water_drop,
                    label: 'Humidity',
                    value: currentH.toString(),
                  ),
                  AdditionalInfoItem(
                    icon: Icons.air,
                    label: 'Wind Speed',
                    value: currentWindS.toString(),),
                  AdditionalInfoItem(
                    icon: Icons.umbrella,
                    label: 'Pressure',
                    value: currentP.toString(),),
                ],
              ),
            ],
          ),
              
          
            
          );
          
        },
      ),
    );
    return scaffold;
  }
}
