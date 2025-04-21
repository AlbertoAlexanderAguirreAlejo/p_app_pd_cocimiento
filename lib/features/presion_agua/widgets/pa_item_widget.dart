import 'package:app_pd_cocimiento/core/constants/app_constants.dart';
import 'package:app_pd_cocimiento/core/models/db/recipiente.dart';
import 'package:app_pd_cocimiento/core/theme/app_theme.dart';
import 'package:app_pd_cocimiento/core/utils/input_formatters/number_input_formatter.dart';
import 'package:app_pd_cocimiento/widgets/custom_dropdown_widget.dart';
import 'package:app_pd_cocimiento/widgets/custom_item_card_widget.dart';
import 'package:flutter/material.dart';

class PAItemWidget extends StatefulWidget {
  final String timeLabel;
  final String psigValue;
  final ValueChanged<String> onPsigChanged;
  final Recipiente? selectedTacho;
  final List<Recipiente> tachos;
  final ValueChanged<Recipiente?> onTachoChanged;
  final Color headerColor;

  const PAItemWidget({
    super.key,
    required this.timeLabel,
    required this.psigValue,
    required this.onPsigChanged,
    required this.selectedTacho,
    required this.tachos,
    required this.onTachoChanged,
    this.headerColor = AppTheme.darkGreen,
  });

  @override
  State<PAItemWidget> createState() =>
      _PAItemWidgetState();
}

class _PAItemWidgetState extends State<PAItemWidget> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  String get _initialText => widget.psigValue == "0" ? "" : widget.psigValue;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _initialText);
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      final value = _controller.text.isEmpty ? "0" : _controller.text;
      widget.onPsigChanged(value);
    }
  }

  @override
  void didUpdateWidget(covariant PAItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.psigValue != oldWidget.psigValue) {
      final newText = widget.psigValue == "0" ? "" : widget.psigValue;
      _controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomItemCardWidget(
      headerTitle: widget.timeLabel,
      headerColor: widget.headerColor,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Columna del dropdown (Tacho)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Tacho:",
                  style: TextStyle(
                    fontSize: AppConstants.subTitleSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                CustomDropdownWidget<Recipiente, int>(
                  hintText: "Selecciona",
                  selectedItem: widget.selectedTacho,
                  items: widget.tachos,
                  valueExtractor: (Recipiente r) => r.idFabRecipiente,
                  itemLabel: (Recipiente r) => r.descripcion,
                  onChanged: widget.onTachoChanged,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Columna del campo de texto (Presión)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Presión (psig)",
                  style: TextStyle(
                    fontSize: AppConstants.subTitleSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  focusNode: _focusNode,
                  controller: _controller,
                  textAlign: TextAlign.center,
                  inputFormatters: [NumberInputFormatter()],
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}