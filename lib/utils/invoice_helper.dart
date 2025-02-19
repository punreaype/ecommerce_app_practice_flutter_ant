import 'package:practice_7/model/invoice_model.dart';
import 'package:practice_7/model/product_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class InvoiceHelper {
  static final InvoiceHelper _instance = InvoiceHelper._internal();
  static Database? _database;

  factory InvoiceHelper() {
    return _instance;
  }

  InvoiceHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'orders.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE invoices(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      invoiceID TEXT,
      address TEXT,
      contactNumber TEXT,
      paymentMethod TEXT,
      subtotal REAL,
      discount REAL,
      total REAL,
      timestamp TEXT,
      status TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE order_items(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      invoiceID TEXT,
      productName TEXT,
      productPrice REAL,
      quantity INTEGER,
      colorName TEXT,
      imageUrl TEXT,
      status TEXT
    )
  ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add the imageUrl column to the order_items table
      await db.execute('ALTER TABLE order_items ADD COLUMN imageUrl TEXT');
    }
    if (oldVersion < 3) {
      // Add the status column to the order_items table
      await db.execute('ALTER TABLE order_items ADD COLUMN status TEXT');
    }
  }

  // Save invoice to the database
  Future<void> insertInvoice(Invoice invoice) async {
    final db = await database;

    await db.insert(
      'invoices',
      invoice.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    for (var product in invoice.products) {
      await db.insert(
        'order_items',
        {
          'invoiceID': invoice.invoiceID,
          'productName': product.name,
          'productPrice': double.parse(product.price),
          'quantity': product.quantity,
          'colorName': product.productColors.isNotEmpty
              ? product.productColors[0].colorName
              : '',
          'imageUrl': product.images,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Fetch all invoices from the database
  Future<List<Invoice>> getInvoices() async {
    final db = await database;

    final List<Map<String, dynamic>> invoiceMaps = await db.query('invoices');
    final List<Invoice> invoices = [];

    for (var invoiceMap in invoiceMaps) {
      final List<Map<String, dynamic>> itemMaps = await db.query(
        'order_items',
        where: 'invoiceID = ?',
        whereArgs: [invoiceMap['invoiceID']],
      );

      final List<ProductModel> products = itemMaps.map((itemMap) {
        return ProductModel(
          name: itemMap['productName'],
          price: itemMap['productPrice'].toString(),
          producttype: '', // Add product type if needed
          images: itemMap['imageUrl'], // Retrieve image URL
          description: '', // Add description if needed
          productColors: [
            ProductColor(
              hexValue: '', // Add hex value if needed
              colorName: itemMap['colorName'],
            ),
          ],
          taglist: [], // Add tag list if needed
          selectedColor: '', // Add selected color if needed
          quantity: itemMap['quantity'],
        );
      }).toList();

      invoices.add(Invoice(
        invoiceID: invoiceMap['invoiceID'],
        address: invoiceMap['address'],
        contactNumber: invoiceMap['contactNumber'],
        paymentMethod: invoiceMap['paymentMethod'],
        products: products,
        subtotal: invoiceMap['subtotal'],
        discount: invoiceMap['discount'],
        total: invoiceMap['total'],
        timestamp: DateTime.parse(invoiceMap['timestamp']),
        status: invoiceMap['status'], // Retrieve status
      ));
    }

    return invoices;
  }

  Future<void> updateInvoiceStatus(String invoiceID, String status) async {
    final db = await database;
    await db.update(
      'invoices',
      {'status': status},
      where: 'invoiceID = ?',
      whereArgs: [invoiceID],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
