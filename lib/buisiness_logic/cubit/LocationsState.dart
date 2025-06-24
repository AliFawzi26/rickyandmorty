import 'package:flutter/foundation.dart';
import 'package:rick/data/models/characters.dart'; // لأن LocationModel في هذا الملف

@immutable
abstract class LocationsState {}

class LocationsInitial extends LocationsState {}

class LocationsLoading extends LocationsState {}

class LocationsLoaded extends LocationsState {
  final List<LocationModel> locations;
  LocationsLoaded(this.locations);
}

class LocationsError extends LocationsState {
  final String message;
  LocationsError(this.message);
}
