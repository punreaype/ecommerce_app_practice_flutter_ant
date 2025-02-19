class ProductModel {
  late String name;
  late String price;
  late String producttype;
  late String images;
  late String description;
  late List<ProductColor> productColors;
  late List<String> taglist;
  late String selectedColor;
  late int quantity;

  ProductModel({
    required this.name,
    required this.price,
    required this.producttype,
    required this.images,
    required this.description,
    required this.productColors,
    required this.taglist,
    required this.selectedColor,
    required this.quantity,
  });

  ProductModel.fromJson(Map<String, dynamic> items) {
    name = items['name'] ?? '';
    price = items['price'] ?? '';
    images = (items['api_featured_image']?.startsWith("http") ?? false)
        ? items['api_featured_image']
        : "https:${items['api_featured_image'] ?? ''}";
    description = items['description'] ?? 'No description';
    taglist = (items['tag_list'] as List).map((e) => e.toString()).toList();
    producttype = items['product_type'] ?? '';
    productColors = (items['product_colors'] as List)
        .map((e) => ProductColor.fromJson(e))
        .toList();
    selectedColor = items['selected_color'] ?? '';
    quantity = items['quantity'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'product_type': producttype,
      'api_featured_image': images.replaceFirst('https:', ''),
      'description': description,
      'tag_list': taglist,
      'product_colors': productColors.map((e) => e.toJson()).toList(),
    };
  }
}

class ProductColor {
  late String hexValue;
  late String colorName;

  ProductColor({
    required this.hexValue,
    required this.colorName,
  });

  ProductColor.fromJson(Map<String, dynamic> json) {
    hexValue = json['hex_value'] ?? "";
    colorName = json['colour_name'] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      'hex_value': hexValue,
      'colour_name': colorName,
    };
  }
}
