import 'package:bike/controllers/map_controller.dart';
import 'package:bike/screens/models.dart';
import 'package:bike/widgets/button.dart';
import 'package:bike/widgets/textfield.dart';
import 'package:bike/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({
    super.key,
    required this.showSearchBox,
    required TextEditingController stationNameController,
    required this.controller,
  }) : _stationNameController = stationNameController;

  final RxBool showSearchBox;
  final TextEditingController _stationNameController;
  final MapControllerX controller;

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  // فیلترهای انتخاب‌شده
  final RxSet<String> activeFilters = <String>{}.obs;

  final filters = const ["دوچرخه", "دوچرخه برقی", "اسکوتر", "پارکینگ هوشمند"];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // هدر باکس
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          LucideIcons.circle_x,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          widget.showSearchBox.value = false;
                        },
                      ),
                      Text(
                        'نام ایستگاه مورد نظر خود را وارد کنید',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // فیلد سرچ
                  MyTextFeild(
                    controller: widget._stationNameController,
                    labelText: 'نام ایستگاه',
                    suffoxIcon: const Icon(Icons.directions_bike),
                    onChanged: (value) {
                      widget.controller.stations.refresh();
                    },
                  ),

                  const SizedBox(height: 15),

                  // دکمه‌های فیلتر
                  // دکمه‌های فیلتر افقی
                  Obx(
                    () => SizedBox(
                      height: 40,
                      child: Directionality(
                        textDirection: TextDirection.rtl, // راست‌چین

                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: filters.map((f) {
                              final isSelected = activeFilters.contains(f);
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: FilterChip(
                                  label: Text(
                                    f,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withValues(alpha: 0.6),
                                    ),
                                  ),

                                  selected: isSelected,
                                  selectedColor: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.2),
                                  checkmarkColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: isSelected
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withValues(alpha: 0.2),
                                    ),
                                  ),
                                  onSelected: (val) {
                                    if (val) {
                                      activeFilters.add(f);
                                    } else {
                                      activeFilters.remove(f);
                                    }
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // لیست ایستگاه‌ها
                  SizedBox(
                    height: 350,
                    child: Obx(() {
                      final query = widget._stationNameController.text.trim();

                      var filtered = widget.controller.stations.where((s) {
                        if (query.isEmpty) return true;
                        return s.name.contains(query);
                      }).toList();

                      // فیلتر بر اساس نوع
                      if (activeFilters.isNotEmpty) {
                        filtered = filtered.where((s) {
                          if (activeFilters.contains("دوچرخه") &&
                              s.type == StationType.bike) {
                            return true;
                          }
                          if (activeFilters.contains("دوچرخه برقی") &&
                              s.type == StationType.eBike) {
                            return true;
                          }
                          if (activeFilters.contains("اسکوتر") &&
                              s.type == StationType.scooter) {
                            return true;
                          }
                          if (activeFilters.contains("پارکینگ هوشمند") &&
                              s.type == StationType.smartParking) {
                            return true;
                          }
                          return false;
                        }).toList();
                      }

                      return ListView.builder(
                        itemCount: filtered.length,
                        itemExtent: 210,
                        addAutomaticKeepAlives: false,
                        itemBuilder: (context, index) {
                          final s = filtered[index];

                          return GestureDetector(
                            onTap: () {
                              widget.controller.onMarkerTap(context, s);
                            },
                            child: Card(
                              elevation: 0,
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 6,
                              ),

                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.primary
                                        .withValues(alpha: 0.4),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Directionality(
                                    textDirection:
                                        TextDirection.rtl, // راست‌چین
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // عنوان + آیکون
                                        Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.asset(
                                                s.iconAsset,
                                                width: 45,
                                                height: 45,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                s.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            const Icon(
                                              Icons.arrow_back_ios_new,
                                              size: 16,
                                            ),
                                          ],
                                        ),
                                        const Divider(height: 20, thickness: 1),

                                        // اطلاعات ایستگاه
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.pedal_bike,
                                              size: 18,
                                              color: Colors.green,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              "دوچرخه قابل ارائه: ${s.availableBikes}",
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.local_parking,
                                              size: 18,
                                              color: Colors.blue,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              "جای پارک: ${s.availableParking}",
                                            ),
                                          ],
                                        ),
                                        // ignore: unnecessary_null_comparison
                                        if (s.distanceKm != null) ...[
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.place,
                                                size: 18,
                                                color: Colors.redAccent,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                "فاصله از شما: ${s.distanceKm.toStringAsFixed(2)} km",
                                              ),
                                            ],
                                          ),
                                        ],
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.type_specimen,
                                              size: 18,
                                              color: Colors.deepPurpleAccent,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              "نوع ایستگاه: ${_mapStationType(s.type)}",
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),

                  const SizedBox(height: 12),

                  // دکمه‌ها
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: MyButton(
                            buttonText: 'جستجو',
                            onTap: () {
                              final name = widget._stationNameController.text
                                  .trim();
                              if (name.isEmpty) return;

                              final station = widget.controller.stations
                                  .firstWhereOrNull(
                                    (s) => s.name.contains(name),
                                  );

                              if (station != null) {
                                widget.controller.onMarkerTap(context, station);
                              } else {
                                showErrorToast(
                                  description: "ایستگاهی با این نام پیدا نشد",
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: MyButton(
                            isFocus: false,
                            buttonText: 'برگشت',
                            onTap: () {
                              widget.showSearchBox.value = false;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _mapStationType(StationType type) {
  switch (type) {
    case StationType.bike:
      return "دوچرخه";
    case StationType.eBike:
      return "دوچرخه برقی";
    case StationType.scooter:
      return "اسکوتر";
    case StationType.smartParking:
      return "پارکینگ هوشمند";
  }
}
