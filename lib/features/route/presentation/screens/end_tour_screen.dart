
import 'package:flutter/material.dart';
import 'package:path_finder/core/theme/app_theme.dart';
import 'package:path_finder/core/widgets/custom_button_widget.dart';
import 'package:path_finder/features/route/presentation/screens/home.dart';

class EndTourScreen extends StatefulWidget {
  const EndTourScreen ({super.key});

  @override
  State<EndTourScreen> createState() => _EndTourScreenState();
}

class _EndTourScreenState extends State<EndTourScreen> {

  @override
  void initState() {
    super.initState();
  }

    @override
  Widget build(BuildContext context) {
    return PopScope( canPop: false ,child:Scaffold(
      appBar: AppBar(
            titleSpacing: 10,
            backgroundColor: colorSeed,
            scrolledUnderElevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: false,
            title: Text("Esperando",
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
        children:[
          Container(alignment: Alignment.center, child: Text("Llegaste al fin de la ruta" ,style: Theme.of(context).textTheme.bodyLarge,),), 
          SizedBox(height: 20),
          CustomButtonWidget(onTap: ()=> {
          Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => HomeScreen(),
      ))}, color: colorSeed, label: "Ir al menú principal")])
          
    )));
  }
}