import 'package:flutter/material.dart';
import 'package:kelimekesfi1/pages/main.dart';
class TemproryPage extends StatefulWidget {
  const TemproryPage({super.key});

  @override
  State<TemproryPage> createState() => _TemproryPageState();
}

class _TemproryPageState extends State<TemproryPage> {
  git
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    Future.delayed(Duration(seconds: 15),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainPage()));
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child:
        Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Column(
                  children: [
                    Image.asset("assets/images/logo.png"),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text("KELİME KEŞFİ",style: TextStyle(color: Colors.black,fontSize: 40,fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("ŞİMDİ ÖĞREN",style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),
                )


              ],

            ),
          ),
        ),
      ),

    );
  }
}
