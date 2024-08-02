


//import 'package:flutter/cupertino.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kelimekesfi1/db/db/db.dart';
import 'package:kelimekesfi1/global_widget/app_bar.dart';
import 'package:kelimekesfi1/global_widget/toast.dart';
import 'package:kelimekesfi1/pages/create_list.dart';
import 'package:kelimekesfi1/pages/words.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({Key? key}) : super(key: key);

  @override
  _ListsPageState createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {

  List<Map<String, Object?>> _lists = [];

  bool pressController=false;
  List<bool> deleteIndexList=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLists();

  }
  void getLists() async {
    _lists = await DB.instance.readListsAll();
    for(int i=0 ; i<_lists.length ; ++i)
      deleteIndexList.add(false);

    setState(() {
      _lists;
    });
  }
void delete() async {
  List<int> removeIndexList = [];

  for(int i = 0 ; i<_lists.length ; ++i)
    if(deleteIndexList[i] == true)
      removeIndexList.add(i);

  for(int i = removeIndexList.length - 1 ; i>=0 ; --i)
  {
    DB.instance.deleteListsAndWordByList(_lists[removeIndexList[i]]['list_id'] as int);
    _lists.removeAt(removeIndexList[i]);
    deleteIndexList.removeAt(removeIndexList[i]);
  }

  //for(int i = 0 ; i<deleteIndexList.length ; ++i)
  // deleteIndexList[i] = false;

  setState(() {
    _lists;
    deleteIndexList;
    pressController = false;
  });

  toastMessage("Seçili listeler silindi.");
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context,
          left:const Icon(Icons.arrow_back_ios,color: Colors.black,size: 22,) ,
          center: Image.asset("assets/images/lists.png"),
          right: pressController!=true?Image.asset("assets/images/logo.png",height: 80,width: 80,):InkWell(
            onTap: delete,
            child: Icon(Icons.delete,color: Colors.black,size: 24,),
          ),
        leftWigdetOnClick: ()=>
        Navigator.pop(context)



      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const CreateList()));

        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
      body: SafeArea(
        child:
        ListView.builder(itemBuilder: (context,index){
          return listItem(_lists[index]['list_id'] as int,index,listName: _lists [index]['name'].toString(),sumWords:_lists [index]['sum_word'].toString(),sumUnlearned: _lists [index]['sum_unlearned'].toString() );
        },itemCount:_lists.length ,),
      ),
    );
  }

  InkWell listItem(int id,int index,{@required String ?listName,@required String ?sumWords,@required String ?sumUnlearned}) {
    return InkWell(
      onTap: (){
        debugPrint(id.toString());
        Navigator.push(context, MaterialPageRoute(builder: (context)=>WordsPage(id,listName))).then((value){
          getLists();
        });
      },
      onLongPress: (){
        setState(() {
          pressController=true;
          deleteIndexList[index]=true;
        });
      },
      child:Center(//look
            child: Container(
              width: double.infinity,
              child: Card(
                color: Color(0xffd5e8dd),
                elevation: 8,
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                ) ,
                margin: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 15,top: 5),
                            child: Text(listName!,style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),)),
                        Container(margin: EdgeInsets.only(left: 30),
                            child: Text(sumWords!+" terim",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),)),
                        Container(margin: EdgeInsets.only(left: 30),
                            child: Text((int.parse(sumWords)-int.parse(sumUnlearned!)).toString()+" öğrenildi",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),)),
                        Container(margin: EdgeInsets.only(left: 30,bottom: 5),
                            child: Text(sumUnlearned+" öğrenilmedi",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),))
                      ],
                    ),
                    pressController==true?Checkbox(
                      checkColor: Colors.white,
                      activeColor: Colors.deepOrangeAccent,
                      hoverColor: Colors.deepPurpleAccent,
                      value: deleteIndexList[index],
                      onChanged: (bool? value){
                        setState(() {
                          deleteIndexList[index]=value!;

                          bool deleteProcessController = false;

                          deleteIndexList.forEach((element) {
                            if(element == true)
                              deleteProcessController = true;
                          });

                          if(!deleteProcessController)
                            pressController = false;

                        });

                      },
                    ):Container()
                  ],
                ),

              ),

            ),
      ),
    );
  }
}





/* Center sil() {
    return Center(
        child: Container(
          width: double.infinity,
          child: Card(
            color: Color(0xFFDCD2FF), // Hex renk kodu direkt olarak kullanıldı
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, top: 5),
                  child: Text(
                    "Liste Adı",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "RobotoMedium",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, top: 5, bottom: 5),
                  child: Text(
                    "305 terim",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: "RobotoRegular",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, top: 5, bottom: 5),
                  child: Text(
                    "5 öğrenildi",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: "RobotoRegular",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, top: 5, bottom: 5),
                  child: Text(
                    "300 öğrenilmedi",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: "RobotoRegular",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }*/
