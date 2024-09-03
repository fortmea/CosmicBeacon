enum MeasurementUnits { miles, kilometers, astronomical, lunar }

class AsteroidData {
  final String id;
  final String name;
  final double absoluteMagnitude;
  final bool isPotentiallyHazardous;
  final List<CloseApproachData> closeApproachDataList;
  final Map<String, double> estimatedDiameterKm;

  AsteroidData({
    required this.id,
    required this.name,
    required this.absoluteMagnitude,
    required this.isPotentiallyHazardous,
    required this.closeApproachDataList,
    required this.estimatedDiameterKm,
  });

  factory AsteroidData.fromJson(Map<String, dynamic> json) {
    List<CloseApproachData> closeApproachDataList =
        List<CloseApproachData>.from(
      json['close_approach_data'].map(
        (data) => CloseApproachData.fromJson(data),
      ),
    );

    return AsteroidData(
      id: json['id'],
      name: json['name'],
      absoluteMagnitude: json['absolute_magnitude_h'] ?? 0.0,
      isPotentiallyHazardous:
          json['is_potentially_hazardous_asteroid'] ?? false,
      closeApproachDataList: closeApproachDataList,
      estimatedDiameterKm: {
        'min': double.parse(json['estimated_diameter']['kilometers']
                ['estimated_diameter_min']
            .toString()),
        'max': double.parse(json['estimated_diameter']['kilometers']
                ['estimated_diameter_max']
            .toString()),
      },
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'absolute_magnitude_h': absoluteMagnitude,
      'is_potentially_hazardous_asteroid': isPotentiallyHazardous,
      'close_approach_data':
          closeApproachDataList.map((data) => data.toJson()).toList(),
      'estimated_diameter': {
        'kilometers': {
          'estimated_diameter_min': estimatedDiameterKm['min'],
          'estimated_diameter_max': estimatedDiameterKm['max'],
        },
      },
    };
  }
}

List<AsteroidData> filterByDateApproximateDateAndTime(
    DateTime dateTime, List<AsteroidData> data) {
  final formattedDate =
      '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  int parseMonth(String month) {
    switch (month) {
      case 'Jan':
        return DateTime.january;
      case 'Feb':
        return DateTime.february;
      case 'Mar':
        return DateTime.march;
      case 'Apr':
        return DateTime.april;
      case 'May':
        return DateTime.may;
      case 'Jun':
        return DateTime.june;
      case 'Jul':
        return DateTime.july;
      case 'Aug':
        return DateTime.august;
      case 'Sep':
        return DateTime.september;
      case 'Oct':
        return DateTime.october;
      case 'Nov':
        return DateTime.november;
      case 'Dec':
        return DateTime.december;
      default:
        throw FormatException('Invalid month: $month');
    }
  }

  DateTime parseCustomDate(String dateString) {
    final parts = dateString.split(' ');
    final dateParts = parts[0].split('-');
    final timeParts = parts[1].split(':');
    final year = int.parse(dateParts[0]);
    final month = parseMonth(dateParts[1]);
    final day = int.parse(dateParts[2]);
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    return DateTime(year, month, day, hour, minute);
  }

  for (int i = 0; i < 12; i++) {
    var ndata = data.where((element) {
      final elementDate =
          element.closeApproachDataList[0].closeApproachDateFull;
      final elementDateTime = parseCustomDate(elementDate);
      return elementDateTime.isAfter(
              DateTime.parse(formattedDate).subtract(Duration(hours: i))) &&
          elementDateTime.isBefore(
              DateTime.parse(formattedDate).add(Duration(hours: i))) &&
          element.closeApproachDataList.any(
              (closeApproachData) => closeApproachData.orbitingBody == "Earth");
    }).toList();
    if (ndata.isNotEmpty) {
      return ndata;
    }
  }
  return [];
}

class CloseApproachData {
  String closeApproachDate;
  String closeApproachDateFull;
  int epochDateCloseApproach;
  RelativeVelocity relativeVelocity;
  MissDistance missDistance;
  String orbitingBody;

  CloseApproachData({
    required this.closeApproachDate,
    required this.closeApproachDateFull,
    required this.epochDateCloseApproach,
    required this.relativeVelocity,
    required this.missDistance,
    required this.orbitingBody,
  });

  factory CloseApproachData.fromJson(Map<String, dynamic> json) {
    return CloseApproachData(
      closeApproachDate: json['close_approach_date'],
      closeApproachDateFull: json['close_approach_date_full'],
      epochDateCloseApproach: json['epoch_date_close_approach'],
      relativeVelocity: RelativeVelocity.fromJson(json['relative_velocity']),
      missDistance: MissDistance.fromJson(json['miss_distance']),
      orbitingBody: json['orbiting_body'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'close_approach_date': closeApproachDate,
      'close_approach_date_full': closeApproachDateFull,
      'epoch_date_close_approach': epochDateCloseApproach,
      'relative_velocity': relativeVelocity.toJson(),
      'miss_distance': missDistance.toJson(),
      'orbiting_body': orbitingBody,
    };
  }
}

class RelativeVelocity {
  String kilometersPerSecond;
  String kilometersPerHour;
  String milesPerHour;

  RelativeVelocity({
    required this.kilometersPerSecond,
    required this.kilometersPerHour,
    required this.milesPerHour,
  });

  factory RelativeVelocity.fromJson(Map<String, dynamic> json) {
    return RelativeVelocity(
      kilometersPerSecond: json['kilometers_per_second'],
      kilometersPerHour: json['kilometers_per_hour'],
      milesPerHour: json['miles_per_hour'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kilometers_per_second': kilometersPerSecond,
      'kilometers_per_hour': kilometersPerHour,
      'miles_per_hour': milesPerHour,
    };
  }
}

class MissDistance {
  String astronomical;
  String lunar;
  String kilometers;
  String miles;

  MissDistance({
    required this.astronomical,
    required this.lunar,
    required this.kilometers,
    required this.miles,
  });

  factory MissDistance.fromJson(Map<String, dynamic> json) {
    return MissDistance(
      astronomical: json['astronomical'],
      lunar: json['lunar'],
      kilometers: json['kilometers'],
      miles: json['miles'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'astronomical': astronomical,
      'lunar': lunar,
      'kilometers': kilometers,
      'miles': miles,
    };
  }
}
