import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputTextField extends StatefulWidget {
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final String title;
  final IconData icon;
  final String hint;
  final TextInputType type;
  final bool obscure;
  final String keyInput;
  final TextInputAction textInputAction;
  final String? text;

  const InputTextField({
    Key? key,
    this.onSubmitted,
    this.onChanged,
    required this.title,
    required this.icon,
    required this.hint,
    required this.type,
    required this.obscure,
    required this.keyInput,
    this.textInputAction = TextInputAction.next,
    this.text,
  }) : super(key: key);

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.text);
    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 10.h),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 48.h,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  key: Key(widget.keyInput),
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  controller: _controller,
                  keyboardType: widget.type,
                  textInputAction: TextInputAction.next,
                  obscureText: widget.obscure,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                    prefixIcon: Icon(widget.icon, color: Colors.black87),
                    hintText: widget.hint,
                    suffix: widget.obscure ? Icon(Icons.visibility) : null,
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.black45),
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.black87),
                ),
              ),
              SizedBox(width: 20.w),
            ],
          ),
        ),
      ],
    );
  }
}
