
import 'package:flutter/material.dart';
import 'package:path_finder/core/theme/app_theme.dart';
import 'package:path_finder/core/widgets/custom_button_widget.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen ({super.key});

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {

  @override
  void initState() {
    super.initState();
  }

    @override
  Widget build(BuildContext context) {
    return PopScope(canPop: false, child: Scaffold (
      appBar: AppBar(
            titleSpacing: 10,
            backgroundColor: colorSeed,
            scrolledUnderElevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: false,
            title: Text("En espera",
                maxLines: 2,
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.white)),
            ),
      body: Padding(padding: const EdgeInsets.all(16),
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(alignment: Alignment.center ,child: Text("Estás en una parada" ,style: Theme.of(context).textTheme.bodyLarge,) ), 
                        SizedBox(height: 20),
                        CustomButtonWidget(onTap: ()=> Navigator.pop(context), color: colorSeed, label: "Ir a la siguiente parada")],))
          
    ));
  }
}