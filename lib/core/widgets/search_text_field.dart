import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback onClear;

  const SearchTextField({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.onSubmitted,
    required this.onClear,
  });

  @override
  State<SearchTextField> createState() => SearchTextFieldState();
}

class SearchTextFieldState extends State<SearchTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(SearchTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Search ...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  widget.onClear();
                },
              )
            : null,
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {
        setState(() {});
        widget.onChanged(value);
      },
      onSubmitted: widget.onSubmitted != null
          ? (value) {
              widget.onSubmitted!(value);
            }
          : null,
    );
  }
}
