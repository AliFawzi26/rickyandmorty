import 'package:bloc/bloc.dart';
import 'package:rick/data/repository/characters_repository.dart';
import 'package:rick/data/models/characters.dart';

import 'LocationsState.dart'; // يحتوي على LocationModel

class LocationsCubit extends Cubit<LocationsState> {
  final CharactersRepository charactersRepository;
  LocationsCubit(this.charactersRepository) : super(LocationsInitial());

  void getAllLocations() {
    emit(LocationsLoading());
    charactersRepository.getAllLocations().then((locations) {
      emit(LocationsLoaded(locations));
    }).catchError((error) {
      emit(LocationsError(error.toString()));
    });
  }
}
