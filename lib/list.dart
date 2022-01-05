
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';


// RSS URL : https://www.donanimhaber.com/rss/tum
class Liste extends StatefulWidget {


  @override
  _ListeState createState() => _ListeState();
}

class _ListeState extends State<Liste>
{

  late var haberler = null;

  Future<bool> getData() async
  {

    var url = "https://www.donanimhaber.com/rss/tum";

    Response data = await Dio().get(url);
    //print(data.data);
    var xmlData = data.data;


    var xml  = XmlDocument.parse(xmlData);
    //List books = xml.findElements("book") as List;
    //print("Kitap Sayısı : ${books.length}");
    haberler  = xml.findAllElements("item").toList();

    print("Haberler Yüklendi : ${haberler.length}");

    return true;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        child: Center(
          child: FutureBuilder(
            future: getData(),
            builder: (context, snapshot)
            {
              if (snapshot.connectionState != ConnectionState.done)
              {
                return SizedBox(width: 100, height: 100, child: CircularProgressIndicator(),);
              }
              else
              {
                return
                  ListView.builder(
                    itemCount: haberler.length,
                    itemBuilder: (context, index)
                    {

                      var k = haberler[index];
                      var title = k.getElement("title").text;
                      var description = k.getElement("description").text;
                      var img=k.getElement("enclosure").getAttribute('url');

                      return Card(
                        margin: EdgeInsets.all(10),
                        elevation: 15,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Image.network("${img}"),
                              Text("${title}"),
                              SizedBox(height: 10,),
                              Text("${description}")
                            ],
                          ),
                        ),
                      );



                    },);
              }

            },
          ),
        ),
      ),
    );
  }
}
// onlinebooks