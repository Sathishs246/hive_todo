import 'package:flutter/material.dart';
import 'package:hive_todo/views/tasks/task_view.dart';
import 'package:intl/intl.dart';

import '../../../models/task.dart';
import '../../../utils/app_colors.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({super.key, required this.task});

  final Task task;
  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  TextEditingController textEditingControllerforTitle = TextEditingController();
  TextEditingController textEditingControllerforSubTitle =
      TextEditingController();

  @override
  void initState() {
    textEditingControllerforTitle.text = widget.task.title;
    textEditingControllerforSubTitle.text = widget.task.subTitle;
    super.initState();
  }

  @override
  void dispose() {
    textEditingControllerforTitle.dispose();
    textEditingControllerforSubTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ///Navigate to Task View to see Task Details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (ctx) => TaskView(
                  titleTaskController: textEditingControllerforTitle,
                  descriptionTaskController: textEditingControllerforSubTitle,
                  task: widget.task,
                ),
          ),
        );
      },
      child: AnimatedContainer(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              widget.task.isCompleted
                  ? const Color.fromARGB(154, 119, 144, 229)
                  : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        duration: const Duration(milliseconds: 600),
        child: ListTile(
          /// Check Icon
          leading: GestureDetector(
            onTap: () {
              widget.task.isCompleted = !widget.task.isCompleted;
              widget.task.save();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              decoration: BoxDecoration(
                color:
                    widget.task.isCompleted
                        ? AppColors.primaryColor
                        : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: .8),
              ),
              child: const Icon(Icons.check, color: Colors.white),
            ),
          ),

          ///Task Title
          title: Padding(
            padding: const EdgeInsets.only(top: 3, bottom: 5),
            child: Text(
              textEditingControllerforTitle.text,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Task Description
              Text(
                textEditingControllerforSubTitle.text,
                style: TextStyle(
                  color:
                      widget.task.isCompleted
                          ? AppColors.primaryColor
                          : Colors.black,
                  fontWeight: FontWeight.w300,
                  decoration:
                      widget.task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                ),
              ),

              ///Date of Task
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('hh:mm a').format(widget.task.createdAtTime),
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              widget.task.isCompleted
                                  ? Colors.white
                                  : Colors.grey,
                        ),
                      ),
                      Text(
                        DateFormat.yMMMEd().format(widget.task.createdAtDate),
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              widget.task.isCompleted
                                  ? Colors.white
                                  : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
