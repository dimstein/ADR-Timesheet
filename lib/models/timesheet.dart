class Timesheet{
   final int? id;
   final String? date;
   final int? hours;
   final int? minutes;

  Timesheet({this.id, this.date, this.hours, this.minutes});

  Map<String, dynamic> toMap(){
    return {
      '_id': id,
      'date': date,
      'hours': hours,
      'minutes': minutes
    };
  }
}