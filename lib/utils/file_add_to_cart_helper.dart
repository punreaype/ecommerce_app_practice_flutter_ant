import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:practice_7/model/product_model.dart';

class AddToCart {
  AddToCart._();

  static Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/cart2.json');
  }

  static Future<List<Map<String, dynamic>>> _readRawData() async {
    final file = await _getFile();
    if (await file.exists()) {
      String content = await file.readAsString();
      content = content.trim(); // Remove extra spaces or trailing characters

      try {
        return jsonDecode(content).cast<Map<String, dynamic>>();
      } catch (e) {
        // print("Error parsing JSON: $e");
        return []; // Return empty list if JSON is corrupted
      }
    }
    return [];
  }

  static Future<List<ProductModel>> readModelsFromFile() async {
    final rawData = await _readRawData();

    return rawData.map((item) {
      ProductModel model = ProductModel.fromJson(item);
      model.selectedColor = item['selected_color'];
      model.quantity = item['quantity'];
      return model;
    }).toList();
  }

  static Future<void> addToCart(
      ProductModel newModel, String selectedColor, int qty) async {
    final rawData = await _readRawData();

    final existingIndex = rawData.indexWhere((item) =>
        item['name'] == newModel.name &&
        item['selected_color'] == selectedColor);

    // if  existing item is already in cart
    if (existingIndex != -1) {
      rawData[existingIndex]['quantity'] += qty;
    } else {
      rawData.add({
        'name': newModel.name,
        'description': newModel.description,
        'price': newModel.price,
        'api_featured_image': newModel.images,
        'tag_list': newModel.taglist,
        'product_type': newModel.producttype,
        'product_colors': newModel.productColors.map((color) {
          return {
            'hex_value': color.hexValue,
            'colour_name': color.colorName,
          };
        }).toList(),
        'selected_color': selectedColor,
        'quantity': qty,
      });
    }

    final file = await _getFile();
    await file.writeAsString(jsonEncode(rawData));
  }

  static Future<void> removeFromCart(
      ProductModel modelToRemove, String selectedColor) async {
    final rawData = await _readRawData();

    rawData.removeWhere((item) =>
        item['name'] == modelToRemove.name &&
        item['selected_color'] == selectedColor);

    final file = await _getFile();
    await file.writeAsString(jsonEncode(rawData));
  }

  static Future<int> countItemsInCart() async {
    List<ProductModel> models = await readModelsFromFile();
    return models.length;
  }

  static Future<void> updateQuantity(
      ProductModel model, String selectedColor, int newQty) async {
    final rawData = await _readRawData();

    final existingIndex = rawData.indexWhere((item) =>
        item['name'] == model.name && item['selected_color'] == selectedColor);

    if (existingIndex != -1) {
      rawData[existingIndex]['quantity'] = newQty;
    }

    final file = await _getFile();
    await file.writeAsString(jsonEncode(rawData));
  }
}
