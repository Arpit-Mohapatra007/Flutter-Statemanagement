import 'package:flutter/material.dart';
import 'package:learning_rxdart_2/dialogs/generic_dialog.dart';

Future<bool> showDeleteAccountDialog({
  required BuildContext context
}){
  return showGenericDialog(
    context: context, 
    title: 'Delete Account', 
    content: 'Are you sure you want to delete your account?', 
    optionsBuilder: () => {
      'Cancel': false,
      'Delete': true,
    }
  ).then((value)=>value ?? false);
}