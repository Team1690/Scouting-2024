import "package:scouting_frontend/models/team_data/technical_data.dart";

class CalculatedTechnicalData<T extends num> implements TechnicalData<T> {
  CalculatedTechnicalData({
    required this.calculateFieldAggregateData,
    required this.technicalDatas,
  });

  final T Function(List<TechnicalData<int>>, int Function(TechnicalData<int>))
      calculateFieldAggregateData;
  final List<TechnicalData<int>> technicalDatas;

  @override
  T get ampGamepieces => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.ampGamepieces,
      );

  @override
  T get ampPoints => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.ampPoints,
      );

  @override
  T get autoAmp => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.autoAmp,
      );

  @override
  T get autoAmpMissed => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.autoAmpMissed,
      );

  @override
  T get autoAmpPoints => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.autoAmpPoints,
      );

  @override
  T get autoGamepieces => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.autoGamepieces,
      );

  @override
  T get autoPoints => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.autoPoints,
      );

  @override
  T get autoSpeaker => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.autoSpeaker,
      );

  @override
  T get autoSpeakerMissed => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.autoSpeakerMissed,
      );

  @override
  T get autoSpeakerPoints => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.autoSpeakerPoints,
      );

  @override
  T get gamePiecesPoints => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.gamePiecesPoints,
      );

  @override
  T get gamepieces => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.gamepieces,
      );

  @override
  T get speakerGamepieces => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.speakerGamepieces,
      );

  @override
  T get speakerPoints => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.speakerPoints,
      );

  @override
  T get teleAmp => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.teleAmp,
      );

  @override
  T get teleAmpMissed => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.teleAmpMissed,
      );

  @override
  T get teleAmpPoints => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.teleAmpPoints,
      );

  @override
  T get teleGamepieces => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.teleGamepieces,
      );

  @override
  T get telePoints => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.telePoints,
      );

  @override
  T get teleSpeaker => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.teleSpeaker,
      );

  @override
  T get teleSpeakerMissed => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.teleSpeakerMissed,
      );

  @override
  T get teleSpeakerPoints => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.teleSpeakerPoints,
      );

  @override
  T get totalMissed => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.totalMissed,
      );

  @override
  T get trapAmount => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.trapAmount,
      );

  @override
  T get trapsMissed => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.trapsMissed,
      );

  T caclulateOnListOfField(
    final int Function(int, int) combine,
    final List<int> Function(TechnicalData<int>) getFields,
  ) =>
      calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> technicalData) =>
            getFields(technicalData).reduce(combine),
      );
}
