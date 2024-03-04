import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/widgets/restaurant_card.dart';

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
                        return RestaurantCard(restaurant: state.result.restaurants[index]);
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
}