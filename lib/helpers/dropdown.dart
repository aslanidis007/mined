
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mined/services/dropdown_selection.dart';
import 'package:provider/provider.dart';
import '../constants/color.dart';

Widget dropdownButton(
  {
    required BuildContext context,
    required double w,
    required double h,
    required List data,
    required String typeDropdown,
    required List selected,
    required String genderValue
  }){
  return Consumer<DropDownSelection>(
    builder: (context, item, child){
      return Column(
        children: [
          InkWell(
            onTap: () async{
              await item.dropdownIsVisible(data);
            },
            child: Container(
              width: w * 0.8,
              height: 50,
              margin: EdgeInsets.only(bottom: item.visible == true ? h * 0.010 : h * 0.025,),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: AppColors.lightMov),
                boxShadow: item.visible == false 
                  ? null 
                  :[
                    BoxShadow(
                      color: AppColors.darkMov.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                  ),
                ],                    
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if(typeDropdown == 'gender')...[
                            Text(
                            item.selectedItemValue != '' ? item.selectedItemValue : genderValue != '' ? genderValue : 'Gender',
                            style: TextStyle(
                              color: item.selectedItemValue != '' ?AppColors.darkMov :AppColors.lightMov,
                              fontSize: 16
                            ),
                          )
                        ]else if (typeDropdown == 'event')...[
                            Text(
                            item.selectedItemValue != '' ? item.selectedItemValue : 'Choose event',
                            style: TextStyle(
                              color: item.selectedItemValue != '' ?AppColors.darkMov :AppColors.lightMov,
                              fontSize: 16
                            ),
                          ),
                        ]else if (typeDropdown == 'reachOutToSomeone')...[
                            Text(
                            item.selectedItemValue != '' ? item.selectedItemValue : 'Choose medical contact',
                            style: TextStyle(
                              color: item.selectedItemValue != '' ?AppColors.darkMov :AppColors.lightMov,
                              fontSize: 16
                            ),
                          ),
                        ]else if (typeDropdown == 'teammate')...[
                            Text(
                            item.selectedItemValue != '' ? item.selectedItemValue : 'Medical contact',
                            style: TextStyle(
                              color: item.selectedItemValue != '' ?AppColors.darkMov :AppColors.lightMov,
                              fontSize: 16
                            ),
                          ),
                        ],
                        Icon(
                          item.visible == true ? FontAwesomeIcons.chevronUp :FontAwesomeIcons.chevronDown,
                          size: 15,
                          color: AppColors.lightMov,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: data.isEmpty ? false : item.visible,
            child: Container(
              width: w * 0.8,
              height: data.length > 8 ? 200 : null,
              margin: EdgeInsets.only(bottom: h * 0.025,),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.lightMov),
                boxShadow: item.visible == false 
                ? null 
                :[
                  BoxShadow(
                    color: AppColors.darkMov.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 20,
                    offset: const Offset(0, 3),
                ),
              ],
            ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      for(var x = 0; x < data.length; x++)
                      listOfDropdownItem(data[x], x, context, typeDropdown, selected),                    
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

  Widget listOfDropdownItem(Map dataList, int index, BuildContext context, String typeDropdown, List selected){
    return GestureDetector(
          onTap: () async { 
            if(typeDropdown == 'event'){
              await Provider.of<DropDownSelection>(context, listen: false).selectTypeForEvent(dataList, index, context, selected);
            }else if (typeDropdown == 'reachOutToSomeone'){
              await Provider.of<DropDownSelection>(context, listen: false).selectType(index, dataList['user']['name'], selected);
            }else if (typeDropdown == 'gender'){
              await Provider.of<DropDownSelection>(context, listen: false).selectType(index, dataList['name'], selected);
            }else if (typeDropdown == 'teammate'){
              await Provider.of<DropDownSelection>(context, listen: false).selectType(index, dataList['user']['name'], selected);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  typeDropdown == 'event' || typeDropdown == 'gender'
                  ? dataList['name'] ?? ''
                  : dataList['user']['name'],
                  style: selected.isNotEmpty
                  ? TextStyle(
                    color: selected[index] == false 
                    ? AppColors.lightMov
                    : AppColors.darkMov,
                    fontSize: 16
                  )
                  : const TextStyle(
                    color: AppColors.lightMov,
                    fontSize: 16
                  )
                ),
                selected.isEmpty
                ? const Icon(null)
                : Icon(
                  selected[index] == false  
                  ? null
                  : FontAwesomeIcons.check,
                  size: 15,
                  color: AppColors.lightMov,
                ),
              ],
            ),
          ),
        );
      }