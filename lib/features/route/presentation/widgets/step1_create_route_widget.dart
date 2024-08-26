// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:path_finder/features/route/domain/entities/entities.dart';
import 'package:path_finder/features/route/presentation/widgets/build_date_picker.dart';
import 'package:path_finder/features/route/presentation/widgets/build_dropdown.dart';
import 'package:path_finder/features/route/presentation/widgets/build_number_changer.dart';
import 'package:path_finder/features/route/presentation/widgets/build_range_slider.dart';
import 'package:path_finder/features/route/presentation/widgets/build_route_types.dart';
import 'package:path_finder/features/route/presentation/widgets/build_switch.dart';
import 'package:path_finder/features/user/presentation/widgets/custom_text_field.dart';

class Step1CreateRouteWidget extends StatefulWidget {
  const Step1CreateRouteWidget({super.key});

  @override
  State<Step1CreateRouteWidget> createState() => _Step1CreateRouteWidgetState();
}

class _Step1CreateRouteWidgetState extends State<Step1CreateRouteWidget> {
  late TextEditingController _nameRoute;
  late TextEditingController _descriptionRoute;
  late int _cantPersonas;
  late int _cantGuias;
  late double _rangoAlerta;
  late bool _mostrarInfoLugar;
  late bool _rutaPublica;
  late String _sonidoAlerta;
  late DateTime _initialDate;
  late List<RouteType> selectedRouteTypes;

  @override
  void initState() {
    super.initState();
    _nameRoute = TextEditingController();
    _descriptionRoute = TextEditingController();
    _cantPersonas = 1;
    _cantGuias = 1;
    _rangoAlerta = 1;
    _mostrarInfoLugar = false;
    _rutaPublica = false;
    _sonidoAlerta = 'Sonido 1';
    _initialDate = DateTime.now();
    selectedRouteTypes = [];
  }

  @override
  void dispose() {
    super.dispose();
    _nameRoute.dispose();
    _descriptionRoute.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CustomTextField(
              title: 'Nombre de la ruta',
              hintText: 'Ingrese el nombre de la ruta',
              textEditingController: _nameRoute,
              iconData: Icons.gps_fixed),
          const SizedBox(height: 16),
          CustomTextField(
              title: 'Descripción de la ruta',
              hintText: 'Ingrese la descripción de la ruta',
              textEditingController: _descriptionRoute,
              maxLines: 2,
              iconData: Icons.gps_fixed),
          const SizedBox(height: 16),
          BuildNumberChanger(
              title: 'Cantidad de personas',
              value: _cantPersonas,
              onTap: (value) {
                setState(() {
                  _cantPersonas = value;
                });
              }),
          const SizedBox(height: 16),
          BuildNumberChanger(
              title: 'Número de guías',
              value: _cantGuias,
              onTap: (value) {
                setState(() {
                  _cantGuias = value;
                });
              }),
          const SizedBox(height: 16),
          BuildRangeSlider(
              title: 'Rango de alerta',
              value: _rangoAlerta,
              onChanged: (value) {
                setState(() {
                  _rangoAlerta = value;
                });
              }),
          const SizedBox(height: 16),
          BuildSwitch(
              title: 'Mostrar información del lugar',
              value: _mostrarInfoLugar,
              onChanged: (value) {
                setState(() {
                  _mostrarInfoLugar = value;
                });
              }),
          const SizedBox(height: 16),
          BuildSwitch(
              title: 'Ruta pública',
              value: _rutaPublica,
              onChanged: (value) {
                setState(() {
                  _rutaPublica = value;
                });
              }),
          const SizedBox(height: 16),
          BuildDropdown(
              title: 'Sonido de alerta',
              value: _sonidoAlerta,
              onChanged: (value) {
                setState(() {
                  _sonidoAlerta = value;
                });
              }),
          const SizedBox(height: 16),
          BuildDatePicker(
              title: 'Fecha de la ruta',
              dateTime: _initialDate,
              onDateChanged: (value) {
                setState(() {
                  _initialDate = value;
                });
              }),
          const SizedBox(height: 16),
          BuildRouteTypes(
              title: 'Tipo de ruta',
              selectedRouteTypes: selectedRouteTypes,
              onRouteTypeSelect: (value) {
                setState(() {
                  if (selectedRouteTypes.contains(value)) {
                    selectedRouteTypes.remove(value);
                  } else {
                    selectedRouteTypes.add(value);
                  }
                });
              })
        ]));
  }
}








