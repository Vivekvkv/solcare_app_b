import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcare_app4/models/service_model.dart';
import 'package:solcare_app4/screens/services/providers/services_providers.dart';

/// This widget adapts a Consumer widget to use Riverpod providers
class ServicesConsumerAdapter extends ConsumerWidget {
  final Widget Function(BuildContext context, AsyncValue<List<ServiceModel>> services) builder;
  
  const ServicesConsumerAdapter({
    super.key,
    required this.builder,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncServices = ref.watch(servicesProvider);
    return builder(context, asyncServices);
  }
}

/// This widget adapts a Consumer widget to use the Riverpod search query provider
class SearchQueryConsumerAdapter extends ConsumerWidget {
  final Widget Function(BuildContext context, String query) builder;
  
  const SearchQueryConsumerAdapter({
    super.key,
    required this.builder,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    return builder(context, query);
  }
}

/// Use this widget to wrap any part of your UI that needs to update when services change
class ServicesProviderScope extends StatelessWidget {
  final Widget child;
  
  const ServicesProviderScope({
    super.key,
    required this.child,
  });
  
  @override
  Widget build(BuildContext context) {
    return ProviderScope(child: child);
  }
}
