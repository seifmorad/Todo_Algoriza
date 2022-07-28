import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:todo_algoriza/controllers/task_controller.dart';
import 'package:todo_algoriza/models/task.dart';
import 'package:todo_algoriza/ui/theme.dart';
import 'package:todo_algoriza/ui/widgets/button.dart';
import 'package:todo_algoriza/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime='11:59 PM';
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [
    10,
    30,
    60,
    1440,
  ];
  String _selectedRepeat = 'None';
  List<String> repeatList = [
    'None',
    'Daily',
    'Weekly',
    'Monthly',

  ];
  int _selectedColor= 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20 ,right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                MyInputField(hint: 'Enter your title', title: 'Title',controller: _titleController,),
                MyInputField(hint: 'Enter your note', title: 'Note',controller: _noteController,),
              MyInputField(hint: DateFormat.yMd().format(_selectedDate), title: 'Date',
              widget: IconButton(
                icon: Icon(Icons.calendar_today_outlined,
                color: Colors.grey,),
                onPressed:(){
                  _getDateFromUser();

                },
              ),),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                    title: 'Start Time',
                    hint: _startTime,
                    widget: IconButton(
                      onPressed: (){
                        _getTimeFromUser(isStartTime: true);
                      },
                      icon: Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  ),),
                  SizedBox(width: 12,),
                  Expanded(
                    child: MyInputField(
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: (){
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),),
                ],
              ),
              MyInputField(
                  hint: '$_selectedRemind minutes early',
                  title: 'Remind',
                  widget: DropdownButton(
                    icon: Icon(Icons.keyboard_arrow_down,
                    color: Colors.grey,

                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(height: 0,),
                    onChanged: (String? newValue) {
                      setState((){
                        _selectedRemind = int.parse(newValue!);
                      });
                    },
                    items: remindList.map<DropdownMenuItem<String>>((int value){
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString(),style: TextStyle(color: Colors.grey))
                      );
                    }

                    ).toList(),

                  ),

              ),
              MyInputField(
                hint: '$_selectedRepeat',
                title: 'Repeat',
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down,
                    color: Colors.grey,

                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0,),
                  onChanged: (String? newValue) {
                    setState((){
                      _selectedRepeat = newValue!;
                    });
                  },
                  items: repeatList.map<DropdownMenuItem<String>>((String? value){
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value!, style: TextStyle(color: Colors.grey))
                    );
                  }

                  ).toList(),

                ),

              ),
              SizedBox(height: 18,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPalette(),
                 // MyButton(label: 'Create Task',onTap:()=>_validateData() ,),
                ],
              ),
              SizedBox(height: 18,),
              Align(
                alignment:AlignmentDirectional.center ,
                child: Container(
                  width: 400,
                    child: MyButton(label:  'Create a Task',onTap:()=>_validateData() ,)),
              ),

            ],

          ),
        ),
      ),
    );
  }
_validateData(){
  if(_titleController.text.isNotEmpty&&_noteController.text.isNotEmpty){
   _addTaskToDb();
    Get.back();
  }else if(_titleController.text.isEmpty ||  _noteController.text.isEmpty){
    Get.snackbar('Required', 'All Fields are required !',
    snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: pinkClr,
      icon: Icon((Icons.warning_amber_rounded),),
    );
  }
}


_addTaskToDb()async{
int value = await _taskController.addTask(
    task:Task(
      note:_noteController.text,
      title: _titleController.text,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      remind : _selectedRemind,
      repeat: _selectedRepeat,
      color: _selectedColor,
      isCompleted: 0 ,
    ),

);
print('My id is'+'$value');
}




  _colorPalette(){
    return   Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color',
          style: titleStyle,
        ),
        SizedBox(height: 8.0,),
        Wrap(
          children: List<Widget>.generate(3, (int index){
            return GestureDetector(
              onTap: (){
                setState((){
                  _selectedColor=index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0,),
                child: CircleAvatar(

                  radius: 14,
                  backgroundColor: index==0?bluishClr:index==1?pinkClr:yellowClr,
                  child: _selectedColor==index?Icon(Icons.done,
                    color: Colors.white,
                    size: 16,):Container(),

                ),
              ),
            );
          }),
        ),
      ],
    );
  }
  appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
        leading: GestureDetector(
        onTap:(){
          Get.back();
    },
          child: const Icon(Icons.arrow_back_ios_new_rounded,
          size: 20,
            color: Colors.black,
          ),
        ),

        title:Text('Add Task',
          style: appBarTitleStyle,),);
  }
  _getDateFromUser()async{
    
    DateTime? _pickerDate = await showDatePicker(
        context: context, 
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(2222),
    );

    if(_pickerDate!=null){
      setState((){
        _selectedDate=_pickerDate;
      });
    }else{
      print('Something is wrong');
    }
}
  _getTimeFromUser({required bool isStartTime})async{
    var pickedTime = await _showTimePicker();
    String _formatedTime  = pickedTime.format(context);
    if(
    pickedTime==null){
      print('Time canceld');
    }else if(isStartTime==true){
      setState((){
        _startTime=_formatedTime;
      });

    }else if(isStartTime==false){
      setState((){
        _endTime=_formatedTime;
      });


    }
  }
  _showTimePicker(){
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
        initialTime: TimeOfDay(

          hour: int.parse(_startTime.split(':')[0]) ,
          minute: int.parse(_startTime.split(':')[1].split(' ')[0]),
        ),
    );
  }
  
}