// class RouteStep1 extends StatefulWidget {
//   final String routeName;
//   final String routeDescription;
//   final DateTime routeDate;
//   final int numberOfPeople;
//   final int numberOfGuides;
//   final double rangeAlert;
//   final bool showPlaceInfo;
//   final String alertSound;
//   final bool publicRoute;
//   final List<RouteType> selectedRouteTypes; // Changed to a list of route types
//   final Function(String) onRouteNameChanged;
//   final Function(String) onRouteDescriptionChanged;
//   final Function(DateTime) onRouteDateChanged;
//   final Function(int) onNumberOfPeopleChanged;
//   final Function(int) onNumberOfGuidesChanged;
//   final Function(double) onRangeAlertChanged;
//   final Function(bool) onShowPlaceInfoChanged;
//   final Function(String) onAlertSoundChanged;
//   final Function(bool) onPublicRouteChanged;
//   final Function(List<RouteType>)
//       onRouteTypesChanged; // New callback for list of route types

//   const RouteStep1({
//     super.key,
//     required this.routeName,
//     required this.routeDescription,
//     required this.routeDate,
//     required this.numberOfPeople,
//     required this.numberOfGuides,
//     required this.rangeAlert,
//     required this.showPlaceInfo,
//     required this.alertSound,
//     required this.publicRoute,
//     required this.selectedRouteTypes, // New parameter
//     required this.onRouteNameChanged,
//     required this.onRouteDescriptionChanged,
//     required this.onRouteDateChanged,
//     required this.onNumberOfPeopleChanged,
//     required this.onNumberOfGuidesChanged,
//     required this.onRangeAlertChanged,
//     required this.onShowPlaceInfoChanged,
//     required this.onAlertSoundChanged,
//     required this.onPublicRouteChanged,
//     required this.onRouteTypesChanged, // New parameter
//   });

//   @override
//   _RouteStep1State createState() => _RouteStep1State();
// }

// class _RouteStep1State extends State<RouteStep1> {
//   late double currentRangeAlert;
//   late DateTime selectedDate;

//   // Define route types
//   final List<RouteType> routeTypes = RouteType.values;

//   @override
//   void initState() {
//     super.initState();
//     currentRangeAlert = widget.rangeAlert;
//     selectedDate = widget.routeDate;
//   }

//   void _handleNumberOfPeopleChange(int value) {
//     if (value < 1) {
//       showSnackbar(
//         context,
//         'Se alcanzó el número mínimo de personas',
//         "warning",
//       );
//       widget.onNumberOfPeopleChanged(1);
//     } else if (value > 30) {
//       showSnackbar(
//         context,
//         'Se alcanzó el número máximo de personas',
//         "warning",
//       );
//       widget.onNumberOfPeopleChanged(30);
//     } else {
//       widget.onNumberOfPeopleChanged(value);
//     }
//   }

//   void _handleNumberOfGuidesChange(int value) {
//     if (value < 1) {
//       showSnackbar(
//         context,
//         'Esta ruta no tendrá guías asignados',
//         "information",
//       );
//       widget.onNumberOfGuidesChanged(0);
//     } else if (value > 5) {
//       showSnackbar(context, 'Se alcanzó el número máximo de guías', "warning");
//       widget.onNumberOfGuidesChanged(5);
//     } else {
//       widget.onNumberOfGuidesChanged(value);
//     }
//   }

