import 'package:flutter/material.dart';

import '../db/db/db.dart';
import '../db/models/words.dart';
import '../global_widget/app_bar.dart';
import '../global_widget/text_field_builder.dart';
import '../global_widget/toast.dart';


class AddWordPage extends StatefulWidget {
  final int? listID;
  final String? listName;

  //const AddWordPage(this.listID,this.listName,{super.key});
  const AddWordPage(this.listID,this.listName,{Key? key}) : super(key: key);

  @override
  State<AddWordPage> createState() => _AddWordPageState(listID: listID,listName: listName);
}

class _AddWordPageState extends State<AddWordPage> {
  int? listID;
  String? listName;
  _AddWordPageState({required this.listID, required this.listName});


  List<TextEditingController>wordTextEditingList=[];
  List<Row> wordListField =[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(int i = 0; i<6 ; ++i)
      wordTextEditingList.add(TextEditingController());

    for(int i=0 ; i<3; ++i){
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
      appBar: appBar(
          context,
          left: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 22,),
          center: Text(listName!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black,),),
          right: const Icon(Icons.add, color: Colors.black, size: 22,),
          leftWigdetOnClick: ()=>  Navigator.pop(context)

      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                margin: const  EdgeInsets.only(top:10,bottom: 10),
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

      if(counter >= 1)
      {
        if (!notEmptyPair)
        {


          for(int i = 0; i < wordTextEditingList.length / 2; ++i)
          {
            String eng = wordTextEditingList[2 * i].text;
            String tr = wordTextEditingList[2 * i + 1].text;

            Word word = await DB.instance.insertWord(Word(list_id: listID, word_eng: eng, word_tr: tr, status: false));
            debugPrint(word.id.toString() + " " + word.list_id.toString() + " " + word.word_eng.toString() + " " + word.word_tr.toString() + " " + word.status.toString());
          }

          //debugPrint("TOAST MESSAGE => Liste oluşturuldu.");
          toastMessage("Kelimeler eklendi.");

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
        toastMessage("Minimum 1 çift dolu olmalıdır.");

      }
    }
  void deleteRow()
  {

    if (wordListField.length !=1 ) {
      wordTextEditingList.removeAt(wordTextEditingList.length-1);
      wordTextEditingList.removeAt(wordTextEditingList.length-1);

      wordListField.removeAt(wordListField.length-1);
      setState(()=>wordListField);
    }
    else
    {

      toastMessage("Minimum 1 çift gereklidir.");

    }

  }


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



//}
