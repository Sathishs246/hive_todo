import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';
//import 'package:hive_todo/main.dart';
import 'package:hive_todo/utils/app_strings.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../main.dart';

String lottieURL = 'assets/lottie/1.json';

///Empty Title Or SubTitle TextField Warning
dynamic emptyWarning(BuildContext context) {
  return FToast.toast(
    context,
    msg: AppStrings.oopsMsg,
    subMsg: 'You Must fill all the fields!',
    corner: 20.0,
    duration: 2000,
    padding: const EdgeInsets.all(20),
  );
}

///Nothing Entered when user try to edit or update the current task
dynamic updateTaskWarning(BuildContext context) {
  return FToast.toast(
    context,
    msg: AppStrings.oopsMsg,
    subMsg: 'You must edit the tasks then try to update it!',
    corner: 20.0,
    duration: 5000,
    padding: const EdgeInsets.all(20),
  );
}

///No Task Warning dialog for deleting
dynamic warningNoTask(BuildContext context) {
  return PanaraInfoDialog.showAnimatedGrow(
    context,
    title: AppStrings.oopsMsg,
    message:
        "There is no Task For Delete!\n Try adding some and then try to delete it!",
    buttonText: "Okay",
    onTapDismiss: () {
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.warning,
  );
}

///Delete All Task From DB Dialog
dynamic deletedAllTask(BuildContext context) {
  return PanaraConfirmDialog.show(
    context,
    title: AppStrings.areYouSure,
    message:
        "Do You really want to delete all tasks? You will no beable to undo this action!",
    confirmButtonText: 'Yes',
    cancelButtonText: 'No',
    onTapConfirm: () {
      BaseWidget.of(context).dataStore.box.clear();
      Navigator.pop(context);
    },
    onTapCancel: () {
      Navigator.pop(context);
    },

    panaraDialogType: PanaraDialogType.error,
    barrierDismissible: false,
  );
}
