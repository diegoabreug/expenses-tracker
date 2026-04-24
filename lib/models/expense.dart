
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();
final formatter = DateFormat.yMd();

enum Category{
  food, travel, leisure, study,
}

class Expense{

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }): id = uuid.v4();


  // metodo para devolver una fecha formateada
  String get formattedDate{
    return formatter.format(date);
  }

  // metodo para devolver el nombre de la categoria
  String get categoryName{
    if(category == Category.food){
      return 'food';
    }
    if(category == Category.travel){
      return 'travel';
    }
    if(category == Category.leisure){
      return 'leisure';
    }
    return 'study';
  }


}







