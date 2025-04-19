import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:hive/hive.dart';

import 'package:hive_todo/extensions/space_exs.dart';
import 'package:hive_todo/utils/app_strings.dart';
import 'package:hive_todo/views/home/components/fab.dart';
import 'package:hive_todo/views/home/widget/task_widget.dart';
import 'package:lottie/lottie.dart';

import '../../main.dart';
import '../../models/task.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import 'package:animate_do/animate_do.dart';

import 'components/home_app_bar.dart';
import 'components/slider_drawer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();

  //Check value of circle Indicator
  dynamic valueOfIndicator(List<Task> task) {
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 3;
    }
  }

  //Check Done Tasks
  int checkDoneTask(List<Task> tasks) {
    int i = 0;
    for (Task doneTask in tasks) {
      if (doneTask.isCompleted) {
        i++;
      }
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final base = BaseWidget.of(context);
    return ValueListenableBuilder(
      valueListenable: base.dataStore.listenToTask(),
      builder: (ctx, Box<Task> box, Widget? child) {
        var tasks = box.values.toList();

        ///For Sorting List
        tasks.sort((a, b) => a.createdAtDate.compareTo(b.createdAtDate));
        return Scaffold(
          backgroundColor: Colors.white,
          //FLOATING ACTION BUTTON
          floatingActionButton: const FAB(),
          body: SliderDrawer(
            key: drawerKey,
            isDraggable: false,
            animationDuration: 1000,
            slider: CustomDrawer(),
            appBar: HomeAppBar(drawerKey: drawerKey),
            child: _buildHomeBody(textTheme, base, tasks),
          ),
        );
      },
    );
  }

  ///Home Body
  Widget _buildHomeBody(
    TextTheme textTheme,
    BaseWidget base,
    List<Task> tasks,
  ) {
    //final List<int> testing = [1, 3];
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          /// Custom App Bar
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50),

              width: double.infinity,
              height: 100,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ///Progress Indicator
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      value: checkDoneTask(tasks) / valueOfIndicator(tasks),
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation(
                        AppColors.primaryColor,
                      ),
                    ),
                  ),

                  ///Space
                  25.w,

                  ///Top Level Task info
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.mainTitle, style: textTheme.displayLarge),
                      3.h,
                      Text(
                        "${checkDoneTask(tasks)} of ${tasks.length}",
                        style: textTheme.titleMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// Divider
            const Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Divider(thickness: 2, indent: 100),
            ),

            ///Tasks
            SizedBox(
              width: double.infinity,
              height: 500,
              child:
                  tasks.isNotEmpty
                      ///Task list is not empty
                      ? ListView.builder(
                        itemCount: tasks.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          ///Get single Task for showing in List
                          var task = tasks[index];
                          return Dismissible(
                            direction: DismissDirection.horizontal,
                            onDismissed: (_) {
                              base.dataStore.deleteTask(task: task);
                            },
                            background: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.delete_outline,
                                  color: Colors.grey,
                                ),
                                8.w,
                                const Text(
                                  AppStrings.deletedTask,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            key: Key(task.id),
                            child: TaskWidget(task: task),
                          );
                        },
                      )
                      ///Task list is empty
                      : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ///Lottie Anime
                          FadeIn(
                            child: SizedBox(
                              width: 200,
                              height: 200,
                              child: Lottie.asset(
                                lottieURL,
                                animate: tasks.isNotEmpty ? false : true,
                              ),
                            ),
                          ),

                          ///Sub Text
                          FadeInUp(
                            from: 30,
                            child: const Text(AppStrings.doneAllTask),
                          ),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
