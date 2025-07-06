import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniride_driver/core/theme/color_paletter.dart';
import 'package:uniride_driver/core/theme/text_style_paletter.dart';
import 'package:uniride_driver/core/ui/custom_text_field.dart';
import 'package:uniride_driver/features/home/domain/entities/place_prediction.dart';

import '../bloc/carpool/create_carpool_bloc.dart';
import '../bloc/carpool/create_carpool_event.dart';
import '../bloc/carpool/create_carpool_state.dart';

class OriginLocationSelectionDialog extends StatefulWidget {
  const OriginLocationSelectionDialog({super.key});

  @override
  State<OriginLocationSelectionDialog> createState() => _OriginLocationSelectionDialogState();
}

class _OriginLocationSelectionDialogState extends State<OriginLocationSelectionDialog> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCarpoolBloc, CreateCarpoolState>(
      builder: (context, state) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            decoration: BoxDecoration(
              color: ColorPaletter.background,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Seleccionar origen',
                        style: TextStylePaletter.title,
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<CreateCarpoolBloc>()
                              .add(const CloseDialogToSelectOriginLocation());
                        },
                        icon: Icon(
                          Icons.close,
                          color: ColorPaletter.textPrimary,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: ColorPaletter.inputField,
                          shape: const CircleBorder(),
                        ),
                      ),
                    ],
                  ),
                ),

                // Search Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomTextField(
                    icon: Icon(Icons.search, color: ColorPaletter.textPrimary),
                    editingController: _searchController,
                    hintText: 'Buscar punto de partida',
                    onChanged: (value) {
                      context.read<CreateCarpoolBloc>()
                          .add(OriginLocationSearchChanged(value));
                    },
                  ),
                ),

                const SizedBox(height: 16.0),

                // Content
                Expanded(
                  child: _buildContent(context, state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, CreateCarpoolState state) {
    if (state.locationPredictions.isEmpty && _searchController.text.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64.0,
              color: ColorPaletter.textSecondary,
            ),
            const SizedBox(height: 16.0),
            Text(
              'No se encontraron resultados',
              style: TextStylePaletter.body,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (state.locationPredictions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              size: 64.0,
              color: ColorPaletter.textSecondary,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Escribe para buscar ubicaciones',
              style: TextStylePaletter.body,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: state.locationPredictions.length,
      separatorBuilder: (context, index) => Divider(
        color: ColorPaletter.inputField,
        height: 1.0,
      ),
      itemBuilder: (context, index) {
        final prediction = state.locationPredictions[index];
        return LocationPredictionListItem(
          prediction: prediction,
          onTap: () {
            context.read<CreateCarpoolBloc>()
                .add(OriginLocationSelected(prediction));
          },
        );
      },
    );
  }
}

class LocationPredictionListItem extends StatelessWidget {
  final Prediction prediction;
  final VoidCallback onTap;

  const LocationPredictionListItem({
    super.key,
    required this.prediction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            // Location Icon
            Container(
              decoration: BoxDecoration(
                color: ColorPaletter.inputField,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                Icons.location_on,
                color: ColorPaletter.textPrimary,
                size: 20.0,
              ),
            ),

            const SizedBox(width: 12.0),

            // Location Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Description
                  Text(
                    prediction.description,
                    style: TextStylePaletter.textOptions,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Arrow Icon
            Icon(
              Icons.chevron_right,
              color: ColorPaletter.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}