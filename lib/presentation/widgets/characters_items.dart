
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rick/constants/my_colors.dart';
import '../../constants/strings.dart';
import '../../data/models/characters.dart'; 

class CharactersItems extends StatelessWidget {
  final Result characters;
  const CharactersItems({Key? key, required this.characters}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
      padding:const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Mycolors.mywhite, borderRadius: BorderRadius.circular(8)),
      child:InkWell(
    onTap: ()=>Navigator.pushNamed(context,characterDetailsScreen,arguments:characters),
      child:  GridTile(
        child:Hero(tag: characters.id,
        child: Container(
        color: Mycolors.mygrey,
        child: characters.image.isNotEmpty?
          FadeInImage.assetNetwork(width:double.infinity,height:double.infinity,fit:BoxFit.cover,  placeholder: 'assets/images/loading.json', image: characters.image)
            :Image.asset('assets/images/placeholder.png'),
    )  ),
      footer: Container(
        width: double.infinity,
       padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15) ,
       color: Colors.black54,
       alignment: Alignment.bottomCenter,
       child: Text('${characters.name}',style:TextStyle(height: 1.3,fontSize: 16,color: Mycolors.mywhite,
       fontWeight: FontWeight.bold,
       ),
       overflow: TextOverflow.ellipsis,
         maxLines: 2,
         textAlign: TextAlign.center,
       ),
      ),
      ),
    )  ); 
  }
}

