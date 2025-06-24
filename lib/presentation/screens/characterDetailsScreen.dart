import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rick/constants/my_colors.dart';
import 'package:rick/data/models/characters.dart';
import 'package:rick/constants/strings.dart';
class CharacterDetailsScreen extends StatelessWidget {
  static const routeName = characterDetailsScreen;
  final Result character;
  const CharacterDetailsScreen({
    Key? key,
    required this.character,
  }) : super(key: key);

  Widget buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 350.h,
      pinned: true,
      backgroundColor: Mycolors.mygrey,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(character.name, style: TextStyle(color: Mycolors.mywhite, fontSize: 18.sp),),
        background: Hero(tag: character.id,
          child: Image.network(character.image, fit: BoxFit.cover),
        ),
      ),);
  }
  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(color: Mycolors.mywhite, fontWeight: FontWeight.bold, fontSize: 16.sp,),
            ),
            TextSpan(
              text: value,
              style: TextStyle(color: Mycolors.mywhite, fontSize: 16.sp),
            ),
          ],
        ),
      ),);}
  Widget buildDivider(double endIndent) {
    return Divider(
      color: Mycolors.myyellow,
      height: 30.h,
      endIndent: endIndent.w,
      thickness: 2.h,
    );
  }
  @override
  Widget build(BuildContext context) {
    final createdDate =
        "${character.created.day}/${character.created.month}/${character.created.year}";
    int? locationId;
    try {
      final parts = character.location.url.split('/');
      locationId = int.tryParse(parts.last);
    } catch (_) {
      locationId = null;
    }
    return Scaffold(
      backgroundColor: Mycolors.mygrey,
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(),
          SliverPadding(
            padding: EdgeInsets.all(16.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  buildInfoRow('Status', character.status.name.toLowerCase().capitalize(),),
                  buildDivider(315),
                  buildInfoRow('Species', character.species.name.toLowerCase().capitalize(),),
                  buildDivider(250),
                  buildInfoRow('Gender', character.gender.name.toLowerCase().capitalize(),),
                  buildDivider(280),
                  if (character.type.isNotEmpty) ...[
                    buildInfoRow('Type', character.type),
                    buildDivider(280),
                  ],
                  buildInfoRow('Origin', character.origin.name),
                  buildDivider(300),
                  if (locationId != null)
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          locationDetailsScreen,
                          arguments: locationId,
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Location: ',
                                style: TextStyle(color: Mycolors.mywhite, fontWeight: FontWeight.bold, fontSize: 16.sp,),
                              ),
                              TextSpan(
                                text: character.location.name,
                                style: TextStyle(color: Mycolors.myyellow, fontSize: 16.sp, decoration: TextDecoration.underline,),
                              ),
                            ],
                          ),
                        ),),)
                  else
                    buildInfoRow('Location', character.location.name),
                  buildDivider(250),
                  buildInfoRow('Created on', createdDate),
                  buildDivider(250),
                  buildInfoRow('Episodes Appeared', '${character.episode.length}'),
                  SizedBox(height: 12.h),
                  Text(
                    'Episode List:',
                    style: TextStyle(color: Mycolors.mywhite, fontWeight: FontWeight.bold, fontSize: 18.sp,),
                  ),
                  SizedBox(height: 8.h),
                  ...character.episode.map((epUrl) {
                    final epNum = epUrl.split('/').last;
                    return Text(
                      '• Episode $epNum',
                      style: TextStyle(color: Mycolors.mywhite, fontSize: 16.sp),
                    );
                  }).toList(),
                  SizedBox(height: 24.h),
                ],
              ),),),
        ],
      ),);
  }}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
