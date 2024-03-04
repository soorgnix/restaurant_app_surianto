import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/restaurant_const.dart';
import 'package:restaurant_app/data/model/restaurant_filter.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/ui/restaurant_details_page.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({
    super.key,
    required this.restaurant
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider> (
      builder: (context, provider, child) {
        return FutureBuilder<bool> (
          future: provider.isBookmarked(restaurant.id),
          builder: (context, snapshot) {
            var isBookmarked = snapshot.data ?? false;
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
              subtitle: Column(
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
              trailing: isBookmarked ? 
                IconButton(
                  icon: const Icon(Icons.favorite),
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () => provider.removeBookmark(restaurant.id),
                ) :
                IconButton(
                  icon: const Icon(Icons.favorite_border_outlined),
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () => provider.addBookmark(restaurant),
                ),      
              onTap: () {
                Navigator.pushNamed(context, RestaurantDetailsPage.routeName, arguments: restaurant);
              }
            );
          }
        );
      }
    );
  }
}
