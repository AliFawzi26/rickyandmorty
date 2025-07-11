import 'package:flutter/foundation.dart';
import 'package:rick/data/models/characters.dart';

@immutable
abstract class CharactersState {}

class CharactersInitial extends CharactersState {}

class CharactersLoaded extends CharactersState {
  final List<Result> characters;
  CharactersLoaded(this.characters);
}
class CharactersError extends CharactersState {
  final String message;
  CharactersError(this.message);
}
