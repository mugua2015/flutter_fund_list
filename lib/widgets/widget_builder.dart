import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildRowCell(String left, String right) => Padding(
    padding: EdgeInsets.all(10),
    child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$left"),
          Text("$right"),
        ]));

Widget buildRowCell2(String left, String right){
     try{
       var _myDouble = double.parse(right);
       var _color = _myDouble >0 ? Colors.redAccent:Colors.green;
       return Padding(
           padding: EdgeInsets.all(10),
           child: Flex(
               direction: Axis.horizontal,
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text(left),
                 Text(right+"%",style:TextStyle(fontWeight:FontWeight.w500,color: _color))
               ]));
     }catch(e){
        return Text(e.toString());
     }

}


Widget buildProgressbar(){
 return Center(child: CircularProgressIndicator());
}