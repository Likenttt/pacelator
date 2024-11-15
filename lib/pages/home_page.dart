import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:macro_calculator/controllers/data_controller.dart';
import 'package:macro_calculator/controllers/theme_controller.dart';
import 'package:macro_calculator/pages/results_page.dart';
import 'package:macro_calculator/utils/enums.dart';
import 'package:macro_calculator/utils/helpers.dart';
import 'package:macro_calculator/utils/textStyles.dart';
import 'package:macro_calculator/data/calculator.dart';
import 'package:macro_calculator/widgets/my_drop_down_menu.dart';
import 'package:macro_calculator/widgets/slider.dart';
import 'package:macro_calculator/widgets/tile.dart';
import 'package:provider/provider.dart';
import 'package:macro_calculator/l10n/minimal_l10n.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var dataController = Provider.of<DataController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(MinimalLocalizations.of(context).title),
        actions: [
          IconButton(
            tooltip: isThemeDark(context)
                ? MinimalLocalizations.of(context).lightMode
                : MinimalLocalizations.of(context).darkMode,
            icon: Icon(
              isThemeDark(context) ? EvaIcons.sunOutline : EvaIcons.moonOutline,
            ),
            onPressed: () =>
                Provider.of<ThemeController>(context, listen: false)
                    .toggleTheme(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(6.0),
        children: [
          //! second container
          Tile(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  MinimalLocalizations.of(context).unit,
                  style: MyTextStyles(context).cardTitle,
                ),
                MyDropDownMenu<DistanceUnit>(
                  items: DistanceUnit.values
                      .where((u) => u != DistanceUnit.unknown)
                      .toList(),
                  value: dataController.unit!,
                  onChanged: (value) => dataController.setUnit(value),
                ),
                const SizedBox(height: 8),
                Text(
                  MinimalLocalizations.of(context).raceType,
                  style: MyTextStyles(context).cardTitle,
                ),
                MyDropDownMenu<RaceType>(
                  items: dataController.unit == DistanceUnit.metric
                      ? RaceType.metricTypes
                      : RaceType.statuteTypes,
                  value: dataController.raceType!,
                  onChanged: (value) => dataController.setRaceType(value),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      MinimalLocalizations.of(context).distance,
                      style: MyTextStyles(context).cardTitle,
                    ),
                    Row(
                      children: [
                        Text(
                          dataController.distanceFormatted()[0],
                          style: MyTextStyles(context).homeCardValue,
                        ),
                        Text(
                          dataController.distanceFormatted()[1],
                          style: MyTextStyles(context).homeCardText,
                        ),
                      ],
                    ),
                  ],
                ),
                MyCustomSlider(
                  value: dataController.distance!,
                  minValue: RaceType.t1000m.distance,
                  maxValue: RaceType.t100k.distance,
                  onChanged: (value) => dataController.setDistance(value),
                ),
              ],
            ),
          ),
          Tile(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTabController(
                    length: 2,
                    initialIndex: dataController.getTabInitialIndex(),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TabBar(
                            labelColor: const Color(0xff6750a4),
                            indicatorColor: const Color(0xff6750a4),
                            unselectedLabelColor: Colors.grey,
                            onTap: (value) => dataController.setTabMode(value),
                            tabs: [
                              Tab(
                                  text: MinimalLocalizations.of(context)
                                      .estimateFinishTime),
                              Tab(
                                  text:
                                      '${MinimalLocalizations.of(context).pace}(${MinimalLocalizations.of(context).getL10nByKey(dataController.unit!.unit3)})')
                            ],
                          ),
                          Container(
                              height: 240, //height of TabBarView
                              decoration: const BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Colors.grey, width: 0.5))),
                              child: TabBarView(children: <Widget>[
                                Container(
                                  child: showPicker(
                                    isInlinePicker: true,
                                    value: Time(
                                      hour: dataController
                                          .getFinishedHourMinuteTime()
                                          .hour,
                                      minute: dataController
                                          .getFinishedHourMinuteTime()
                                          .minute,
                                    ),
                                    onChange: (value) =>
                                        dataController.setFinishedTime(value),
                                    minuteInterval: TimePickerInterval.ONE,
                                    iosStylePicker: true,
                                    minHour: 0,
                                    displayHeader: false,
                                    isOnChangeValueMode: true,
                                    accentColor: const Color(0xff6750a4),
                                    maxHour: 23,
                                    hourLabel: MinimalLocalizations.of(context)
                                        .hourLabel,
                                    minuteLabel:
                                        MinimalLocalizations.of(context)
                                            .minuteLabel,
                                    is24HrFormat: true,
                                    focusMinutePicker: true,
                                    dialogInsetPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 0.0, vertical: 0.0),
                                    context: context,
                                  ),
                                ),
                                Container(
                                  child: showPicker(
                                    isInlinePicker: true,
                                    value: Time(
                                      hour: dataController
                                          .getPaceMinuteSecondTime()
                                          .hour,
                                      minute: dataController
                                          .getPaceMinuteSecondTime()
                                          .minute,
                                    ),
                                    onChange: (value) =>
                                        dataController.setPace(value),
                                    minuteInterval: TimePickerInterval
                                        .ONE, // Changed from MinuteInterval.ONE
                                    iosStylePicker: true,
                                    minHour: 0,
                                    blurredBackground: true,
                                    displayHeader: false,
                                    isOnChangeValueMode: true,
                                    accentColor: const Color(0xff6750a4),
                                    maxHour: 10,
                                    hourLabel: MinimalLocalizations.of(context)
                                        .minuteLabel,
                                    minuteLabel:
                                        MinimalLocalizations.of(context)
                                            .secondsLabel,
                                    is24HrFormat: true,
                                    focusMinutePicker: true,
                                    dialogInsetPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 0.0, vertical: 0.0),
                                    context: context,
                                  ),
                                ),
                              ]))
                        ]))
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        tooltip: MinimalLocalizations.of(context).calculate,
        heroTag: 'fab',
        icon: const Icon(Icons.calculate),
        label: Text(MinimalLocalizations.of(context).calculate),
        onPressed: () {
          Calculator calculator = Calculator(
            unit: dataController.unit!,
            raceType: dataController.raceType!,
            distance: dataController.distance!,
            tabMode: dataController.getTabMode(),
            pace: dataController.getPaceMinuteSecondTime(),
            etf: dataController.getFinishedHourMinuteTime(),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultPage(
                  distance: dataController.distanceFormatted(),
                  unit: calculator.unit,
                  raceType: calculator.raceType,
                  estimateTimeFinished: calculator.estimatedTimeFinished(true),
                  averagePace: calculator.averagePace(),
                  splits: calculator.splits()),
            ),
          );
        },
      ),
    );
  }
}
