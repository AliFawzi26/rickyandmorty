import 'package:bloc/bloc.dart';
import 'package:rick/buisiness_logic/cubit/characters_state.dart';
import 'package:rick/data/repository/characters_repository.dart';
import 'package:rick/data/models/characters.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final CharactersRepository charactersRepository;
  late List<Result> characters;

  CharactersCubit(this.charactersRepository) : super(CharactersInitial());

  void getAllCharacters() {
    charactersRepository.getAllCharacters().then((characters) {
      this.characters = characters;
      emit(CharactersLoaded(characters));
    }).catchError((error) {
      emit(CharactersError(error.toString()));
    });
  }




}
