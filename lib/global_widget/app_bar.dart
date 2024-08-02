import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

PreferredSize appBar(context,{@required Widget ?left,@required Widget ?center,Widget ?right,Function ?leftWigdetOnClick})
{
return PreferredSize(
    child: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width * 0.20,
            child: InkWell(
              onTap:()=>leftWigdetOnClick!(),
              child: left,
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.50,
            child: center,
          ),
          Container(
            alignment: Alignment.centerRight,
            width: MediaQuery.of(context).size.width * 0.20,
            child: right,
          )
        ],
      ),

),preferredSize: const Size.fromHeight(50) ) ;
}