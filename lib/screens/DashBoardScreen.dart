import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vesatogotask/services/ApiServices.dart';
import 'package:vesatogotask/theme/ColorTheme.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List commodityData=new List();
  var buyersData;
  List duplicateCommodityData = new List();
  bool isLoading = true;
  bool showCross = false;
  final searchController = TextEditingController();
  @override
  void initState() {
    isLoading = true;
    super.initState();
    getData();
  }

  getData(){
    print('in commodity');
    ApiService.getApi(
        'commodityList.json?alt=media&token=9b9e5427-8769-4dec-83c4-52afe727dbf9',
        'get').then((value){
      commodityData = value;
      duplicateCommodityData = commodityData;
      print('done commodity');
      print('in buyers');
      ApiService.getApi(
          'buyerList.json?alt=media&token=3dcc96c2-9309-4873-868d-bf0023f6266c',
          'get').then((value){
            setState(() {
              isLoading =false;
            });
        buyersData = value;
        print('done buyers');
      });
    });

  }
  bool flag=false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          showCross = false;
        });
      },
      child: Scaffold(
        backgroundColor: ColorTheme.background,
        body:SafeArea(
          child:
          isLoading?Center(child: CircularProgressIndicator(),):
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'What is your crop?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width:MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 54,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color:Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(40))
                            ),
                            child: TextField(
                            controller: searchController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search Specific Crops",
                                  hintStyle: TextStyle(fontSize: 16),
                                  contentPadding: EdgeInsets.all(15),
                                  suffixIcon:showCross?
                                      IconButton(
                                        icon: Icon(Icons.clear,color: ColorTheme.blackColor),
                                        onPressed: (){
                                          setState(() {
                                            duplicateCommodityData = commodityData;
                                            showCross =false;
                                            flag =false;
                                            searchController.clear();
                                          });
                                        },
                                      )
                                      : Icon(Icons.search, color: ColorTheme.blackColor),
                              ),
                              onChanged: (string){
                              print('in changed ');
                                // ignore: missing_return
                                setState(() {
                                  showCross = true;
                                  duplicateCommodityData = commodityData.where((u)=>
                                  (u["commodityName"] .toLowerCase()
                                      .contains(string
                                      .toLowerCase()))).toList();
                                  if(duplicateCommodityData.length==0){
                                    flag=true;
                                  }else{
                                    flag = false;
                                  }
                                });
                                if (string.length == null) {
                                  flag =false;
                                  FocusScope.of(context).unfocus();
                                }
                              }
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  flag? Center(child: Text('No commodity found,Sorry!!!'),):
                  GridView.builder(
                      shrinkWrap: true,
                      itemCount: duplicateCommodityData.length,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 4/2
                      ),
                      itemBuilder: (BuildContext context,int index){
                        return GestureDetector(
                          onTap: (){
                          },
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 30,
                                  height: 30,
                                  margin: EdgeInsets.only(left: 5),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(duplicateCommodityData[index]["photo"]),
                                          fit: BoxFit.fitWidth
                                      )
                                  ),
                                ),
                                Flexible(
                                  child: Align(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 3),
                                      child: Text(
                                        duplicateCommodityData[index]["commodityName"],
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600
                                        ),
                                        maxLines: 3,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Buyer',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: (){
                          },
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(9),
                                      bottomLeft: Radius.circular(9)
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(buyersData[index]["photo"].toString()),
                                      fit: BoxFit.fitWidth
                                    )
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10,top: 7,right: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: 20,
                                            height: 20,
                                            margin: EdgeInsets.only(right: 5),
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(buyersData[index]["cropInfo"]["photo"]),
                                                    fit: BoxFit.fitWidth
                                                )
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                buyersData[index]["cropInfo"]["crop"],
                                                style: TextStyle(
                                                  fontSize: 12
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 40,right: 2,bottom: 9),
                                                child: RichText(
                                                  text: TextSpan(
                                                    style:TextStyle(
                                                      color: ColorTheme.blackColor
                                                    ),
                                                    children: [
                                                      WidgetSpan(
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                          child: Icon(Icons.location_on,size: 12,color: ColorTheme.purpleColor,),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                          text: '21 km/45 mins',
                                                        style: TextStyle(
                                                          fontSize: 8
                                                        )
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Text(
                                        buyersData[index]["buyerName"],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600
                                        ),
                                      ),
                                      SizedBox(
                                        height: 9,
                                      ),
                                      Container(
                                        height:35,
                                        width: MediaQuery.of(context).size.width/2,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: buyersData[index]["price"].length,
                                            itemBuilder: (context,index1){
                                              return Container(
                                                height: 32,
                                                width: 54,
                                                margin: EdgeInsets.only(right: 10),
                                                decoration: BoxDecoration(
                                                    color: ColorTheme.greyColor
                                                ),
                                                padding: EdgeInsets.only(top: 2,left: 3),
                                                child:Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      buyersData[index]["price"][index1]["date"],
                                                      style: TextStyle(
                                                          fontSize: 8,
                                                          fontWeight: FontWeight.w700
                                                      ),
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                          '\u20B9'+buyersData[index]["price"][index1]["price"],
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w700
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 7),
                                                          child: Text(
                                                            buyersData[index]["price"][index1]["sku"],
                                                            style: TextStyle(
                                                              fontSize: 8,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            }
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: buyersData.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
