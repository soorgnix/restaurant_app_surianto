import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/restaurant_const.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_arguments.dart';
import 'package:restaurant_app/data/model/restaurant_filter.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
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
      body: ChangeNotifierProvider<RestaurantProvider>(
        create: (_) => RestaurantProvider(apiService: ApiService(), filter: _searchString),
        child: Consumer<RestaurantProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.loading) {
              return const Center(child:CircularProgressIndicator());
            } else if (state.state == ResultState.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom <= 700 ? MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom <= 200 ? 1 : 1 : 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: SizedBox(
                        height:100,
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
                    )
                  ),
                  Expanded(
                    flex: MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom <= 700 ? MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom <= 200 ? 1 : 1 : 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ElevatedButton(                        
                        child: const Text('Search'),
                        onPressed: () {
                          var restaurantProvider = Provider.of<RestaurantProvider>(context, listen: false);
                          restaurantProvider.searchRestaurant(_searchString);
                        }
                      ),
                    ),
                  ),
                  Expanded(
                    flex: MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom <= 700 ? MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom <= 200 ? 1 : 4 : 11,
                    child: ListView.builder(
                      itemCount: state.result.restaurants.length,
                      itemBuilder: (context, index) {
                        return _buildRestaurantItem(context, state.result.restaurants[index]);
                      }
                    )
                  )
                ]
              );
            } else if (state.state == ResultState.noData) {
              return Center(
                child: Material(
                  child: Text(state.message),
                ),
              );
            } else if (state.state == ResultState.error) {
              return Center(
                child: Material(
                  child: Text(state.message),
                ),
              );
            } else {
              return const Center(
                child: Material(
                  child: Text(''),
                ),
              );
            }
          }
        )
      )
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
            '${RestaurantConst.imageUrl}${RestaurantConst.smallUrl}/${restaurant.pictureId}',
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
        Navigator.pushNamed(context, RestaurantDetailsPage.routeName, arguments: RestaurantArguments(restaurant.id, restaurant.pictureId, restaurant.name));
      }
    );
  }
}