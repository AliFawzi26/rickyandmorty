import 'dart:convert';
import 'package:rick/data/web_services/characters_web_services.dart';

import '../models/characters.dart';

class CharactersRepository {
  final CharactersWebServices charactersWebServices;

  CharactersRepository(this.charactersWebServices);

  Future<List<Result>> getAllCharacters() async {
    final charactersJson = await charactersWebServices.getAllCharacters();
    final characters = Characters.fromJson(charactersJson );
    return characters.results;
  }
  Future<List<LocationModel>> getAllLocations() async {
    final locationJson = await charactersWebServices.getAllLocations();
    final List<dynamic> locations = locationJson["results"];
    return locations.map((e) => LocationModel.fromJson(e)).toList();
  }
  Future<LocationModel> getLocationById(int id) async {
    final jsonData = await charactersWebServices.getLocationById(id);
    return LocationModel.fromJson(jsonData);
  }
}
