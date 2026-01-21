import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Solicitar Serviço")),
      body: Column(
        children: [
          _buildStepper(),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("Qual serviço você precisa?", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _card(Icons.water_drop_outlined, "Vazamentos"),
                _card(Icons.flash_on_outlined, "Elétrica"),
                _card(Icons.chair_outlined, "Montagem"),
                _card(Icons.format_paint_outlined, "Pintura"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 12, backgroundColor: Colors.green, child: Text("1", style: TextStyle(color: Colors.white, fontSize: 12))),
          SizedBox(width: 8),
          Text("Serviço", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          SizedBox(width: 20),
          CircleAvatar(radius: 12, backgroundColor: Color(0xFFE0E0E0), child: Text("2", style: TextStyle(color: Colors.grey, fontSize: 12))),
        ],
      ),
    );
  }

  Widget _card(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 40, color: Colors.blueGrey), const SizedBox(height: 12), Text(label)]),
    );
  }
}