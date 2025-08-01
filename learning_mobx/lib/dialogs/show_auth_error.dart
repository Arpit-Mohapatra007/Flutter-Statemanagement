import 'package:flutter/material.dart' show BuildContext;
import 'package:learning_mobx/auth/auth_error.dart';
import 'package:learning_mobx/dialogs/generic_dialog.dart';

Future<void> showAuthError({
  required AuthError authError,
  required BuildContext context,
}) {
  return showGenericDialog<void>(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogText,
    optionsBuilder: () => {
      'OK': true,
    },
  );
}
