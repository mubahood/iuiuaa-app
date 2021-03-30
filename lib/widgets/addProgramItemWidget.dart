import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:intl/intl.dart';
import 'package:iuiuaa/helper/constant.dart';
import 'package:iuiuaa/helper/utility.dart';
import 'package:iuiuaa/ui/page/profile/EditProfilePage.dart';
import 'package:iuiuaa/ui/theme/theme.dart';

import '../model/programItem.dart';
import 'customWidgets.dart';
import 'newWidget/rippleButton.dart';

class addProgramItemWidget extends StatefulWidget {
  Function onProgramAdded;

  addProgramItemWidget(this.onProgramAdded);

  @override
  _addProgramItemWidgetState createState() =>
      _addProgramItemWidgetState(onProgramAdded);
}

class _addProgramItemWidgetState extends State<addProgramItemWidget> {
  Function onProgramAdded;

  _addProgramItemWidgetState(this.onProgramAdded);

  ProgramItem programItem = new ProgramItem();
  TextEditingController _program_item_award = TextEditingController();
  TextEditingController _program_item_name = TextEditingController();
  TextEditingController _program_item_year = TextEditingController();
  TextEditingController _program_item_campus = TextEditingController();
  List<String> _years = [];
  int year = 1990;
  String max_year = "2022";
  int _max_year = 2019;

  @override
  void initState() {
    // TODO: implement initState
    programItem.award = "";
    _program_item_award.text = programItem.award;
    _program_item_name.text = programItem.title;
    _program_item_campus.text = programItem.campus;
    max_year = DateFormat("yyyy").format(DateTime.now());

    if (max_year != null) {
      if (!max_year.isEmpty) {
        _max_year = int.parse(max_year);
      }
    }

    if (_years.isEmpty) {
      for (; _max_year > 1987; _max_year--) {
        _years.add(_max_year.toString());
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'Add a program that you  accomplished from IUIU',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: showAwardPicker,
              child: _entry('Award',
                  isenable: false, controller: _program_item_award),
            ),
            _entry('Program name', controller: _program_item_name),
            InkWell(
              onTap: showYearsPicker,
              child: _entry('Admission year',
                  isenable: false, controller: _program_item_year),
            ),
            InkWell(
              onTap: showCampusPicker,
              child: _entry('IUIU Campus',
                  isenable: false, controller: _program_item_campus),
            ),
            RippleButton(
              splashColor: TwitterColor.dodgetBlue_50.withAlpha(100),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              onPressed: () {
                done();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: TwitterColor.white,
                  border: Border.all(color: AppColor.primary, width: 1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  'ADD PROGRAM',
                  style: TextStyle(
                    color: AppColor.primary,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void showCampusPicker() async {
    showMaterialRadioPicker(
      context: context,
      title: "Select Campus",
      items: Utility.campuses,
      selectedItem: programItem.campus,
      onChanged: (value) {
        setState(() {
          programItem.campus = value;
          _program_item_campus.text = programItem.campus;
        });
      },
    );
  }

  void showYearsPicker() async {

    if(FocusScope.of(context).isFirstFocus) {
      FocusScope.of(context).requestFocus(new FocusNode());
    }

    showMaterialRadioPicker(
      context: context,
      title: "Admission year",
      items: _years,
      selectedItem: programItem.year,
      onChanged: (value) {
        setState(() {

          programItem.year = value;
          _program_item_year.text = programItem.year;
        });
      },
    );
  }

  void showAwardPicker() async {
    showMaterialRadioPicker(
      context: context,
      title: "Select award",
      items: Constants.awards,
      selectedItem: programItem.award,
      onChanged: (value) {
        setState(() {
          programItem.award = value;
          _program_item_award.text = programItem.award;
          //NewProgramItem.award = value;
        });
      },
    );
  }

  Widget _entry(String title,
      {TextEditingController controller,
      int maxLine = 1,
      bool isenable = true}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          customText(title, style: TextStyle(color: Colors.black54)),
          TextField(
            enabled: isenable,
            controller: controller,
            maxLines: maxLine,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            ),
          )
        ],
      ),
    );
  }

  void done() {
    programItem.award = _program_item_award.text;

    if (programItem.award.isEmpty) {
      Utility.my_toast_short("You must select award");
      return;
    }
    programItem.title = _program_item_name.text;
    if (programItem.title.isEmpty) {
      Utility.my_toast_short("You must enter program name");
      return;
    }

    programItem.year = _program_item_year.text;
    if (programItem.year.isEmpty) {
      Utility.my_toast_short("You must select program year");
      return;
    }

    programItem.campus = _program_item_campus.text;
    if (programItem.campus.isEmpty) {
      Utility.my_toast_short("You must select campus");
      return;
    }

    if (onProgramAdded == null) {
      Utility.my_toast_short("onProgramAdded is still null");
      return;
    }

    onProgramAdded(programItem);
  }
}
