import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:practice_7/model/product_model.dart';

class FileWhistlistHelper {
  FileWhistlistHelper._();

  static Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/wishlist5.json');
  }

  static Future<List<ProductModel>> readModelsFromFile() async {
    final file = await _getFile();

    if (await file.exists()) {
      String content = await file.readAsString();
      if (content.isNotEmpty) {
        List<dynamic> jsonData = jsonDecode(content);
        return jsonData.map((item) => ProductModel.fromJson(item)).toList();
      }
    }

    return [];
  }

  static Future<void> addModelToFile(ProductModel newModel) async {
    List<ProductModel> models = await readModelsFromFile(); //read existing data
    models.add(newModel); //add new data
    List<Map<String, dynamic>> jsonData = models.map((data) {
      return {
        'name': data.name,
        'description': data.description,
        'price': data.price,
        'api_featured_image': data.images,
        'tag_list': data.taglist,
        'product_type': data.producttype,
        'product_colors': data.productColors.map((color) {
          return {
            'hex_value': color.hexValue,
            'colour_name': color.colorName,
          };
        }).toList(),
      };
    }).toList();
    final file = await _getFile();
    await file.writeAsString(jsonEncode(jsonData));
  }

  static Future<void> removeModelFromFile(ProductModel modelToRemove) async {
    List<ProductModel> models = await readModelsFromFile();
    models.removeWhere((model) => model.name == modelToRemove.name);
    List<Map<String, dynamic>> jsonData = models.map((model) {
      return {
        'name': model.name,
        'price': model.price,
        'tag_list': model.taglist,
        'description': model.description,
        'api_featured_image': model.images,
        'product_type': model.producttype,
        'product_colors': model.productColors.map((color) {
          return {
            'hex_value': color.hexValue,
            'colour_name': color.colorName,
          };
        }).toList(),
      };
    }).toList();

    final file = await _getFile();
    await file.writeAsString(jsonEncode(jsonData));
  }
}
