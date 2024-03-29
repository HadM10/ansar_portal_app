import 'package:flutter/material.dart';

class BouncingButton extends StatefulWidget {
  final VoidCallback onPressed;

  const BouncingButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  _BouncingButtonState createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<BouncingButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1, end: 0.9).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        _controller.forward();
      },
      onTapUp: (details) {
        _controller.reverse();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _animation,
        child: OutlinedButton.icon(
          onPressed: widget.onPressed,
          icon: const Icon(Icons.login, color: Colors.white),
          label: const Text('Sign In', style: TextStyle(color: Colors.white)),
          style: OutlinedButton.styleFrom(
            shadowColor: Colors.black,
            side: BorderSide.none,
            elevation: 10,
            backgroundColor: Colors.deepOrange[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // less border radius
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class SignUpButton extends StatefulWidget {
  final VoidCallback onPressed;

  const SignUpButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  _SignUpButtonState createState() => _SignUpButtonState();
}

class _SignUpButtonState extends State<SignUpButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1, end: 0.9).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        _controller.forward();
      },
      onTapUp: (details) {
        _controller.reverse();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _animation,
        child: OutlinedButton.icon(
          onPressed: widget.onPressed,
          icon: const Icon(Icons.person_add, color: Colors.white),
          label: const Text('Sign Up', style: TextStyle(color: Colors.white)),
          style: OutlinedButton.styleFrom(
            shadowColor: Colors.black,
            side: BorderSide.none,
            elevation: 10,
            backgroundColor: Colors.deepOrange[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // less border radius
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