//   void _handleRouteTypeChanged(RouteType type, bool isSelected) {
//     setState(() {
//       if (isSelected) {
//         widget.selectedRouteTypes.add(type);
//       } else {
//         widget.selectedRouteTypes.remove(type);
//       }
//       widget.onRouteTypesChanged(widget.selectedRouteTypes);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 20),
//           buildRouteNameField(widget.routeName, widget.onRouteNameChanged),
//           const SizedBox(height: 15),
//           buildRouteDescriptionField(
//             widget.routeDescription,
//             widget.onRouteDescriptionChanged,
//           ),
//           const SizedBox(height: 15),
//           buildLabeledControl(
//             'Cantidad de personas',
//             buildNumberChanger(
//               widget.numberOfPeople,
//               _handleNumberOfPeopleChange,
//             ),
//           ),
//           buildLabeledControl(
//             'Número de guías',
//             buildNumberChanger(
//               widget.numberOfGuides,
//               _handleNumberOfGuidesChange,
//             ),
//           ),
//           const SizedBox(height: 15),
//           const Text('Rango de alerta', style: titlelabelTextStyle),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               Expanded(
//                 child: buildRangeSlider(currentRangeAlert, (value) {
//                   setState(() {
//                     currentRangeAlert = value;
//                   });
//                   widget.onRangeAlertChanged(value);
//                 }),
//               ),
//               const SizedBox(width: 8),
//               Text('${currentRangeAlert.round()} m', style: labelTextStyle),
//             ],
//           ),
//           const SizedBox(height: 15),
//           SwitchListTile(
//             contentPadding: EdgeInsets.zero,
//             title: const Text(
//               'Mostrar información del lugar',
//               style: titlelabelTextStyle,
//             ),
//             value: widget.showPlaceInfo,
//             onChanged: widget.onShowPlaceInfoChanged,
//             activeColor: const Color.fromRGBO(191, 141, 48, 1),
//           ),
//           const SizedBox(height: 15),
//           buildLabeledControl(
//             'Sonido de alerta',
//             buildDropdown(widget.alertSound, widget.onAlertSoundChanged),
//           ),
//           const SizedBox(height: 15),
//           SwitchListTile(
//             contentPadding: EdgeInsets.zero,
//             title: const Text(
//               'Ruta pública',
//               style: titlelabelTextStyle,
//             ),
//             value: widget.publicRoute,
//             onChanged: widget.onPublicRouteChanged,
//             activeColor: const Color.fromRGBO(191, 141, 48, 1),
//           ),
//           const SizedBox(height: 15),
//           const Text('Fecha de la ruta', style: titlelabelTextStyle),
//           const SizedBox(height: 8),
//           buildDatePicker(selectedDate, (date) {
//             setState(() {
//               selectedDate = date;
//             });
//             widget.onRouteDateChanged(date);
//           }),
//           const SizedBox(height: 15),
//           const Text('Tipo de ruta', style: titlelabelTextStyle),
//           const SizedBox(height: 8),
//           Wrap(
//             spacing: 8.0,
//             runSpacing: 4.0,
//             children: routeTypes.map((type) {
//               return ChoiceChip(
//                 label: Text(type.toString().split('.').last),
//                 selected: widget.selectedRouteTypes.contains(type),
//                 onSelected: (selected) {
//                   _handleRouteTypeChanged(type, selected);
//                 },
//                 selectedColor: const Color.fromRGBO(91, 125, 170, 1),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(50.0),
//                 ),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildDatePicker(
//     DateTime initialDate,
//     Function(DateTime) onDateChanged,
//   ) {
//     return TextButton(
//       onPressed: () async {
//         final DateTime? pickedDate = await showDatePicker(
//           context: context,
//           initialDate: initialDate,
//           firstDate: DateTime(2000),
//           lastDate: DateTime(2100),
//         );
//         if (pickedDate != null) {
//           onDateChanged(pickedDate);
//         }
//       },
//       child: Text(
//         '${initialDate.day}/${initialDate.month}/${initialDate.year}',
//         style: const TextStyle(fontSize: 16),
//       ),
//     );
//   }
// }