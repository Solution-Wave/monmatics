import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/themes.dart';
import 'opportunityExtendedView.dart';

class OpportunityScreen extends StatelessWidget {
   OpportunityScreen({super.key});
  List customerList = [
    {
      'Name': "Hashim Sarwar",
      'Company Name': 'Demo Company',
      'Category': 'Customer',
      'PhoneNo': '03345467891',
      'Email': 'demo123@gmail.com',
      'Address': 'Gujranwala, Punjab , Pakistan',
      'Location': 'https://goo.gl/maps/3fu3GVpYHp8Gekyw9?coh=178573&entry=tt',
      'Description':  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',

    },
    {'Name': 'Demo1',
      'Company Name': 'Demo Company Name',
      'Category': 'Customer',
      'PhoneNo': '03345467891',
      'Email': 'demo123@gmail.com',
      'Address': 'Gujranwala, Punjab , Pakistan',
      'Location': 'https://goo.gl/maps/3fu3GVpYHp8Gekyw9?coh=178573&entry=tt',
      'Description':  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    },

    { 'Name': 'Demo2',
      'Company Name': 'Demo Company Name',
      'Category': 'Customer',
      'PhoneNo': '03345467891',
      'Email': 'demo123@gmail.com',
      'Address': 'Gujranwala, Punjab , Pakistan',
      'Location': 'https://goo.gl/maps/3fu3GVpYHp8Gekyw9?coh=178573&entry=tt',
      'Description':  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    }
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Opportunities', style:  headerTextStyle ,),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0,right: 8.0, left: 8.0),
          child: ListView.builder(
            itemCount: customerList.length,
            itemBuilder: (BuildContext, index){
              return GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>OpportunityExtendedScreen() ));
                },
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: 70
                  ),
                  child: Container(
                    margin: EdgeInsets.only(top: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: primaryColor)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: OverflowBar(
                            spacing: 20.0,
                            overflowSpacing: 10.0,
                            children: [
                              Text(customerList[index]['Name']),
                              Text(customerList[index]['Category']),
                            ],
                          ),
                        ),

                        Row(children: [
                          IconButton(
                              iconSize: 20.0,
                              onPressed: (){},
                              icon: Icon(Icons.phone)),
                          IconButton(
                              iconSize: 20.0,
                              onPressed: (){},
                              icon: Icon(Icons.mail)),
                        ],)

                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
