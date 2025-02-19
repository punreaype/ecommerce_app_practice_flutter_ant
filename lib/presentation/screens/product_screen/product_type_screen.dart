import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:practice_7/model/product_model.dart';
import 'package:practice_7/presentation/screens/product_screen/product_screen_details.dart';
import 'package:practice_7/presentation/widgets/widgets.dart';
import 'package:practice_7/utils/extension.dart';

class ProductTypeScreen extends StatefulWidget {
  const ProductTypeScreen({super.key});

  @override
  State<ProductTypeScreen> createState() => _ProductTypeScreenState();
}

class _ProductTypeScreenState extends State<ProductTypeScreen> {
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as List;
    final filterProduct = arguments[0] as List<Map<String, dynamic>>;
    final titleType = arguments[1] as String;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        title: Text(titleType),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: CustomScrollView(
        slivers: [
          filterProduct.isEmpty
              ? SliverToBoxAdapter(
                  child: Container(
                    alignment: Alignment.center,
                    height: context.scrnHeight * .8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/lottie/Animation - 1734670774929.json',
                          height: 300,
                          fit: BoxFit.fitHeight,
                        ),
                        const Text(
                          'No Product',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverGrid.builder(
                  itemCount: filterProduct.isEmpty ? 0 : filterProduct.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: context.scrnWidth * .04,
                    mainAxisSpacing: context.scrnWidth * .05,
                    mainAxisExtent: context.scrnHeight * .3,
                  ),
                  itemBuilder: (context, index) {
                    var product = ProductModel.fromJson(filterProduct[index]);
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            settings: RouteSettings(
                              arguments: product,
                            ),
                            builder: (context) => const ProductDetailsScreen(),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Hero(
                                tag: product.name,
                                child: Image.network(
                                  height: context.scrnHeight * .2,
                                  product.images,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return const BuildPlaceHolder();
                                  },
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Column(
                                    children: [
                                      Icon(Icons.warning),
                                      Text('Product គ្មានរូប'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.scrnWidth * .02,
                              ),
                              child: Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.scrnWidth * .02,
                              ),
                              child: Text(
                                product.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.scrnWidth * .02,
                              ),
                              child: Text(
                                '\$${double.tryParse(product.price)?.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 15,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
