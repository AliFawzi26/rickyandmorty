import 'package:dio/dio.dart';
import 'package:rick/constants/strings.dart';
class CharactersWebServices{
late Dio dio;

CharactersWebServices(){
  BaseOptions options=BaseOptions(
    baseUrl: baseUrl,
    receiveDataWhenStatusError: true,
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
    contentType: 'application/json',
  );
  dio=Dio(options);
}
Future<Map<String, dynamic>> getAllCharacters()async{
  try{
    Response response=await dio .get('character');
    print(response.data.toString());
    return response.data;
  }catch(e){
    print(e.toString());
    return{};
  }
}
Future<Map<String, dynamic>> getAllLocations() async {
  try {
    Response response = await dio.get('location');
    print(response.data.toString());
    return response.data;
  } catch (e) {
    print(e.toString());
    return {};
  }
}
Future<Map<String, dynamic>> getLocationById(int id) async {
  try {
    Response response = await dio.get('location/$id');
    return response.data;
  } catch (e) {
    print('Error in getLocationById: $e');
    throw Exception('Failed to load location with id $id');
  }
}



}