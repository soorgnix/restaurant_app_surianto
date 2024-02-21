import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/restaurant_details_page.dart';

class RestaurantListPage extends StatefulWidget {
  static const routeName = '/restaurant_list_page';
  
  const RestaurantListPage({Key? key}) : super (key: key);

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  String _searchString = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(        
        title: const Column(          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Restaurant',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Recommendation restaurant for you',
              style: TextStyle(fontSize: 12),
            )
          ]
        )
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(              
              decoration: const InputDecoration(
                hintText: 'Search name/city/foods/drinks...',
                focusedBorder: OutlineInputBorder(),
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (value) {
                setState(() {
                  _searchString = value;
                });
              }
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: futureBuilderRestaurants(context, _searchString)
            )
          )
        ]
      )
    );
  }

  FutureBuilder<String> futureBuilderRestaurants(BuildContext context, String searchString) {
    return FutureBuilder<String>(
      future: DefaultAssetBundle.of(context).loadString('assets/local_restaurant.json'),
      builder: (context, snapshot) {
        final List<Restaurant> restaurants = parseRestaurant(snapshot.data);
        final List<Restaurant> filteredRestaurants = searchString.isEmpty
            ? restaurants // Return all restaurants if search string is empty
            : restaurants.where((restaurant) =>
                restaurant.name.toLowerCase().contains(searchString.toLowerCase()) ||
                restaurant.city.toLowerCase().contains(searchString.toLowerCase()) ||
                restaurant.menus.foods.any((food) => food.name.toLowerCase().contains(searchString.toLowerCase())) ||
                restaurant.menus.drinks.any((drink) => drink.name.toLowerCase().contains(searchString.toLowerCase()))
            ).toList();
        if (filteredRestaurants.isEmpty) {
          return const Text('No restaurant found');
        }
        else {
          return ListView.builder(
            itemCount: filteredRestaurants.length,
            itemBuilder: (context, index) {
              return _buildRestaurantItem(context, filteredRestaurants[index]);
            }
          );
        }
      }
    );
  }

  Widget _buildRestaurantItem(BuildContext context, Restaurant restaurant) {
    return ListTile(
      contentPadding: const EdgeInsets.all(4),
      leading: Hero(
        tag:restaurant.pictureId,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
          child: Image.network(
            restaurant.pictureId,
            width: 100,
            fit: BoxFit.cover,        
            errorBuilder: (ctx, error, _) => const Icon(Icons.error)
          )
        )
      ),
      title: Text(
        restaurant.name,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined
                ),
                Text(
                  restaurant.city,
                  style: Theme.of(context).textTheme.bodySmall
                ),
              ]
            ),
            Row(
              children: [
                const Icon(
                  Icons.star_border_outlined                  
                ),
                Text(
                  restaurant.rating.toString(),
                  style: Theme.of(context).textTheme.bodySmall
                )
              ],
            )
          ]
        ),
      onTap: () {
        Navigator.pushNamed(context, RestaurantDetailsPage.routeName, arguments: restaurant);
      }
    );
  }
}