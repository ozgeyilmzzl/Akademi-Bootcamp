import 'package:flutter/material.dart';
import '../db/db/db.dart';
import '../db/models/words.dart';
import '../global_widget/app_bar.dart';
import '../global_widget/toast.dart';
import 'package:carousel_slider/carousel_slider.dart';


class WordCardsPage extends StatefulWidget {
  const WordCardsPage({Key? key}) : super(key: key);

  @override
  _WordCardsPageState createState() => _WordCardsPageState();
}

enum Which { learned, unlearned, all }

enum forWhat { forList, forListMixed }

class _WordCardsPageState extends State<WordCardsPage> {
  Which? _chooseQuestionType = Which.learned;
  bool listMixed = true;
  List<Map<String, Object?>> _lists = [];
  List<bool> selectedListIndex = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLists();
  }

  void getLists() async {
    _lists = await DB.instance.readListsAll();
    for (int i = 0; i < _lists.length; ++i) selectedListIndex.add(false);

    setState(() {
      _lists;
    });
  }

  List<Word> _words = [];

  bool start=false;

  List<bool> changeLang = [];

  void getSelectedWordOfLists(List<int> selectedListID) async
  {

    if (_chooseQuestionType == Which.learned)
    {

      _words = await DB.instance.readWordByLists(selectedListID, status: true);
    }
    else if (_chooseQuestionType == Which.unlearned)
    {

      _words = await DB.instance.readWordByLists(selectedListID, status: false);
    } else
    {

      _words = await DB.instance.readWordByLists(selectedListID);
    }
    if (_words.isNotEmpty)
    {
      for(int i=0 ; i<_words.length;++i)
      {
        changeLang.add(true);
      }

      if (listMixed) _words.shuffle();
      start=true;

      setState(() {
        _words;
        start;
      });

    }
    else
    {
      toastMessage("Seçilen şartlarda liste boş.");

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context,
          left: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 22),
          center: const Text("Kartlarım", style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),),
          leftWigdetOnClick: () => Navigator.pop(context)),
      body: SafeArea(
        child: start==false?Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
          padding: const EdgeInsets.only(left: 4, top: 10, right: 4),
          decoration: BoxDecoration(
            color: Color(0xffd5e8dd),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              whichRadioButton(
                  text: "Öğrenmediklerimi sor", value: Which.unlearned),
              whichRadioButton(text: "Öğrendiklerimi sor", value: Which.learned),
              whichRadioButton(text: "Hepsini sor", value: Which.all),
              checkBox(text: "Listeyi karıştır", fWhat: forWhat.forListMixed),
              SizedBox(
                height: 20,
              ),
              const Divider(
                color: Colors.black,
                thickness: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text("Listeler",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    )),
              ),
              Container(
                margin: const EdgeInsets.only(left: 8, right: 8, bottom: 10, top: 10),
                height: 200,
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
                child: Scrollbar(
                  thickness: 5,
                  thumbVisibility: true,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return checkBox(
                          index: index, text: _lists[index]['name'].toString());
                    },
                    itemCount: _lists.length,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(right: 20),
                child: InkWell(
                  onTap: () {
                    List<int> selectedIndexNoOfList = [];

                    for (int i = 0; i < selectedListIndex.length; ++i)
                    {
                      if (selectedListIndex[i] == true)
                      {
                        selectedIndexNoOfList.add(i);
                      }
                    }

                    List<int> selectedListIdList = [];

                    for (int i = 0; i < selectedIndexNoOfList.length; ++i)
                    {
                      selectedListIdList.add(_lists[selectedIndexNoOfList[i]]['list_id'] as int);
                    }
                    if (selectedListIdList.isNotEmpty)
                    {
                      getSelectedWordOfLists(selectedListIdList);

                    }
                    else
                    {
                      toastMessage("Lütfen, liste seç.");
                    }
                  },
                  child: Text("Başla", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,)),
                ),
              )
            ],
          ),
        ):CarouselSlider.builder(
          options: CarouselOptions(
            height: double.infinity
          ),
          itemCount: _words.length,
          itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
            return Column(
              children: [
            Expanded(
              child: Stack(
              children: [
              InkWell(
              onTap: (){
                if (changeLang[itemIndex] == true)
                {
                  changeLang[itemIndex] = false;
                }
                else
                {
                  changeLang[itemIndex] = true;
                }
              
                setState(() {
                  changeLang[itemIndex];
                });
              },
              child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              margin: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
              padding: const EdgeInsets.only(left: 4, top: 10, right: 4),
              decoration: BoxDecoration(
              color: Color(0xffd5e8dd),
              borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Text(changeLang[itemIndex]?(_words[itemIndex].word_eng!):(_words[itemIndex].word_tr!),style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28,),),
              
              ),
              ),
              Positioned(child: Text((itemIndex+1).toString()+"/"+(_words.length).toString(),style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),),left: 30,top: 10,)
              ],
              ),
            ),
                SizedBox(
                  width: 160,
                  child: CheckboxListTile(
                    title: Text("Öğrendim",style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13,)),
                    value: _words[itemIndex].status,
                    onChanged: (value){
                      _words[itemIndex]=_words[itemIndex].copy(status: value);
                      DB.instance.markAsLearned(value!, _words[itemIndex].id as int);
                      toastMessage(value?"Öğrenildi olarak işaretlendi.":"Öğrenilmedi olarak işaretlendi.");
                      setState(() {
                        _words[itemIndex];
                      });
                    },
                  ),
                )
              ],
            );

          },
        ),
      ),
    );
  }

  SizedBox whichRadioButton({required String? text, required Which? value}) {
    return SizedBox(
      width: 275,
      height: 32,
      child: ListTile(
        title: Text(
          text!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: Radio<Which>(
          value: value!,
          groupValue: _chooseQuestionType,
          onChanged: (Which? value) {
            setState(() {
              _chooseQuestionType = value;
            });
          },
        ),
      ),
    );
  }

  SizedBox checkBox(
      {int index = 0, String? text, forWhat fWhat = forWhat.forList}) {
    return SizedBox(
      width: 270,
      height: 35,
      child: ListTile(
        title: Text(
          text!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: Checkbox(
          checkColor: Colors.white,
          activeColor: Colors.blue,
          hoverColor: Colors.deepPurpleAccent,
          value:
              fWhat == forWhat.forList ? selectedListIndex[index] : listMixed,
          onChanged: (bool? value) {
            setState(() {
              if (fWhat == forWhat.forList) {
                selectedListIndex[index] = value!;
              } else {
                listMixed = value!;
              }
            });
          },
        ),
      ),
    );
  }
}
