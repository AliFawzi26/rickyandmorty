
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rick/data/models/characters.dart';
import 'package:rick/data/repository/characters_repository.dart';
import 'package:rick/constants/my_colors.dart';
import 'package:rick/constants/strings.dart';

class LocationDetailsScreen extends StatelessWidget {
  static const routeName = locationDetailsScreen;
  final int locationId;
  final CharactersRepository repository;
  const LocationDetailsScreen({
    Key? key,
    required this.locationId,
    required this.repository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repo = repository;
    return Scaffold(
      backgroundColor: Mycolors.mygrey,
      appBar: AppBar(
        title: Text(
          "Location Details",
          style: TextStyle(fontSize: 20.sp, color: Mycolors.mywhite),
        ),
        backgroundColor: Mycolors.myyellow,
      ),
      body: FutureBuilder<LocationModel>(
        future: repo.getLocationById(locationId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Mycolors.myyellow));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(fontSize: 16.sp)));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data', style: TextStyle(fontSize: 16.sp)));
          } else {
            final location = snapshot.data!;
            final residentIds = location.residents.map((url) {
              final parts = url.split('/');
              return int.tryParse(parts.last) ?? 0;
            }).where((id) => id > 0).toList();
            String createdDate;
            try {
              final dt = DateTime.parse(location.created);
              createdDate = '${dt.day}/${dt.month}/${dt.year}';
            } catch (_) {
              createdDate = location.created;
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(location.name,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Mycolors.mywhite,
                      )),
                  SizedBox(height: 8.h),
                  Text("Type: ${location.type}",
                      style: TextStyle(fontSize: 18.sp, color: Mycolors.mywhite)),
                  SizedBox(height: 4.h),
                  Text("Dimension: ${location.dimension}",
                      style: TextStyle(fontSize: 16.sp, color: Mycolors.mywhite)),
                  SizedBox(height: 4.h),
                  Text("Created on: $createdDate",
                      style: TextStyle(fontSize: 14.sp, color: Mycolors.mywhite)),
                  SizedBox(height: 12.h),
                  Text(
                    "Number of residents: ${residentIds.length}",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Mycolors.mywhite,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ...residentIds.map((id) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          characterDetailsScreen,
                          arguments: null,
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Text(
                          '• Character ID: $id',
                          style: TextStyle(fontSize: 14.sp, color: Mycolors.mywhite),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
