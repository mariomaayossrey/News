import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'base_state_provider.dart';
class BaseScaffold extends ConsumerStatefulWidget {
  const BaseScaffold({
    required this.body,
    required this.viewModel,
    this.bottomNavigationBar,
    this.appBar,
    this.extend = false,
    this.resizeToAvoidBottomInset = false,
    this.color = const Color(0xff1f2b3c),

    Key? key,
  }) : super(key: key);

  final Widget body;
  final BaseStateProvider viewModel;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final bool extend;
  final bool resizeToAvoidBottomInset;
  final Color? color;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BaseScaffold();
}

class _BaseScaffold extends ConsumerState<BaseScaffold> {
  @override
  Widget build(BuildContext context) {
    ref.listen(widget.viewModel, (previous, next) {
      if (previous?.isLoading != true && next.isLoading == true) {
        if(!EasyLoading.isShow)EasyLoading.show();
      }
      if (previous?.isLoading == true && next.isLoading != true) {
        if(EasyLoading.isShow)EasyLoading.dismiss();
      }
      if (next.hasError) {
        print('there is error ');
        // if (!isEmptyText(next.error!.txID))
        //   ShowBackendErrorAlert(context, next.error!);
        // else
        //   ShowAlertMessage(next.error!.error, context, ValidationType.ERROR);
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: widget.extend,
      appBar: widget.appBar,
      body: widget.body,
      bottomNavigationBar: widget.bottomNavigationBar,
      backgroundColor: widget.color,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
    );
  }
}
