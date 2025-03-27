import 'package:flutter/material.dart';
import 'review_item.dart';

class ReviewsSection extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;
  final bool showAllReviews;
  final VoidCallback toggleShowAllReviews;

  const ReviewsSection({
    super.key,
    required this.reviews,
    required this.showAllReviews,
    required this.toggleShowAllReviews,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Customer Reviews',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (reviews.length > 3)
              TextButton(
                onPressed: toggleShowAllReviews,
                child: Text(
                  showAllReviews ? 'Show Less' : 'View All',
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ...reviews.take(showAllReviews ? reviews.length : 3).map((review) => ReviewItem(
              name: review['name'] as String,
              rating: review['rating'] as double,
              comment: review['comment'] as String,
              date: review['date'] as String,
            )),
      ],
    );
  }
}
