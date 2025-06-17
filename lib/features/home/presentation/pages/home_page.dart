import 'package:flutter/material.dart';
import 'package:uniride_driver/core/theme/color_paletter.dart';
import 'package:uniride_driver/features/home/presentation/pages/create_carpool_page.dart';
import 'package:uniride_driver/features/home/presentation/pages/select_initial_position.dart';
import 'package:uniride_driver/features/home/presentation/widgets/map_view.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final SlidingUpPanelController panelController = SlidingUpPanelController();
  final ScrollController scrollController = ScrollController();

  final GlobalKey<NavigatorState> _panelNavigatorKey = GlobalKey<NavigatorState>();

  final List<Widget> _subPages =[
    CreateCarpoolPage(onTap: (){

    }),
    PositionSelectionPage()

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( 
        children: [
          const MapViewWidget(), // Mapa ocupa todo el fondo
          SlidingUpPanelWidget(
            controlHeight: 400.0, 
            anchor: 0.4, 
            panelController: panelController,
            enableOnTap: true,
            onTap: () {
              if (panelController.status == SlidingUpPanelStatus.expanded) {
                panelController.collapse();
              } else {
                panelController.expand();
              }
            },

            child: Container(
              decoration: BoxDecoration(
                color: ColorPaletter.background,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: PositionSelectionPage()
                  ),
                ),
              ),
            )
          ),
        ],
      ),
    );
  }
}