import 'package:flutter/material.dart';
import '../../utils/themes.dart';


class OpportunityExtendedScreen extends StatelessWidget {
  const OpportunityExtendedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Opportunity Details', style:  headerTextStyle ,),
          ),
          body: Container(
            child: Padding(
              padding:
              const EdgeInsets.only(left: 12.0, right: 12.0, top: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        visualDensity: VisualDensity(vertical: -2),
                        leading: Text(
                            'Name:',
                            style:  titleStyle
                                //.copyWith(color: Theme.of(context).brightness == Brightness.light ? customerViewColLight : null,)
                        ),
                        title: Text(
                          'DemoName',
                          style: normalStyle
                              //.copyWith(color: Theme.of(context).brightness == Brightness.light ?customerViewColLight: null,),
                        ),
                      ),
                      ListTile(
                        visualDensity: VisualDensity(vertical: -2),
                        leading: Text(
                          'Company Name:',
                          style: titleStyle
                              //.copyWith(color: Theme.of(context).brightness == Brightness.light ? customerViewColLight : null,),
                        ),
                        title: Text(
                          'CompanyXYZ',
                          style: normalStyle
                              //.copyWith(color: Theme.of(context).brightness == Brightness.light ?customerViewColLight: null,),
                        ),
                      ),
                      ListTile(
                        visualDensity: VisualDensity(vertical: -2),
                        leading: Text(
                          'Category:',
                          style: titleStyle
                              //.copyWith(color: Theme.of(context).brightness == Brightness.light ? customerViewColLight : null,),
                        ),
                        title: Text(
                          'project',
                          style: normalStyle
                              //.copyWith(color: Theme.of(context).brightness == Brightness.light ?customerViewColLight: null,),
                        ),
                      ),
                      ListTile(
                        visualDensity: VisualDensity(vertical: -2),
                        leading: Text(
                          'Address:',
                          style: titleStyle
                              //.copyWith(color: Theme.of(context).brightness == Brightness.light ? customerViewColLight : null,),
                        ),
                        title: Text(
                          'Lahore',
                          style: normalStyle
                              //.copyWith(color: Theme.of(context).brightness == Brightness.light ?customerViewColLight: null,),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description:',
                              style: titleStyle
                                  //.copyWith(color: Theme.of(context).brightness == Brightness.light ? customerViewColLight : null,),
                            ),
                            Container(
                              child: Text(
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                                style: normalStyle
                                    //.copyWith(color: Theme.of(context).brightness == Brightness.light ?customerViewColLight: null,),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        color: Theme.of(context).brightness == Brightness.light? Color(0xFF617A55): null,
                        iconSize: 25.0,
                        onPressed: () {},
                        icon: Icon(Icons.phone),
                      ),
                      IconButton(
                        color: Theme.of(context).brightness == Brightness.light? Color(0xFF617A55): null,
                        iconSize: 25.0,
                        onPressed: () {},
                        icon: Icon(Icons.mail),
                      ),
                      IconButton(
                        color: Theme.of(context).brightness == Brightness.light? Color(0xFF617A55): null,
                        iconSize: 25.0,
                        onPressed: () {},
                        icon: Icon(Icons.location_on),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
