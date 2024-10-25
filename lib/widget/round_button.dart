import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  const RoundButton(
      {Key? key,
      required this.data,
      required this.onTap,
      this.loading = false,
      required this.istap})
      : super(key: key);
  final String data;
  final VoidCallback onTap;
  final bool loading;
  final bool istap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 45,
        width: 80,
        decoration: BoxDecoration(
            color: istap ? Colors.blueAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
                color: Colors.white,
                strokeAlign: BorderSide.strokeAlignCenter)),
        child: Center(
          child: loading
              ? const CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                )
              : Text(
                  data,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
        ),
      ),
    );
  }
}
