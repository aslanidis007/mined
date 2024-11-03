
import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../constants/assets.dart';
import '../../constants/color.dart';
import '../../functions/task_item.dart';
import '../../helpers/category_color.dart';
import '../../services/user_info.dart';
import '../../services/user_tasks.dart';

class _AZItem extends ISuspensionBean{
  final String title;
  final String tag;
  final String sub;
  final String user;

  _AZItem(
    {
      required this.sub,
      required this.title,
      required this.tag,
      required this.user,
    }
  );

  @override
  String getSuspensionTag() => tag;
}

class AthleteList extends StatefulWidget {
  const AthleteList({super.key,});

  @override
  State<AthleteList> createState() => _AthleteListState();
}

class _AthleteListState extends State<AthleteList> {
  List<_AZItem> items = [];
  List teamMateList = [];
  bool visible = false, visibleTextArea = false;
  List selected = [false,false,false,false,false,false,false];
  String selectEvent = '';
  TextEditingController searchController = TextEditingController();
  String eventValue = '', textAreaValue = '';
  DateTime selectedDate = DateTime.now();
  List today = [];
  List yesterday = [];
  List older = [];
  bool checkedValue = false;
  List isExpandedToday = [];
  List isExpandedYesterday = [];
  List isExpandedOlder = [];
  String  searchValue = '';
  int itemSelected = -1;
  

  @override
  void dispose(){
    searchController.dispose();
    super.dispose();
  }


  loadProvider(context) async{
    await Provider.of<Tasks>(context, listen: false).selfTaskList(context: context);
    await Provider.of<UserInfo>(context, listen: false).getUserIndividualsItem(context: context);
    for(var x =0; x < Provider.of<UserInfo>(context, listen: false).userIndividuals.length; x++){
      teamMateList.add(Provider.of<UserInfo>(context, listen: false).userIndividuals[x]);
    }
    setState(() {});
  }

  @override
  void initState() {
    initList(context);
    super.initState();
  }

  void initList(context) async {
    await loadProvider(context);
    items = teamMateList.map((item)=> _AZItem(title: '${item['last_name']} ${item['first_name']}', tag: item['last_name'][0].toUpperCase(), sub: item['organisations'][0]['name'], user: item['id'])).toList();
    items.sort((a,b) => a.title.compareTo(b.title));
    setState(() {});
  }


  String truncateTitle(String title,int maxTitle) {
    // Replace this with your logic to truncate the title
    if (title.length > maxTitle) {
      return '${title.substring(0, maxTitle)}...';
    }
    return title;
  }

