import 'package:flutter/material.dart';
import 'package:learning_rxdart_2/blocs/auth_bloc/auth_error.dart';
import 'package:learning_rxdart_2/dialogs/generic_dialog.dart';

Future<void> showAuthError({
  required AuthError authError,
  required BuildContext context,
}){
  return showGenericDialog<void>(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogText,
    optionsBuilder: ()=>{
      'OK': null,
    },
  );
}