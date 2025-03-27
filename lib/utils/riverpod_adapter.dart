import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This widget helps to convert a Riverpod Consumer widget to a regular widget
/// that can be used in a Flutter app without Riverpod-specific context
class RiverpodAdapter extends StatelessWidget {
  final Widget Function(BuildContext context, WidgetRef ref) builder;
  
  const RiverpodAdapter({
    super.key,
    required this.builder,
  });
  
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return builder(context, ref);
      },
    );
  }
}

/// This class helps to convert a Riverpod provider to a regular ChangeNotifier
/// that can be used with the Provider package
class RiverpodChangeNotifierAdapter<T> extends ChangeNotifier {
  final ProviderContainer container;
  final StateNotifierProvider<StateNotifier<T>, T> provider;
  late T _value;
  
  RiverpodChangeNotifierAdapter({
    required this.container,
    required this.provider,
  }) {
    _value = container.read(provider);
    container.listen(provider, (previous, next) {
      _value = next;
      notifyListeners();
    });
  }
  
  T get value => _value;
}
