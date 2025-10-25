import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/api_controller.dart';

class HomeView extends StatelessWidget {
  final controller = Get.put(ApiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("HTTP vs Dio Performance")),
      body: Obx(() => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: controller.fetchWithHttp,
              child: const Text('Fetch with HTTP'),
            ),
            ElevatedButton(
              onPressed: controller.fetchWithDio,
              child: const Text('Fetch with Dio'),
            ),
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
