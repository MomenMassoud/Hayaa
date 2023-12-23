import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../core/Utils/app_images.dart';
import '../../home/widgets/gradient_rounded_container.dart';

class AgentViewHostIncome extends StatefulWidget{
  String agendID;
  String HostID;
  String HostName;
  AgentViewHostIncome(this.agendID,this.HostID,this.HostName);
  _AgentViewHostIncome createState()=>_AgentViewHostIncome();
}

class _AgentViewHostIncome extends State<AgentViewHostIncome>{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  late DateTime joinDate;
  int myDaiomond=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.HostID);
    GetUser();
  }
  void GetUser()async{
    await for(var snap in _firestore.collection('user').doc(widget.HostID).snapshots()){
      setState(() {
        myDaiomond=int.parse(snap.get('daimond'));
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.HostName} InCome"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('agency').doc(widget.agendID).collection('users').where('userid',isEqualTo:widget.HostID).snapshots(),
        builder: (context,snapshot){
          String docID="";
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final masseges = snapshot.data?.docs;
          for (var massege in masseges!.reversed){
            joinDate=DateTime.parse(massege.get('time'));
            docID=massege.id;
          }
          return StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('agency').doc(widget.agendID).collection('users').doc(docID).collection('income').snapshots(),
            builder: (context,snapshot){
              List<DataRow> rows = [];
              int total=0;
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                  ),
                );
              }
              final masseges = snapshot.data?.docs;
              for (var massege in masseges!.reversed){
                DateTime date=DateTime.parse(massege.get('date'));
                total+=int.parse(massege.get('count'));
                DataRow row = DataRow(
                  cells: [
                    DataCell(Text("${date.day}/${date.month}")),
                    DataCell(Text(massege.get('hosttime'))),
                    DataCell(Text(massege.get('numberradio'))),
                    DataCell(Text(massege.get('count'))),
                  ],
                );
                rows.add(row);
              }
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 18,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Date Of Joining The Agency",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 18,),
                            Text(
                              "${joinDate.day}/${joinDate.month}/${joinDate.year}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                GradientRoundedContainer(
                                    screenHeight: screenHeight * 0.15,
                                    screenWidth: screenWidth * 0.4,
                                    colorOne: Colors.purpleAccent,
                                    colorTwo: Colors.purple),
                                SizedBox(
                                  width: screenWidth * 0.2,
                                  child: const Opacity(
                                    opacity: 0.3,
                                    child:
                                    Image(image: AssetImage(AppImages.goldenDiamond)),
                                  ),
                                ),
                                Positioned(
                                    top: screenHeight * 0.02,
                                    left: screenWidth * 0.05,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Yellow Diamond \n       Balance",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: screenWidth * 0.04),
                                        ),
                                        Text(
                                          total<=myDaiomond?total.toString():myDaiomond.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: screenWidth * 0.1),
                                        ),
                                      ],
                                    ))
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Day Data",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth * 0.04,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DataTable(
                          columnSpacing: 5.0,
                          horizontalMargin: 12.0,
                          dividerThickness: 2.0,
                          columns: [
                            DataColumn(label: SizedBox(
                              height: screenHeight * 0.08,
                              child: Center(
                                child: Text('Date',
                                    style: TextStyle(fontSize: screenWidth * 0.035)
                                ),
                              ),
                            )),
                            DataColumn(label:
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text('Hostess time',style: TextStyle(fontSize: screenWidth * 0.035)),
                            )
                            ),
                            DataColumn(label:
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text('Number of radio days',style: TextStyle(fontSize: screenWidth * 0.035)),
                            )),
                            DataColumn(label: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text('Number of currencies',style: TextStyle(fontSize: screenWidth * 0.035)),
                            )),
                          ],
                          rows: rows,

                          border: TableBorder.all(width: 0.4),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: screenWidth * 0.8,
                              child: ElevatedButton(
                                  onPressed: () {},
                                  child: const Text("Withdrawal from the agency")),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}