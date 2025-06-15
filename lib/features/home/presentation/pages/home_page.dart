import 'package:flutter/material.dart';
import 'package:uniride_driver/core/theme/color_paletter.dart';
import 'package:uniride_driver/features/home/presentation/view/map_view.dart';

import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final SlidingUpPanelController panelController = SlidingUpPanelController();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Expanded(child: MapViewWidget()),

         SlidingUpPanelWidget(
            controlHeight: 400.0, // Altura mínima (barra de agarre)
            anchor: 0.4, // Altura máxima cuando se expande
            panelController: panelController,
            enableOnTap: true,
            onTap: () {
              if (panelController.status == SlidingUpPanelStatus.expanded) {
                panelController.collapse();
              } else {
                panelController.expand();
              }
            },
            // Widget vacío con un pequeño indicador visual
            child: Container(
              decoration: BoxDecoration(
                color: ColorPaletter.background,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: ColorPaletter.error,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        

        
      ],
    );
  }
}