  String getInitial(String name) {
  return name.isNotEmpty ? name[0] : '';
}

List<String> splitName(String fullName) {
  return fullName.trim().split(' ');
}

String extractInitials(String fullName) {
  final nameParts = splitName(fullName);
  if (nameParts.length >= 2) {
    final firstNameInitial = getInitial(nameParts[0]);
    final lastNameInitial = getInitial(nameParts[1]);
    return '$firstNameInitial$lastNameInitial';
  } else {
    return 'AA';
  }
}


  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
        width: w,
        height: h / 1.1,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.close, size: 40, color: AppColors.lightMov,)),
                    const Spacer(),
                    const Text(
                      'Select athlete',
                      style: TextStyle(
                        color: AppColors.darkMov,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              const SizedBox(height: 40,),
              Container(
                width: w * 0.85,
                margin: EdgeInsets.only(top: h * 0.002, bottom: h * 0.03),
                child: TextFormField(
                  onChanged: (value){
                    if(value.isEmpty){
                      setState(() {
                        searchValue = '';
                      });
                    }else{
                      setState(() {
                        searchValue = value;
                      });
                    }
                  },
                  controller: searchController,
                  style: const TextStyle(
                    color: AppColors.darkMov
                  ),
                  cursorColor: AppColors.darkMov,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.lightMov
                      ),
                      borderRadius: BorderRadius.circular(40)
                    ),
                    // ignore: deprecated_member_use
                    suffixIcon: const Icon(FontAwesomeIcons.search,size: 20,),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.darkMov
                      ),
                      borderRadius: BorderRadius.circular(40)
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    hintText: 'Search athlete',
                    hintStyle: const TextStyle(
                      color: AppColors.lightMov
                    ),
                    
                  ),
                ),
              ),
              Consumer<UserInfo>(
                builder: (context, dataList, child) {
                  final searchList = dataList.userIndividuals.where((element) => 
                   element['first_name'].toLowerCase().toString().trim().contains(searchValue.toString().toLowerCase().trim())||
                   element['last_name'].toLowerCase().toString().trim().contains(searchValue.toString().toLowerCase().trim())
                   || element['organisations'][0]['name'].toLowerCase().toString().trim().contains(searchValue.toString().toLowerCase().trim())
                  ).toList();
                  if(searchValue.isNotEmpty){
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchList.length,
                      itemBuilder: (context, index){
                        return ListTile(
                          onTap: () async{
                            await showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              barrierColor: AppColors.dipDarkMov.withOpacity(0.9),
                              context: context,
                              builder: (context) => StatefulBuilder(
                                builder: (BuildContext context, setState) => selectTask(w,h,setState, searchList[index]['id'])
                              ),
                            ); 
                          },
                          leading: Container(
                            height:40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: AppColors.darkMov,
                                borderRadius: BorderRadius.circular(100)
                              //more than 50% of width makes circle
                            ),
                            child: Center(
                              child: Text(
                                  '${searchList[index]['last_name'][0]}${searchList[index]['first_name'][0]}',
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                          subtitle: Text('${searchList[index]['organisations'][0]['name']}'),
                          title: Text('${searchList[index]['last_name']} ${searchList[index]['first_name']}',
                          style: const TextStyle(color: AppColors.darkMov),),
                          // Other item properties...
                        );
                      },
                    );
                  }
                  return SizedBox(
                    height: h/1.45,
                    child: AzListView(
                    indexBarAlignment:Alignment.topRight,
                      data: items,
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = items[index];
                        final nameSurname = items[index].title;
                        return InkWell(
                          onTap: () async{
                            await showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              barrierColor: AppColors.dipDarkMov.withOpacity(0.9),
                              context: context,
                              builder: (context) => StatefulBuilder(
                                builder: (BuildContext context, setState) => selectTask(w,h,setState, items[index].user)
                              ),
                            );   
                          },
                          child: ListTile(
                            leading: Container(
                              height:40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: AppColors.darkMov,
                                  borderRadius: BorderRadius.circular(100)
                                //more than 50% of width makes circle
                              ),
                              child: Center(
                                child: Text(
                                  extractInitials(nameSurname),
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                            subtitle: Text(item.sub),
                            title: Text(item.title,style: const TextStyle(color: AppColors.darkMov),),
                            // Other item properties...
                          ),
                        );
                      },
                      physics: const BouncingScrollPhysics(), // Optional: Add physics if needed
                      susItemBuilder: (BuildContext context, int index) {
                        // Index bar items (A, B, C, ...)
                        return SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: Center(
                            child: Text(
                              items[index].title[0], // Assuming the name starts with alphabet
                              style: const TextStyle(fontSize: 14.0, color: Colors.white),
                            ),
                          ),
                        );
                      },
                      indexBarOptions: const IndexBarOptions(
                      textStyle: TextStyle(fontSize: 16.0),
                        needRebuild: true,
                        indexHintAlignment: Alignment.center
                      ),
                      // Customize the index bar data as per your item list
                    ),
                  );
                }
              ),    
            ],
          ),
        )
      );
  }

 Widget selectTask(double w, double h, setState, String id) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Consumer<Tasks>(
        builder: (context, data, child) {
          if(data.selfTasks.isEmpty){
            return Stack(
              children: [
                Container(
                  width: w,
                  height: h/1.05,
                  padding: const EdgeInsets.only(top: 50),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(40)),
                    color: Colors.transparent,
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(top: 40),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40)),
                      color: AppColors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 75,),
                        SvgPicture.asset(AppAssets.noTask, width: 120,),
                        const Text(
                          'No tasks assigned yet',
                          style: TextStyle(
                            color: AppColors.darkMov,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 15,),
                        const Text(
                          'Once someone assigns you a task, it will show here. In the meantime, you can start a task on your own.',
                          style: TextStyle(
                            color: AppColors.darkMov,
                            fontSize: 14.0
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 25,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3), // Shadow color
                          blurRadius: 25, // Spread of the shadow
                          offset: const Offset(0, 4), // Offset of the shadow
                        ),
                      ],                 
                    ),
                    child: InkWell(
                      onTap: (){
                        setState(()=> itemSelected = -1);
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        color: AppColors.darkMov,
                      ),
                    ),
                ),)
              ],
            );
          }
          return Stack(
            children: [
              Container(
                width: w,
                height: h/1.05,
                padding: const EdgeInsets.only(top: 50),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(40)),
                    color: Colors.transparent,
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(top: 40),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40)),
                      color: AppColors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10.0,),
                            const Text(
                              'Start a task',
                              style: TextStyle(
                                color: AppColors.darkMov,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                            const SizedBox(height: 40.0,),
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Select task',
                                style: TextStyle(
                                  color: AppColors.darkMov,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            const SizedBox(height: 30.0,),
                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 15.0,
                              childAspectRatio: (1 / 1.4),
                              mainAxisSpacing: 15.0,
                              children: List.generate(data.selfTasks.length, (index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        setState(()=> itemSelected = index);
                                      },
                                      child: Container(
                                        height:  h / 4.6,
                                        decoration: BoxDecoration(
                                          color: getTaskBg(data.selfTasks[index]['task_type'] ?? ''),
                                          borderRadius: BorderRadius.circular(10.0),
                                          border: itemSelected == index
                                          ? Border.all(
                                              color: getBorderColor(data.selfTasks[index]['task_type'] ?? '') 
                                            )
                                          : null
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                left: 15.0, 
                                                top: 15.0
                                              ),
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0, 
                                                vertical: 8.0
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(99),
                                                color: getTaskBgStyle(data.selfTasks[index]['task_type'] ?? '')
                                              ),
                                              child: Text(
                                                data.selfTasks[index]['task_type'] ?? '',
                                                style: getTaskTextStyle(data.selfTasks[index]['task_type'] ?? '')
                                              ),
                                            ),
                                            const Spacer(),
                                            Align(
                                              alignment: Alignment.center,
                                              child: getCategoryAvatar(data.selfTasks[index]['task_type'] ?? '')
                                            ),
                                            const Spacer(),
                                          ],
                                        )
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    Text(
                                      data.selfTasks[index]['name'] ?? '',
                                      style: const TextStyle(
                                        color: AppColors.darkMov,
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                      if(data.selfTasks[index]['estimated_duration'] != null)
                                        Row(
                                          children: [
                                            SvgPicture.asset(AppAssets.time, width: 12,),
                                            const SizedBox(width: 5.0,),
                                            Text(
                                              '${data.selfTasks[index]['estimated_duration']} ${data.selfTasks[index]['estimated_duration_unit']}',
                                              style: const TextStyle(
                                                fontSize: 11.0,
                                                color: AppColors.lightMov
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                            ),
                            if(itemSelected != -1)
                            SizedBox(height: h / 4,)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                 Positioned(
                  top: 25,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3), // Shadow color
                          blurRadius: 25, // Spread of the shadow
                          offset: const Offset(0, 4), // Offset of the shadow
                        ),
                      ],                 
                    ),
                    child: InkWell(
                      onTap: (){
                        setState(()=> itemSelected = -1);
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        color: AppColors.darkMov,
                      ),
                    ),
                ),
              ),
              Visibility(
                visible: itemSelected != -1,
                child: Positioned(
                  bottom: 50,
                  left: 20,
                  right: 20,
                  child: GestureDetector(
                    onTap: () async{
                     Map result = await context.read<Tasks>().selfTaskSendItem(context: context, taskType: data.selfTasks[itemSelected]['task_type'] , taskId: data.selfTasks[itemSelected]['id'], individualId: id);
                      await startScreeningOrQuestionnaire(
                        context: context,
                        title: '',
                        assignedTaskId: result['id'],
                        name: data.selfTasks[itemSelected]['name'],
                        description: data.selfTasks[itemSelected]['description'],
                        taskType: data.selfTasks[itemSelected]['task_type'],
                        estimatedDuration: data.selfTasks[itemSelected]['estimated_duration'].toString(),
                        scientificName: data.selfTasks[itemSelected]['scientific_name'],
                        slug: data.selfTasks[itemSelected]['slug'] ?? '',
                        numberOfItems: data.selfTasks[itemSelected]['task_type'] == 'SCREENING' ?  data.selfTasks[itemSelected]['number_of_items'] : null
                      );
                    },
                    child: Container(
                      width: w * 0.8,
                      height: 60.0,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(top: 40.0),
                      decoration: BoxDecoration(
                        color:AppColors.lightGreen,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.lightGreen.withOpacity(0.6),
                            spreadRadius: 3,
                            blurRadius: 20,
                            offset: const Offset(0, 3),
                          )
                        ]
                      ),
                      child: const Center(
                        child: Text(
                          'Select task',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18.0,
                            letterSpacing: 0.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
}