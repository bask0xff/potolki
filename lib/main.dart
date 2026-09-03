import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() {
  runApp(const CeilingApp());
}

class CeilingApp extends StatelessWidget {
  const CeilingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ПотолокПро',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

// Позиция из чек-боксов
class EstimateItem {
  final String title;
  final String group;
  final double costPrice;   // Закупочная цена
  final double clientPrice; // Цена для клиента
  int quantity;

  EstimateItem({
    required this.title,
    required this.group,
    required this.costPrice,
    required this.clientPrice,
    this.quantity = 0,
  });
}

// Личные расходы (для расчета чистой прибыли)
class ExpenseItem {
  final String title;
  double amount;

  ExpenseItem({required this.title, required this.amount});
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Данные клиента
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  // Чек-боксы по группам из ТЗ
  final List<EstimateItem> _items = [
    // Профиль
    EstimateItem(group: 'Профиль', title: 'Алюминий несверленый (м.п.)', costPrice: 120, clientPrice: 250),
    EstimateItem(group: 'Профиль', title: 'Алюминий сверленый (м.п.)', costPrice: 140, clientPrice: 280),
    EstimateItem(group: 'Профиль', title: 'Пластиковый профиль (м.п.)', costPrice: 60, clientPrice: 150),
    EstimateItem(group: 'Профиль', title: 'Профиль БП-40 (м.п.)', costPrice: 210, clientPrice: 450),
    EstimateItem(group: 'Профиль', title: 'Профиль FLY-02 (парящий)', costPrice: 350, clientPrice: 750),
    EstimateItem(group: 'Профиль', title: 'Профиль ПК14 (карниз)', costPrice: 600, clientPrice: 1200),

    // Полотно
    EstimateItem(group: 'Полотно', title: 'ПВХ Bauf Германия (кв.м)', costPrice: 220, clientPrice: 550),
    EstimateItem(group: 'Полотно', title: 'ПВХ MSD Premium (кв.м)', costPrice: 160, clientPrice: 400),
    EstimateItem(group: 'Полотно', title: 'Ткань Clipso / Descor (кв.м)', costPrice: 850, clientPrice: 1800),

    // Расходники и крепёж
    EstimateItem(group: 'Крепёж & Вставка', title: 'Вставка по периметру (м.п.)', costPrice: 25, clientPrice: 90),
    EstimateItem(group: 'Крепёж & Вставка', title: 'Саморезы + дюбели (комплект)', costPrice: 15, clientPrice: 50),

    // Элементы
    EstimateItem(group: 'Доп. работы', title: 'Обвод трубы (Ф23/Ф27/Ф32)', costPrice: 40, clientPrice: 300),
    EstimateItem(group: 'Доп. работы', title: 'Светильник (монтаж + кольцо)', costPrice: 100, clientPrice: 400),
    EstimateItem(group: 'Доп. работы', title: 'Универсальная платформа под люстру', costPrice: 150, clientPrice: 600),
    EstimateItem(group: 'Доп. работы', title: 'Внешний угол (доп. сложность)', costPrice: 0, clientPrice: 300),
    EstimateItem(group: 'Доп. работы', title: 'Высота потолка > 2.7 м', costPrice: 0, clientPrice: 500),
  ];

  // Личные расходы потолочника
  final List<ExpenseItem> _expenses = [
    ExpenseItem(title: 'Бензин на дорогу', amount: 500),
    ExpenseItem(title: 'Газ / Патроны для пистолета', amount: 300),
    ExpenseItem(title: 'Расходники (перчатки, буры)', amount: 200),
  ];

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildClientTab(),
      _buildEstimateTab(),
      _buildExpensesTab(),
      _buildSummaryTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ПотолокПро — Смета & Замер'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Клиент'),
          BottomNavigationBarItem(icon: Icon(Icons.check_box), label: 'Чек-боксы'),
          BottomNavigationBarItem(icon: Icon(Icons.build_circle), label: 'Мои расходы'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Итого & PDF'),
        ],
      ),
    );
  }

  // 1. ВКЛАДКА «КЛИЕНТ»
  Widget _buildClientTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Информация об объекте', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Имя клиента', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Телефон', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(controller: _addressController, decoration: const InputDecoration(labelText: 'Адрес, этаж, домофон', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Примечания (собака, не курить в подъезде и т.д.)',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  // 2. ВКЛАДКА «ЧЕК-БОКСЫ»
  Widget _buildEstimateTab() {
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        final showHeader = index == 0 || _items[index - 1].group != item.group;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  item.group,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                ),
              ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: ListTile(
                title: Text(item.title),
                subtitle: Text('Клиент: ${item.clientPrice.toInt()} ₽ | Закуп: ${item.costPrice.toInt()} ₽'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        if (item.quantity > 0) setState(() => item.quantity--);
                      },
                    ),
                    Text('${item.quantity}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: Colors.deepOrange),
                      onPressed: () => setState(() => item.quantity++),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // 3. ВКЛАДКА «МОИ РАСХОДЫ»
  Widget _buildExpensesTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text('Расходы, которые НЕ видны клиенту, но снижают чистую прибыль:', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                final exp = _expenses[index];
                return Card(
                  child: ListTile(
                    title: Text(exp.title),
                    trailing: SizedBox(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(suffixText: '₽'),
                        controller: TextEditingController(text: '${exp.amount.toInt()}'),
                        onChanged: (val) => exp.amount = double.tryParse(val) ?? 0,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 4. ВКЛАДКА «ИТОГО & PDF»
  Widget _buildSummaryTab() {
    double clientTotal = 0;
    double costTotal = 0;

    for (var item in _items) {
      clientTotal += item.clientPrice * item.quantity;
      costTotal += item.costPrice * item.quantity;
    }

    double myExpenses = _expenses.fold(0, (sum, e) => sum + e.amount);
    double netProfit = clientTotal - costTotal - myExpenses;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: Colors.deepOrange.shade50,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _row('ИТОГО ДЛЯ КЛИЕНТА:', '${clientTotal.toInt()} ₽', isBold: true, fontSize: 18),
                  const Divider(),
                  _row('Закупка материалов:', '${costTotal.toInt()} ₽'),
                  _row('Личные расходы (газ, бензин):', '${myExpenses.toInt()} ₽'),
                  const Divider(),
                  _row('ТВОЯ ЧИСТАЯ ПРИБЫЛЬ:', '${netProfit.toInt()} ₽', isBold: true, fontSize: 18, color: Colors.green.shade800),
                ],
              ),
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
            label: const Text('Сформировать и отправить PDF', style: TextStyle(color: Colors.white, fontSize: 16)),
            onPressed: () => _generatePdf(clientTotal),
          ),
        ],
      ),
    );
  }

  Widget _row(String title, String value, {bool isBold = false, double fontSize = 14, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: fontSize)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: fontSize, color: color)),
        ],
      ),
    );
  }

  // Генерация сметы в PDF
  Future<void> _generatePdf(double clientTotal) async {
    final pdf = pw.Document();

    final selectedItems = _items.where((i) => i.quantity > 0).toList();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('SMETA NA MONTAZH POTOLKA', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Zakazchik: ${_nameController.text}'),
              pw.Text('Telefon: ${_phoneController.text}'),
              pw.Text('Adres: ${_addressController.text}'),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headers: ['Naimenovanie', 'Kol-vo', 'Cena (rub)'],
                data: selectedItems.map((item) => [
                  item.title,
                  '${item.quantity}',
                  '${(item.clientPrice * item.quantity).toInt()}'
                ]).toList(),
              ),
              pw.Divider(),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text('ITOGO K OPLATE: ${clientTotal.toInt()} rub.', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}