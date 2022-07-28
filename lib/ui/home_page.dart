// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_algoriza/controllers/task_controller.dart';
import 'package:todo_algoriza/models/task.dart';
import 'package:todo_algoriza/services/theme_services.dart';
import 'package:todo_algoriza/ui/add_task_bar.dart';
import 'package:todo_algoriza/ui/widgets/Task_tile.dart';
import 'package:todo_algoriza/ui/widgets/button.dart';
import 'theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: context.theme.backgroundColor,
      body: Column(

        children: [
          const Divider(
            color: Colors.grey,
            height: 0.5,
            thickness: 0.5,
            indent: 0,
            endIndent: 0,
          ),
         // _addTaskBar(),
          _addDateBar(),
          const SizedBox(
            height: 20,
          ),
          const Divider(
            color: Colors.grey,
            height: 0.5,
            thickness: 0.5,
            indent: 0,
            endIndent: 0,
          ),
          _addTaskBarr(),
          const SizedBox(
            height: 10,
          ),
          _showTasks(),
          //Expanded(child: Container(),),
          Align(
            alignment:Alignment.bottomCenter ,
            child: Container(width: 340,
                child: MyButton(label: 'Add a Task', onTap: ()async{
                await  Get.to(()=> const AddTaskPage());
                _taskController.getTasks();

                }
                ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),

        ],
      ),
    );
  }
  _showTasks(){
    return Expanded(
      child: Obx((){
        return ListView.builder(
                  itemCount: _taskController.taskList.length,

            itemBuilder: (_,index){
                    print(_taskController.taskList.length);
              Task task = _taskController.taskList[index];
              print(task.toJson());
              if(task.repeat=='Daily'){
                DateTime date =DateFormat.jm().parse(task.startTime.toString());
                var myTime =DateFormat('HH:mm').format(date);
              //  notifyHelper.scheduledNotification();
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              _showBottomSett(context,task);
                            },
                            child:TaskTile(task),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              if(task.date==DateFormat.yMd().format(_selectedDate)){
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              _showBottomSett(context,task);
                            },
                            child:TaskTile(task),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }else{
                  return Container();
              }



        });
      }),
    );
  }
  _showBottomSett(BuildContext context, Task task ){
    Get.bottomSheet(
      Container(
      padding: const EdgeInsets.only(top: 4),
      height: task.isCompleted==1?
      MediaQuery.of(context).size.height*0.24:
      MediaQuery.of(context).size.height*0.32,
          color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300],
              ),
            ),
            const Spacer(),
            task.isCompleted==1?
                Container():
                _bottomSheetButton(
                    label: 'Task Completed',
                    onTap: (){
                      _taskController.markTaskCompleted(task.id!);
                      Get.back();
                    },
                    clr: primaryClr,
                  context:context,
                ),
            const SizedBox(
              height: 20,
            ),
            _bottomSheetButton(
              label: 'Delete Task',
              onTap: (){
                _taskController.delete(task);
                Get.back();
              },
              clr: Colors.red[500]!,
              context:context,
            ),
            const SizedBox(
              height: 20,
            ),
            _bottomSheetButton(
              label: 'Add To Favorite',
              onTap: (){
                Get.back();
              },
              clr: Colors.yellowAccent,
              isClose: true,
              context:context,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),

      ),
    );
  }

  _bottomSheetButton({
    required String label ,
    required Function()? onTap,
    required Color clr,
    bool isClose=false,
    required BuildContext context,

}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width*0.9 ,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color:isClose==true?Colors.grey[300]!:clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose==true?Colors.yellow:clr,
        ),
        child: Center(
          child: Text(
            label,
            style: titleStyle.copyWith(color:Colors.white),
          ),
        ),
      ),
    );

  }
  _addDateBar(){
    return Container(
      margin: const EdgeInsets.only(top: 20 ,left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 60,
        width: 42,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),

        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),

        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 7,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date){
          setState((){
            _selectedDate=date;
          });
        },


      ),
    ) ;
  }
  _addTaskBar(){
    return  Container(
      margin: const EdgeInsets.only(left: 20, right: 20,top:10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle ,),
                Text('Today',
                  style: headingStyle,
                ),
              ],
            ),
          ),

         // MyButton(label: '+ Add Task', onTap: ()=>Get.to(AddTaskPage())),

        ],
      ),
    );
  }
  _addTaskBarr(){
    return  Container(
      margin: const EdgeInsets.only(left: 20, right: 20,top:10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(DateFormat.EEEE().format(DateTime.now()),
            style: headingStyle ,),
          Container(
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(DateFormat.d().format(DateTime.now()),
                  style: subHeadingStyle ,),
                Text(DateFormat.MMM().format(DateTime.now()),
                  style: subHeadingStyle ,),
                Text(',', style: subHeadingStyle),
                Text(DateFormat.y().format(DateTime.now()),
                  style: subHeadingStyle ,),


              ],
            ),
          ),


          // MyButton(label: '+ Add Task', onTap: ()=>Get.to(AddTaskPage())),

        ],
      ),
    );
  }
}

appBar(){
  return AppBar(
    backgroundColor: Colors.white,
   elevation: 0,
    title:Text('Schedule',
      style: appBarTitleStyle,),
   //leading: GestureDetector(onTap:(){ThemeService().switchTheme();}, child: const Icon(Icons.nightlight_round, size: 20,color: Colors.black,),),

  );
}