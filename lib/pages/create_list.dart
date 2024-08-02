//import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kelimekesfi1/db/db/db.dart';
import 'package:kelimekesfi1/db/models/lists.dart';
import 'package:kelimekesfi1/global_widget/app_bar.dart';
//import 'package:fluttertoast/fluttertoast.dart';

import '../db/models/words.dart';
import '../global_widget/text_field_builder.dart';
import '../global_widget/toast.dart';

class CreateList extends StatefulWidget {
  const CreateList({super.key});

  @override
  State<CreateList> createState() => _CreateListState();
}

class _CreateListState extends State<CreateList> {
  final _listName=TextEditingController();
  List<TextEditingController>wordTextEditingList=[];
  List<Row> wordListField =[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(int i = 0; i<10 ; ++i)
      wordTextEditingList.add(TextEditingController());
    
    for(int i=0 ; i<5; ++i){
      debugPrint((2*i).toString()+"  "+(i*2+1).toString());
      wordListField.add(
          Row(
            children: [
              Expanded(child:textFieldBuilder(textEditingController: wordTextEditingList[2*i])),
              Expanded(child: textFieldBuilder(textEditingController: wordTextEditingList[2*i+1])),
            ],
          )

      );
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context,
          left: const Icon(Icons.arrow_back_ios,color: Colors.black,size: 22,),
          center:Image.asset("assets/images/logo_text33.png"),
          right: Image.asset("assets/images/logo.png",height: 80,width: 80,),
        leftWigdetOnClick: ()=>Navigator.pop(context)
      ),

      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              textFieldBuilder(icon: const Icon( Icons.list,size: 18,),hintText: "Liste Adı",textEditingController: _listName,textAlign: TextAlign.left),
              Container(
                margin: const  EdgeInsets.only(top:20,bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("İngilizce",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    Text("Türkçe",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child:Column(
                    children: wordListField,
                  ) ,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  actionBtn(addRow,Icons.add),
                  actionBtn(save,Icons.save),
                  actionBtn(deleteRow,Icons.remove),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  InkWell actionBtn(Function() click,IconData icon) {
    return InkWell(
                  onTap:()=>click() ,
                  child: Container(
                    width: 45,
                    height: 45,
                    margin: EdgeInsets.only(bottom: 20,top: 5),
                    child: Icon(icon,size: 30,),
                    decoration: BoxDecoration(
                      color: Color(0xffd5e8dd),
                      shape: BoxShape.circle
                    ),
                  ),
                );
  }
  void addRow()
  {
    wordTextEditingList.add(TextEditingController());
    wordTextEditingList.add(TextEditingController());

    wordListField.add(
      Row(
        children: [
          Expanded(child:textFieldBuilder(textEditingController: wordTextEditingList[wordTextEditingList.length -2])),
          Expanded(child:textFieldBuilder(textEditingController: wordTextEditingList[wordTextEditingList.length -1]))
        ],
      )
    );
setState(()=>wordListField);
  }
  void save() async
  {
    if (!_listName.text.isEmpty)
    {
      int counter = 0;
      bool notEmptyPair = false;

      for(int i = 0; i < wordTextEditingList.length / 2; ++i)
      {
        String eng = wordTextEditingList[2 * i].text;
        String tr = wordTextEditingList[2 * i + 1].text;

        if(!eng.isEmpty && !tr.isEmpty)
        {
          counter++;
        }
        else
        {
          notEmptyPair = true;
        }
      }

      if(counter >= 4)
      {
        if (!notEmptyPair)
        {
          Lists addedList = await DB.instance.insertList(Lists(name: _listName.text));

          for(int i = 0; i < wordTextEditingList.length / 2; ++i)
          {
            String eng = wordTextEditingList[2 * i].text;
            String tr = wordTextEditingList[2 * i + 1].text;

            Word word = await DB.instance.insertWord(Word(list_id: addedList.id, word_eng: eng, word_tr: tr, status: false));
            debugPrint(word.id.toString() + " " + word.list_id.toString() + " " + word.word_eng.toString() + " " + word.word_tr.toString() + " " + word.status.toString());
          }

          //debugPrint("TOAST MESSAGE => Liste oluşturuldu.");
          toastMessage("Liste oluşturuldu.");

          _listName.clear();
          wordTextEditingList.forEach((element) {
            element.clear();
          });

        }
        else
        {
          toastMessage("Boş alanları doldurun veya silin");

        }
      }
      else
      {
        toastMessage("Minimum 4 çift dolu olmalıdır.");

      }
    }
    else
    {
      toastMessage("Liste adını boş,Lütfen liste adı girin");

    }


  }
  void deleteRow()
  {
    if (wordListField.length !=4 ) {
      wordTextEditingList.removeAt(wordTextEditingList.length-1);
      wordTextEditingList.removeAt(wordTextEditingList.length-1);

      wordListField.removeAt(wordListField.length-1);
      setState(()=>wordListField);
    }
    else
    {

     toastMessage("Son eleman");

    }

  }




}
