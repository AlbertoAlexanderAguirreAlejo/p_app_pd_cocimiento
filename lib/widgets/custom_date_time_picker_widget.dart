import 'package:app_pd_cocimiento/core/constants/turnos.dart';
import 'package:app_pd_cocimiento/core/models/app/turno.dart';
import 'package:app_pd_cocimiento/core/preferences/app_preferences.dart';
import 'package:app_pd_cocimiento/core/theme/app_theme.dart';
import 'package:app_pd_cocimiento/core/utils/date_formatter.dart';
import 'package:app_pd_cocimiento/core/utils/message_toast.dart';
import 'package:app_pd_cocimiento/app.dart';
import 'package:app_pd_cocimiento/widgets/custom_restricted_time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDateTimePickerWidget extends StatefulWidget {
  final DateTime? initialDateTime;
  final ValueChanged<DateTime>? onChanged;
  final String? label;
  final InputDecoration? decoration;
  final String? hintText;
  final String? dateFormat;
  final TextAlign textAlign;
  final DateTime? minTime;
  final DateTime? maxTime;

  const CustomDateTimePickerWidget({
    super.key,
    this.initialDateTime,
    this.onChanged,
    this.label,
    this.decoration,
    this.hintText,
    this.dateFormat,
    this.textAlign = TextAlign.center,
    this.minTime,
    this.maxTime,
  });

  @override
  State<CustomDateTimePickerWidget> createState() => _CustomDateTimePickerWidgetState();
}

class _CustomDateTimePickerWidgetState extends State<CustomDateTimePickerWidget> {
  late DateTime selectedDateTime;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.initialDateTime ?? DateTime.now();
    _controller = TextEditingController(
      text: formatIsoDate(selectedDateTime.toIso8601String(), pattern: widget.dateFormat),
    );
  }

  @override
  void didUpdateWidget(covariant CustomDateTimePickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDateTime != oldWidget.initialDateTime) {
      selectedDateTime = widget.initialDateTime ?? DateTime.now();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.text = formatIsoDate(selectedDateTime.toIso8601String(), pattern: widget.dateFormat);
        }
      });
    }
  }

  Future<void> _selectDateTime() async {
    final BuildContext? globalContext = navigatorKey.currentContext;
    if (globalContext == null) return;

    // Obtiene las preferencias para el turno activo.
    final AppPreferences prefs = Provider.of<AppPreferences>(globalContext, listen: false);
    final int turnoNumber = prefs.activeTurno;
    final Turno activeTurno = Turnos.getTurno(turnoNumber);
    // Usamos la fecha activa almacenada en preferencias para calcular el rango.
    final String activeFechaStr = prefs.activeFecha;
    final DateTime baseDate = activeFechaStr.isNotEmpty ? DateTime.parse(activeFechaStr) : DateTime.now();
    final DateTime baseDateOnly = DateTime(baseDate.year, baseDate.month, baseDate.day);

    // Calcula el rango permitido para la selección de fecha.
    late DateTime effectiveFirstDate;
    late DateTime effectiveLastDate;
    if (activeTurno.numero != 3) {
      // Para turnos 1 y 2 solo se permite la fecha base.
      effectiveFirstDate = widget.minTime ?? baseDateOnly;
      effectiveLastDate = widget.maxTime ?? baseDateOnly;
      // Forzamos que selectedDateTime tenga la fecha base.
      if (selectedDateTime.year != baseDateOnly.year ||
          selectedDateTime.month != baseDateOnly.month ||
          selectedDateTime.day != baseDateOnly.day) {
        selectedDateTime = baseDateOnly;
      }
    } else {
      // Para turno 3 (o 0), se permite seleccionar la fecha base o la del día siguiente.
      effectiveFirstDate = widget.minTime ?? baseDateOnly;
      effectiveLastDate = widget.maxTime ?? baseDateOnly.add(const Duration(days: 1));
    }

    // Si solo hay una fecha disponible (rango único), se asigna directamente.
    DateTime pickedDate;
    if (effectiveFirstDate.isAtSameMomentAs(effectiveLastDate)) {
      pickedDate = effectiveFirstDate;
    } else {
      final DateTime? tempPicked = await showDatePicker(
        context: globalContext,
        initialDate: selectedDateTime,
        firstDate: effectiveFirstDate,
        lastDate: effectiveLastDate,
        locale: const Locale('es', 'ES'),
      );
      if (tempPicked == null) return;
      pickedDate = tempPicked;
    }

    // Calcula el rango permitido para la selección de hora.
    final DateTime pickedDateOnly = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
    final bool isBaseDate = pickedDateOnly.difference(baseDateOnly).inDays == 0;
    final bool isNextDay = pickedDateOnly.difference(baseDateOnly).inDays == 1;

    late DateTime effectiveMinTime;
    late DateTime effectiveMaxTime;

    if (activeTurno.numero != 3) {
      effectiveMinTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, activeTurno.start.hour, activeTurno.start.minute);
      effectiveMaxTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, activeTurno.end.hour, activeTurno.end.minute);
    } else {
      if (isBaseDate) {
        effectiveMinTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, activeTurno.start.hour, activeTurno.start.minute);
        effectiveMaxTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, 23, 59);
      } else if (isNextDay) {
        effectiveMinTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, 0, 0);
        effectiveMaxTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, activeTurno.end.hour, activeTurno.end.minute);
      } else {
        messageToast(descripcion: "La fecha seleccionada no está dentro del rango permitido para el turno actual");
        return;
      }
    }

    // Muestra el selector de hora restringido mediante CupertinoPicker personalizado.
    final TimeOfDay? pickedTime = await showDialog<TimeOfDay>(
      context: globalContext,
      builder: (context) {
        return AlertDialog(
          title: const Text("Seleccione la hora"),
          content: CustomRestrictedTimePickerWidget(
            currentTime: selectedDateTime,
            minTime: effectiveMinTime,
            maxTime: effectiveMaxTime,
            onConfirm: (time) {
              Navigator.pop(context, time);
            },
          ),
        );
      },
    );

    if (pickedTime != null) {
      final DateTime newDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      if (newDateTime.isBefore(effectiveMinTime) || newDateTime.isAfter(effectiveMaxTime)) {
        messageToast(descripcion: "La hora seleccionada no está dentro del rango permitido");
        return;
      }
      setState(() {
        selectedDateTime = newDateTime;
        _controller.text = formatIsoDate(newDateTime.toIso8601String(), pattern: widget.dateFormat);
      });
      if (widget.onChanged != null) {
        widget.onChanged!(newDateTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveDecoration = widget.decoration ??
        const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          filled: true,
          fillColor: Colors.white,
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.label!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.blue,
              ),
            ),
          ),
        GestureDetector(
          onTap: _selectDateTime,
          child: AbsorbPointer(
            child: TextFormField(
              controller: _controller,
              decoration: effectiveDecoration.copyWith(
                hintText: widget.hintText,
              ),
              readOnly: true,
              textAlign: widget.textAlign,
            ),
          ),
        ),
      ],
    );
  }
}
