import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

class RestaurantDetailsPage extends StatelessWidget {
  static const routeName = '/restaurant_details';

  final Restaurant restaurant;

  const RestaurantDetailsPage({Key? key, required this.restaurant}) : super (key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name)
      ),
      body: SingleChildScrollView(
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: restaurant.pictureId,
                child: Image.network(
                  restaurant.pictureId,
                  fit: BoxFit.cover,
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                )
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column (
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: Theme.of(context).textTheme.headlineMedium
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined),
                        Text(
                          restaurant.city,                  
                          style: Theme.of(context).textTheme.labelSmall
                        )
                      ]
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star_border_outlined),
                        Text(
                          restaurant.rating.toString(),
                          style: Theme.of(context).textTheme.labelSmall
                        )
                      ]
                    ),
                    const Divider(color: Colors.grey),
                    Text(
                      restaurant.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis
                    ),
                    const Divider(color: Colors.grey),
                    SizedBox(
                      height: 150,
                      child: ListView(                
                        scrollDirection: Axis.horizontal,
                        children: restaurant.menus.foods.map((food) {
                          return Padding(
                            padding: const EdgeInsets.all(4),
                            child: SizedBox(
                              width: 100,
                              child: ClipRRect(                      
                                borderRadius: BorderRadius.circular(10),
                                child: Column(               
                                  mainAxisAlignment: MainAxisAlignment.start,         
                                  children: [
                                    Image.asset(
                                      'images/food.png',
                                      height: 100,
                                    ),
                                    Text(
                                      food.name,
                                      style: Theme.of(context).textTheme.labelSmall,
                                      textAlign: TextAlign.center,
                                    )
                                  ]
                                ),
                              )
                            )
                          );
                        }).toList()
                      )
                    ),
                    const Divider(color: Colors.grey),
                    SizedBox(
                      height: 150,
                      child: ListView(                
                        scrollDirection: Axis.horizontal,
                        children: restaurant.menus.drinks.map((drink) {
                          return Padding(
                            padding: const EdgeInsets.all(4),
                            child: SizedBox(
                              width: 100,
                              child: ClipRRect(                      
                                borderRadius: BorderRadius.circular(10),
                                child: Column(                      
                                  mainAxisAlignment: MainAxisAlignment.start,  
                                  children: [
                                    Image.asset(
                                      'images/drink.png',
                                      height: 100,
                                    ),
                                    Text(
                                      drink.name,
                                      style: Theme.of(context).textTheme.labelSmall,
                                      textAlign: TextAlign.center,
                                    )
                                  ]
                                ),
                              )
                            )
                          );
                        }).toList()
                      )
                    ),
                  ],
                ),
              )
            ],
          )
        )
      )
    );
  }
}