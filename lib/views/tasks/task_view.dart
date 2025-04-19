import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:hive_todo/extensions/space_exs.dart';
import 'package:hive_todo/main.dart';
import 'package:hive_todo/utils/app_colors.dart';
import 'package:hive_todo/utils/app_strings.dart';
import 'package:hive_todo/views/tasks/widget/task_view_app_bar.dart';
import 'package:intl/intl.dart';

import '../../models/task.dart';
import '../../utils/constants.dart';
import 'components/date_time_selection.dart';
import 'components/rep_textfield.dart';

class TaskView extends StatefulWidget {
  const TaskView({
    super.key,
    required this.titleTaskController,
    required this.descriptionTaskController,
    required this.task,
  });
  final TextEditingController? titleTaskController;
  final TextEditingController? descriptionTaskController;
  final Task? task;
  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var title;
  var subTitle;
  DateTime? time;
  DateTime? date;

  //Show Selected Time as String Format
  String showTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      } else {
        return DateFormat('hh:mm a').format(time).toString();
      }
    } else {
      return DateFormat(
        'hh:mm a',
      ).format(widget.task!.createdAtTime).toString();
    }
  }

  //Show Selected Date as String Format
  String showDate(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(date).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.task!.createdAtDate).toString();
    }
  }

  //Show Selected Date as DateFormat for init Time

  DateTime showDateAsDateTime(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return widget.task!.createdAtDate;
    }
  }

  //if any Task Already Exist return True Otherwise False
  bool isTaskAlreadyExist() {
    if (widget.titleTaskController?.text == null &&
        widget.descriptionTaskController?.text == null) {
      return true;
    } else {
      return false;
    }
  }

  ///Main Function for creating or updating tasks

  dynamic isTaskAlreadyExistUpdateOtherWiseCreate() {
    ///HERE WE UPDATE CURRENT TASK
    if (widget.titleTaskController?.text != null &&
        widget.descriptionTaskController?.text != null) {
      try {
        widget.titleTaskController?.text = title;
        widget.descriptionTaskController?.text = subTitle;

        widget.task?.save();

        Navigator.pop(context);

        ///TODO:pop page
      } catch (e) {
        ///If user want to update task but entered nothing we will show this warning
        updateTaskWarning(context);
      }
    }
    ///Here we Create a new Task
    else {
      if (title != null && subTitle != null) {
        var task = Task.create(
          title: title,
          subTitle: subTitle,
          createdAtDate: date,
          createdAtTime: time,
        );

        ///we are adding this task to HiveDb using inherited widget
        BaseWidget.of(context).dataStore.addTask(task: task);

        Navigator.pop(context);

        ///TODO:pop page
      } else {
        ///warning
        emptyWarning(context);
      }
    }
  }

  ///Delete Task
  dynamic deleteTask() {
    return widget.task?.delete();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        ///Task View
        appBar: const TaskViewAppBar(),

        ///Body
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ///Top Side Texts
                _buildTopSideTexts(textTheme),

                ///Main Task View Activity
                _buildMainTaskViewActivity(
                  textTheme,
                  context,
                  widget.titleTaskController,
                  widget.descriptionTaskController,
                ),

                ///Bottom Side Buttons
                _buildBottomSideButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///Bottom Side Buttons
  Widget _buildBottomSideButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment:
            isTaskAlreadyExist()
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceEvenly,
        children: [
          isTaskAlreadyExist()
              ? Container()
              :
              ///Delete Current Task Button
              MaterialButton(
                onPressed: () {
                  deleteTask();
                  Navigator.pop(context);
                },
                minWidth: 150,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.white,
                height: 55,
                child: Row(
                  children: [
                    const Icon(Icons.close, color: AppColors.primaryColor),
                    5.w,
                    const Text(
                      AppStrings.deleteTask,
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  ],
                ),
              ),

          ///Add Or Update Task
          MaterialButton(
            onPressed: () {
              isTaskAlreadyExistUpdateOtherWiseCreate();
            },
            minWidth: 150,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: AppColors.primaryColor,
            height: 55,
            child: Text(
              isTaskAlreadyExist()
                  ? AppStrings.addTaskString
                  : AppStrings.updateTaskString,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  ///Main Task View Activity
  Widget _buildMainTaskViewActivity(
    TextTheme textTheme,
    BuildContext context,
    titleTaskController,
    descriptionTaskController,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 530,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Title of TextField
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              AppStrings.titleOfTitleTextField,
              style: textTheme.headlineMedium,
            ),
          ),

          ///Task Title
          RepTextField(
            controller: titleTaskController,
            onChanged: (String inputTitle) {
              title = inputTitle;
            },
            onFieldSubmitted: (String inputTitle) {
              title = inputTitle;
            },
          ),

          10.h,
          RepTextField(
            controller: descriptionTaskController,
            isForDescription: true,
            onChanged: (String inputSubTitle) {
              subTitle = inputSubTitle;
            },
            onFieldSubmitted: (String inputSubTitle) {
              subTitle = inputSubTitle;
            },
          ),

          ///Time Selection
          DateTimeSelectionWidget(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder:
                    (_) => SizedBox(
                      height: 280,
                      child: TimePickerWidget(
                        initDateTime: showDateAsDateTime(time),
                        onChange: (_, _) {},
                        dateFormat: 'HH:mm',
                        onConfirm: (dateTime, _) {
                          setState(() {
                            if (widget.task?.createdAtTime == null) {
                              time = dateTime;
                            } else {
                              widget.task!.createdAtTime == dateTime;
                            }
                          });
                        },
                      ),
                    ),
              );
            },
            title: "Time",
            time: showTime(time),
            isTime: true,
          ),

          ///Date Selection
          DateTimeSelectionWidget(
            onTap: () {
              DatePicker.showDatePicker(
                context,
                maxDateTime: DateTime(2030, 12, 31),
                minDateTime: DateTime.now(),
                initialDateTime: showDateAsDateTime(date),
                onConfirm: (dateTime, _) {
                  setState(() {
                    if (widget.task?.createdAtDate == null) {
                      date = dateTime;
                    } else {
                      widget.task!.createdAtDate == dateTime;
                    }
                  });
                },
              );
            },
            title: AppStrings.dateString,
            time: showDate(date),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSideTexts(TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 70, child: Divider(thickness: 2)),
          RichText(
            text: TextSpan(
              text:
                  isTaskAlreadyExist()
                      ? AppStrings.addNewTask
                      : AppStrings.updateCurrentTask,
              style: textTheme.titleLarge,
              children: const [
                TextSpan(
                  text: AppStrings.taskStrnig,
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          SizedBox(width: 70, child: Divider(thickness: 2)),
        ],
      ),
    );
  }
}
