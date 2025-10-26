import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/api_controller.dart';
class HomeView extends StatelessWidget {
  HomeView({super.key});  // biar konsisten
  final controller = Get.put(ApiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("HTTP vs Dio Performance")),
      body: Obx(() => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(spacing: 8, runSpacing: 8, children: [
              ElevatedButton(
                onPressed: controller.fetchWithHttp,
                child: const Text('Fetch with HTTP'),
              ),
              ElevatedButton(
                onPressed: controller.fetchWithDio,
                child: const Text('Fetch with Dio'),
              ),
              ElevatedButton(
                onPressed: controller.fetchWithHttpBroken,
                child: const Text('HTTP Broken (error test)'),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final res = await controller.chainWithAsyncAwait();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('AsyncAwait OK • total: ${res['total']}'))
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('AsyncAwait Error: $e'))
                    );
                  }
                },
                child: const Text('Chain: async–await'),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.chainWithCallbacks((res) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Callback OK • total: ${res['total']}'))
                    );
                  }, (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Callback Error: $e'))
                    );
                  });
                },
                child: const Text('Chain: callback'),
              ),
            ]),
            const SizedBox(height: 16),
            Text('HTTP time: ${controller.httpTime.value}s'),
            Text('Dio time: ${controller.dioTime.value}s'),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: controller.coffees.length,
                itemBuilder: (_, i) {
                  final c = controller.coffees[i];
                  return ListTile(
                    title: Text(c.name),
                    subtitle: Text('Rp ${c.price}'),
                  );
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}
