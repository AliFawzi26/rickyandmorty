import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rick/constants/my_colors.dart';
import 'package:rick/presentation/widgets/characters_items.dart';
import '../../buisiness_logic/cubit/auth_cubit.dart';
import '../../buisiness_logic/cubit/characters_cubit.dart';
import '../../buisiness_logic/cubit/characters_state.dart';
import '../../constants/strings.dart';
import '../../data/models/characters.dart';
class CharactersScreen extends StatefulWidget {
  const CharactersScreen({Key? key}) : super(key: key);
  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  final TextEditingController _searchTextController = TextEditingController();
  List<Result> _searchedForCharacters = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    context.read<CharactersCubit>().getAllCharacters();
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  void _startSearch() {
    ModalRoute.of(context)!.addLocalHistoryEntry(
      LocalHistoryEntry(onRemove: _stopSearching),
    );
    setState(() => _isSearching = true);
  }
  void _stopSearching() {
    _clearSearch();
    setState(() => _isSearching = false);
  }
  void _clearSearch() {
    _searchTextController.clear();
    setState(() => _searchedForCharacters.clear());
  }
  void _updateSearchResults(String query) {
    final state = context.read<CharactersCubit>().state;
    if (state is CharactersLoaded) {
      final allCharacters = state.characters;
      _searchedForCharacters = allCharacters
          .where((c) => c.name.toLowerCase().startsWith(query.toLowerCase()))
          .toList();
      setState(() {});
    }
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchTextController,
      cursorColor: Mycolors.mygrey,
      decoration: InputDecoration(
        hintText: "Find a character",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Mycolors.mygrey, fontSize: 18.sp),
      ),
      style: TextStyle(color: Mycolors.mygrey, fontSize: 18.sp),
      onChanged: _updateSearchResults,
    );
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          icon: Icon(Icons.clear, color: Mycolors.mygrey, size: 24.r),
          onPressed: () {
            _clearSearch();
            Navigator.pop(context);
          },
        )
      ];
    } else {
      return [
        IconButton(
          icon: Icon(Icons.search, color: Mycolors.mygrey, size: 24),
          onPressed: _startSearch,
        )
      ];
    }
  }

  Widget _buildAppBarTitle() {
    return Text(
      'Characters',
      style: TextStyle(color: Mycolors.mygrey, fontSize: 20.sp),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mycolors.mygrey,
      appBar: AppBar(
        backgroundColor: Mycolors.myyellow,
        leading: _isSearching
            ? BackButton(color: Mycolors.mygrey, )
            : Container(),
        title: _isSearching ? _buildSearchField() : _buildAppBarTitle(),
        actions: _buildAppBarActions(),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
            BuildContext context,
            List<ConnectivityResult> connectivity,
            Widget child,
            ) {
          final connected = connectivity != ConnectivityResult.none;
          if (!connected) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No Internet Connection',
                    style: TextStyle(color: Mycolors.mygrey, fontSize: 18.sp),
                  ),
                  SizedBox(height: 16.h),
                  Image.asset('assets/images/net.png', width: 120.w, height: 120.h,),
                ],
              ),);
          }
          return BlocBuilder<CharactersCubit, CharactersState>(
            builder: (context, state) {
              if (state is CharactersLoaded) {
                final charactersList = _isSearching && _searchTextController.text.isNotEmpty
                    ? _searchedForCharacters
                    : state.characters;
                return _buildCharactersGrid(charactersList);
              } else {
                return _buildLoadingIndicator();
              }},
          );},
        child: _buildLoadingIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Mycolors.myyellow,
        onPressed: () => _showLogoutDialog(context),
        child: Icon(Icons.logout, color: Mycolors.mywhite, size: 24),
      ),
    );}
  Widget _buildLoadingIndicator() {
    return Center(child: CircularProgressIndicator(color: Mycolors.myyellow),);
  }
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Mycolors.mygrey,
        title: Text('تأكيد الخروج', style: TextStyle(color: Mycolors.mywhite, fontSize: 18.sp),),
        content: Text('هل تريد تسجيل الخروج؟', style: TextStyle(color: Mycolors.mywhite, fontSize: 16.sp),),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthCubit>().logout();
              Navigator.pushReplacementNamed(context, loginscreen);
            },
            child: Text('خروج', style: TextStyle(color: Colors.red, fontSize: 14.sp)),
          ),
        ],),
    );}
  Widget _buildCharactersGrid(List<Result> characters) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 1.w,
        mainAxisSpacing: 1.h,
      ),
      itemCount: characters.length,
      itemBuilder: (context, index) {
        return CharactersItems(characters: characters[index]);
      },
    );}}
