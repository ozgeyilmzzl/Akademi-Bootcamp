
//import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kelimekesfi1/global_widget/app_bar.dart';
import 'package:kelimekesfi1/pages/lists.dart';
import 'package:kelimekesfi1/pages/words_card.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:package_info_plus/package_info_plus.dart';
//import 'package:package_info_plus/package_info_plus.dart';



class MainPage extends StatefulWidget {
  const MainPage({super.key});


  @override
  State<MainPage> createState() => _MainPageState();
}
enum Lang { eng, tr }

//const _url = 'https://oyunveuygulamaakademisi.com';
//final Uri _url = Uri.parse('https://oyunveuygulamaakademisi.com');
final Uri _url = Uri.parse('https://oyunveuygulamaakademisi.com');


class _MainPageState extends State<MainPage> {
  Lang? _chooseLang = Lang.eng;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
 // PackageInfo ?packageInfo;
 // String version="";
@override
  void initState() {
    // TODO: implement initState
    super.initState();
   // packageInfoInit();
  }
  //void packageInfoInit()async{
 // packageInfo = await PackageInfo.fromPlatform();
   //  setState(() {
    //   version=packageInfo!.version;

    // });

 // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width*0.5,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Image.asset("assets/images/logo.png",height: 160,),
                  Text("KELİME KEŞFİ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
                  Text("Şimdi Öğren",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
                  SizedBox(width:MediaQuery.of(context).size.width*0.35,child: Divider(color: Colors.black,)),
                  Container(margin:EdgeInsets.only(top: 50,right: 8,left: 8),child: Text("Uygulama hakkında bilgi edinmek için",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),textAlign: TextAlign.center,)),
                  InkWell(onTap:()async{
                    //await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                    if (!await launchUrl(_url)) {
                      throw Exception('Could not launch $_url');
                    }



                  },child: Text("Öğren",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16,color: Colors.cyan),)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                  child: Text("V"+"1"+"\nOyun ve Uygulama Akademisi",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13,color: Colors.teal),textAlign: TextAlign.center,)),

            ],
          ),
        ),
      ),
      appBar: appBar(context,
          left:const FaIcon(FontAwesomeIcons.bars,color: Colors.black,size: 24,),
          center:Image.asset("assets/images/logo_text33.png"),
          leftWigdetOnClick: ()=>{_scaffoldKey.currentState!.openDrawer()}
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              langRadioButton(
                   text:"İngilizce - Türkçe",
                  group: _chooseLang,
                  value: Lang.tr),
              langRadioButton(
                  text:"Türkçe - İngilizce ",
                  group: _chooseLang,
                  value: Lang.eng),
              SizedBox(height: 25,),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const ListsPage()));
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 55,
                  margin: EdgeInsets.only(bottom: 20),
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end:
                        Alignment.bottomRight,
                      colors: <Color>[
                        Color(0xff59e5b3),
                        Color(0xff050d43)
                      ],
                      tileMode: TileMode.repeated,
                    ),
                  ),
                  child: Text(
                    "Kelime Listelerim",
                    style: TextStyle(fontSize: 28,color: Colors.white,fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    card(context,
                        startColor: 0xff6b9fe3,
                        endColor: 0xff05532a,
                        title: "Kartlarım",
                        icon: Icon(Icons.file_copy,size: 32,color: Colors.white,),click:(){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const WordCardsPage()));
                        }
                    ),
                    card(context,
                        startColor: 0xff073b49,
                        endColor: 0xff1dbf4d,
                        title: "Çoktan\nSeçmeli",
                        icon: Icon(Icons.check_circle_sharp,size: 32,color: Colors.white,),click:(){}),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InkWell card(BuildContext context,
      {@required int ?startColor,@required int ?endColor,@required String ?title,@required Icon ?icon,@required  Function ?click}) {
    return InkWell(
      onTap: ()=>click!(),
      child: Container(
                      alignment: Alignment.center,
                      height: 200,
                      width: MediaQuery.of(context).size.width*0.35,
                      decoration: BoxDecoration(

                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end:
                          Alignment.bottomRight,
                          colors: <Color>[
                            Color(startColor!),
                            Color(endColor!)
                          ],
                          tileMode: TileMode.repeated,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            title!,
                            style: TextStyle(fontSize: 28,color: Colors.white,fontWeight: FontWeight.w900),
                          ),
                          icon!
                        ],
                      ),
                    ),
    );
  }

  SizedBox langRadioButton({
    @required String? text,
    @required Lang? value,
    @required Lang? group,
  }) {
    return SizedBox(
      width: 250,
      height: 30,
      child: ListTile(
        title: Text(text!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
        leading: Radio<Lang>(
          value: Lang.tr,
          groupValue: _chooseLang,
          onChanged: (Lang? value) {
            setState(() {
              _chooseLang = value;
            });
          },
        ),
      ),
    );
  }
}
