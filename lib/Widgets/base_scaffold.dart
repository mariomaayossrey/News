import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class BaseScaffold extends StatefulWidget {
  const BaseScaffold({
    Key? key,
    required this.body,
    required this.state,
    this.bottomNavigationBar,
    this.appBar,
    this.extend = false,
    this.resizeToAvoidBottomInset = false,
    this.color = Colors.white,
  }) : super(key: key);

  final Widget body;
  final dynamic state;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final bool extend;
  final bool resizeToAvoidBottomInset;
  final Color? color;

  @override
  _BaseScaffoldState createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  @override
  void initState() {
    super.initState();
    _handleLoadingState();
  }

  @override
  void didUpdateWidget(covariant BaseScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    _handleLoadingState();
  }

  void _handleLoadingState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final isLoading = _isLoading(widget.state);

        if (isLoading && !EasyLoading.isShow) {
          EasyLoading.show(status: 'Loading...');
        } else if (!isLoading && EasyLoading.isShow) {
          EasyLoading.dismiss();
        }
      } catch (e) {
        print('Error in BaseScaffold: $e');
      }
    });
  }

  bool _isLoading(dynamic state) {
    try {
      return state.isLoading == true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
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