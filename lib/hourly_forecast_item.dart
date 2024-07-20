import 'package:flutter/material.dart';
class HorurlyForecastItem extends StatelessWidget {
  final String time;
  final String temperature;
  final IconData icon;
  const HorurlyForecastItem({super.key, required this.time, required this.temperature, required this.icon});
  
  @override
  Widget build(BuildContext context) {
    return Card(
                         elevation: 6,
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(20),
                         ),
                         child: Container(
                           width:120,
                           padding: const EdgeInsets.all(8.0),
                           child:  Column(
                             children:  [
                               Text(
                                 time,
                                 style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  
                                 ),
                                 maxLines: 1,
                                 overflow: TextOverflow.ellipsis,
                               ),
                               Icon(
                                 icon,
                                 size: 32,
                               ),
                               const SizedBox(
                                 height: 16,
                               ),
                               Text(temperature),
                             ],
                           ),
                         ),
                       );
  }
                      
}