import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/restaurant_const.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_filter.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/provider/restaurant_details_provider.dart';

class RestaurantDetailsPage extends StatefulWidget {
  static const routeName = '/restaurant_details';

  final Restaurant restaurant;

  const RestaurantDetailsPage({Key? key, required this.restaurant}) : super (key: key);

  @override
  State<RestaurantDetailsPage> createState() => _RestaurantDetailsPageState();
}

class _RestaurantDetailsPageState extends State<RestaurantDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant.name)
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Hero(
                  tag: widget.restaurant.pictureId,
                  child: Image.network(
                    '${RestaurantConst.imageUrl}${RestaurantConst.largeUrl}/${widget.restaurant.pictureId}',
                    fit: BoxFit.cover,
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                  )
                ), 
                Consumer<DatabaseProvider> (
                  builder: (context, provider, child) {
                    return FutureBuilder<bool> (
                      future: provider.isBookmarked(widget.restaurant.id),
                      builder: (context, snapshot) {
                        var isBookmarked = snapshot.data ?? false;
                        return isBookmarked ? 
                          IconButton(
                            icon: const Icon(Icons.favorite),
                            color: Theme.of(context).colorScheme.secondary,
                            onPressed: () =>  provider.removeBookmark(widget.restaurant.id),
                          ) :
                          IconButton(
                            icon: const Icon(Icons.favorite_border_outlined),
                            color: Theme.of(context).colorScheme.secondary,
                            onPressed: () => provider.addBookmark(widget.restaurant),
                          );
                      }
                    );
                  }
                )
              ],
            ),
            ChangeNotifierProvider<RestaurantDetailsProvider>(
              create: (_) => RestaurantDetailsProvider(apiService: ApiService(), id: widget.restaurant.id),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Consumer<RestaurantDetailsProvider>(
                  builder: (context, state, _) {
                    if (state.state == ResultState.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.state == ResultState.hasData) {
                      return Column (
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.result.restaurant.name,
                            style: Theme.of(context).textTheme.headlineMedium
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined),
                              Text(
                                state.result.restaurant.city,                  
                                style: Theme.of(context).textTheme.labelSmall
                              )
                            ]
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star_border_outlined),
                              Text(
                                state.result.restaurant.rating.toString(),
                                style: Theme.of(context).textTheme.labelSmall
                              )
                            ]
                          ),
                          const Divider(color: Colors.grey),
                          Text(
                            state.result.restaurant.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis
                          ),
                          const Divider(color: Colors.grey),
                          SizedBox(
                            height: 150,
                            child: ListView(                
                              scrollDirection: Axis.horizontal,
                              children: state.result.restaurant.menus.foods.map((food) {
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
                              children: state.result.restaurant.menus.drinks.map((drink) {
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
            )
          ],
        )
      )
    );
  }
}