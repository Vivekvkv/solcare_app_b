import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcare_app4/models/service_model.dart';
import 'package:solcare_app4/screens/services/providers/services_providers.dart';

// Re-export providers from services_providers.dart to maintain backward compatibility
// These providers are now defined in providers/services_providers.dart
export 'package:solcare_app4/screens/services/providers/services_providers.dart';

// This empty class maintains backward compatibility with any code that might
// still reference the ServicesProviders class directly
class ServicesProviders {
  // This is an empty implementation that forwards to the proper providers
}
