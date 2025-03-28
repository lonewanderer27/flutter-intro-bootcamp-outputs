import 'package:flutter/material.dart';
import 'package:mapdown/models/favorite_place.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen(this.place, {super.key});
  final FavoritePlace place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
      ),
      body: Stack(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Metadata here...',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
