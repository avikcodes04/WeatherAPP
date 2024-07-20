import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';



class WeatherScreen extends StatefulWidget {

  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String,dynamic>> weather;
  Future<Map<String,dynamic>> getCurrentWeather() async {
    try {
      String cityName='Kolkata,IN';
    final res = await http.get(
      Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName=&APPID=$openWeatherAPIKey'
      ),
    );
    final data = jsonDecode(res.body);
    if(data['cod']!='200'){
      throw data ['message'];
    }
      return data;
    } catch (e)
    {
      throw e.toString();//7:
    }
  }
  @override
  void initState(){
    
    super.initState();
    weather = getCurrentWeather();
  }
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Weatheroo',
        style: TextStyle(
          fontWeight: FontWeight.bold,
         

        ),
        ),
       actions: [
        IconButton(onPressed:(){
          setState(() {
            
          });
          debugPrint("Refresh");
        },
         icon: const Icon(Icons.refresh_outlined),
         ),
        
       ],
        centerTitle: true,//7:42
      ),


      body:  FutureBuilder(
        future: weather,
        builder:(context,snapshot) {

          if (snapshot.connectionState==ConnectionState.waiting) {
            return const LinearProgressIndicator();
          }
          if (snapshot.hasError) {
           return  Center(child: Text(snapshot.error.toString()));           
          }
            final data=snapshot.data!;
            final currentWeatherData = data['list'][0];
            final currentTemp = currentWeatherData['main']['temp']-273;
            final currentSky = currentWeatherData['weather'][0]['main'];
            final currentPressure = currentWeatherData['main']["pressure"];
            final currentWindSpeed = currentWeatherData['wind']['speed'];
            final currentHumidity = currentWeatherData['main']["humidity"];

          //(data['list'][0]['main']['temp']);
          return Padding(
          padding: const EdgeInsets.all(16.0),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
            
              //main card
               SizedBox(
                
                width: double.infinity,
                 child: Card(
                  elevation: 20,
                  shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)//border roundness of the main card 
                    ),
                    
                  
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5,sigmaY: 5),//blur strength
                      child:  Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children:[
                            Text("${currentTemp.toStringAsFixed(0)}°C",
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                            
                        
                            ),
                            const SizedBox(height: 8),
                            
                            
                             Icon(
                              currentSky=="Clouds"  || currentSky == 'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                              size: 64,
                              ),
                            const SizedBox(height: 16),
                             Text(currentSky,
                            style: 
                            const TextStyle(fontSize: 20),),
                            
                              
                            
                          ],
                          
                          
                        ),
                      ),
                    ),
                  ),
                 ),
               ),
        
               const SizedBox(
                height: 25,
               ),
        
               const Text('Hourly Forecast',
               style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
               ),
               ),
        
               const SizedBox(
                height: 13),
                
                //   SingleChildScrollView(
                //    scrollDirection: Axis.horizontal,
                //    child: Row(                        //row
                //        children: [
                //         for(int i=0;i<12;i++)
                //          //weather forecast cards
                //          HorurlyForecastItem(
                //           time:data['list'][i+1]['dt'].toString(),
                //          icon: data['list'][i+1]['weather'][0]['main'] =='Clouds' || data['list'][i+1]['weather'][0]['main'] =='Rain'?
                //          Icons.cloud: Icons.sunny,
                //          temperature:data['list'][i+1]['main']["temp"].toString(),
                //          ),//card 1
                         
                    
                         
                //      ],
                     
                //    ),
                //  ),


                // Hourly Forecast Cards


                SizedBox(
                  
                  height: 121,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 9,
                    itemBuilder: (context,index){
                      final hourlyForecast=data['list'][index+1];
                       final  hourlySKy=  hourlyForecast['weather'][0]['main'];
                       final hourlyTemp = hourlyForecast['main']["temp"]-273;
                       final time = DateTime.parse(hourlyForecast["dt_txt"]);
                  
                  
                      return HorurlyForecastItem(
                      time: DateFormat.j().format(time), 
                     
                      temperature: '${hourlyTemp.toStringAsFixed(0)}°C',

                  
                      icon: hourlySKy =='Clouds' || hourlySKy =='Rain'
                      ? Icons.cloud
                      : Icons.sunny);
                    },
                  ),
                ),





               const SizedBox(
                height: 27,
               ),
        
               const Text('Additional Information',
               style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
               ),
               ),
              const SizedBox(
                height: 20,
               ),               
        
        
        
                 Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                AdditionalInfoItem(
                  icon: Icons.water_drop,
                  label: "Humidity",
                  value: currentHumidity.toString(),
                ),
                  AdditionalInfoItem(
                  icon: Icons.air,
                  label: "Wind speed",
                  value: currentWindSpeed.toString(),
                 ),
                  AdditionalInfoItem(
                    icon: Icons.beach_access,
                    label: "Pressure",
                    value:currentPressure.toString(),
        
                  ),
        
               ],
               )
          
            ],
                        
          ),
        );
        },
      ),
    );
  }
}


