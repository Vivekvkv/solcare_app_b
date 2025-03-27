import 'package:flutter/material.dart';

class ServiceFilterBar extends StatelessWidget {
  final List<String> serviceTypes;
  final List<String> urgencyOptions;
  final List<String> priceRangeOptions;
  final List<String> ratingOptions;
  final List<String> availabilityOptions;
  
  final Set<String> selectedServiceTypes;
  final Set<String> selectedUrgency;
  final Set<String> selectedPriceRange;
  final Set<String> selectedRating;
  final Set<String> selectedAvailability;
  
  final Function(String) onServiceTypeToggled;
  final Function(String) onUrgencyToggled;
  final Function(String) onPriceRangeToggled;
  final Function(String) onRatingToggled;
  final Function(String) onAvailabilityToggled;
  final VoidCallback onClearFilters;
  final bool isMobile; // Add mobile flag parameter

  const ServiceFilterBar({
    super.key,
    required this.serviceTypes,
    required this.urgencyOptions,
    required this.priceRangeOptions,
    required this.ratingOptions,
    required this.availabilityOptions,
    required this.selectedServiceTypes,
    required this.selectedUrgency,
    required this.selectedPriceRange,
    required this.selectedRating,
    required this.selectedAvailability,
    required this.onServiceTypeToggled,
    required this.onUrgencyToggled,
    required this.onPriceRangeToggled,
    required this.onRatingToggled,
    required this.onAvailabilityToggled,
    required this.onClearFilters,
    this.isMobile = false, // Default to desktop view
  });

  @override
  Widget build(BuildContext context) {
    final hasAnyFilter = selectedServiceTypes.isNotEmpty ||
                         selectedUrgency.isNotEmpty ||
                         selectedPriceRange.isNotEmpty ||
                         selectedRating.isNotEmpty ||
                         selectedAvailability.isNotEmpty;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Use minimum vertical space
      children: [
        // Filter bar title with clear button - more compact on mobile
        if (hasAnyFilter)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0, 
              vertical: isMobile ? 4.0 : 8.0
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Active Filters:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 14 : 16,
                  ),
                ),
                TextButton.icon(
                  icon: Icon(Icons.clear_all, size: isMobile ? 18 : 20),
                  label: Text('Clear All', style: TextStyle(fontSize: isMobile ? 12 : 14)),
                  onPressed: onClearFilters,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 8 : 12,
                      vertical: isMobile ? 0 : 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        
        // Scrollable filter options - more compact for mobile
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 4.0 : 8.0, 
            vertical: isMobile ? 4.0 : 8.0
          ),
          child: Row(
            children: [
              // Service Type filter dropdown
              _buildFilterDropdown(
                context,
                'Service Type',
                serviceTypes,
                selectedServiceTypes,
                onServiceTypeToggled,
              ),
              
              SizedBox(width: isMobile ? 6 : 12),
              
              // Urgency filter dropdown
              _buildFilterDropdown(
                context,
                'Urgency',
                urgencyOptions,
                selectedUrgency,
                onUrgencyToggled,
              ),
              
              SizedBox(width: isMobile ? 6 : 12),
              
              // Price Range filter dropdown
              _buildFilterDropdown(
                context,
                'Price Range',
                priceRangeOptions,
                selectedPriceRange,
                onPriceRangeToggled,
              ),
              
              SizedBox(width: isMobile ? 6 : 12),
              
              // Rating filter dropdown
              _buildFilterDropdown(
                context,
                'Rating',
                ratingOptions,
                selectedRating,
                onRatingToggled,
              ),
              
              SizedBox(width: isMobile ? 6 : 12),
              
              // Availability filter dropdown
              _buildFilterDropdown(
                context,
                'Availability',
                availabilityOptions,
                selectedAvailability,
                onAvailabilityToggled,
              ),
            ],
          ),
        ),
        
        // Selected filter chips - more compact on mobile
        if (hasAnyFilter)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 8.0 : 16.0, 
              vertical: isMobile ? 4.0 : 8.0
            ),
            child: Row(
              children: [
                // Service type chips
                ...selectedServiceTypes.map((type) => _buildFilterChip(
                  type,
                  () => onServiceTypeToggled(type),
                  isMobile,
                )),
                
                // Urgency chips
                ...selectedUrgency.map((urgency) => _buildFilterChip(
                  urgency,
                  () => onUrgencyToggled(urgency),
                  isMobile,
                )),
                
                // Price range chips
                ...selectedPriceRange.map((price) => _buildFilterChip(
                  price,
                  () => onPriceRangeToggled(price),
                  isMobile,
                )),
                
                // Rating chips
                ...selectedRating.map((rating) => _buildFilterChip(
                  rating,
                  () => onRatingToggled(rating),
                  isMobile,
                )),
                
                // Availability chips
                ...selectedAvailability.map((availability) => _buildFilterChip(
                  availability,
                  () => onAvailabilityToggled(availability),
                  isMobile,
                )),
              ],
            ),
          ),
        
        // Divider
        const Divider(height: 1),
      ],
    );
  }
  
  Widget _buildFilterDropdown(
    BuildContext context,
    String label,
    List<String> options,
    Set<String> selectedOptions,
    Function(String) onToggle,
  ) {
    return PopupMenuButton<String>(
      tooltip: 'Filter by $label',
      child: Chip(
        label: Text(
          label,
          style: TextStyle(fontSize: isMobile ? 11 : 13),
        ),
        avatar: Icon(
          _getIconForFilter(label),
          size: isMobile ? 14 : 18,
        ),
        backgroundColor: selectedOptions.isNotEmpty 
            ? Theme.of(context).colorScheme.primaryContainer 
            : null,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 2 : 4,
          vertical: isMobile ? 0 : 2,
        ),
        visualDensity: isMobile ? VisualDensity.compact : null,
        labelPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 2 : 4, 
          vertical: 0
        ),
      ),
      onSelected: onToggle,
      itemBuilder: (context) => options.map((option) {
        return PopupMenuItem<String>(
          value: option,
          height: isMobile ? 40 : 48,
          child: Row(
            children: [
              Checkbox(
                value: selectedOptions.contains(option),
                onChanged: (_) => onToggle(option),
                visualDensity: VisualDensity.compact,
              ),
              Text(option, style: TextStyle(fontSize: isMobile ? 13 : 14)),
            ],
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildFilterChip(String label, VoidCallback onRemove, bool isMobile) {
    return Padding(
      padding: EdgeInsets.only(right: isMobile ? 4.0 : 8.0),
      child: Chip(
        label: Text(
          label,
          style: TextStyle(fontSize: isMobile ? 11 : 13),
        ),
        onDeleted: onRemove,
        deleteIcon: Icon(Icons.close, size: isMobile ? 14 : 18),
        visualDensity: isMobile ? VisualDensity.compact : null,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        labelPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 2 : 4, 
          vertical: 0
        ),
        padding: EdgeInsets.all(isMobile ? 2 : 4),
      ),
    );
  }
  
  IconData _getIconForFilter(String filter) {
    switch (filter) {
      case 'Service Type':
        return Icons.build;
      case 'Urgency':
        return Icons.priority_high;
      case 'Price Range':
        return Icons.attach_money;
      case 'Rating':
        return Icons.star;
      case 'Availability':
        return Icons.event_available;
      default:
        return Icons.filter_list;
    }
  }
}
