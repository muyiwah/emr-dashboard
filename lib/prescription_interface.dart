import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Medication {
  final int id;
  final String name;
  final String genericName;
  final List<String> brandNames;
  final String category;
  final String dosage;
  final List<String> forms;
  final String description;
  final String dosageInfo;
  final String route;
  final int stockQuantity;
  final String expiryDate;
  final String manufacturer;
  final double price;
  final List<String> sideEffects;
  final List<String> contraindications;
  final List<String> interactions;
  final String storageConditions;

  Medication({
    required this.id,
    required this.name,
    required this.genericName,
    required this.brandNames,
    required this.category,
    required this.dosage,
    required this.forms,
    required this.description,
    required this.dosageInfo,
    required this.route,
    required this.stockQuantity,
    required this.expiryDate,
    required this.manufacturer,
    required this.price,
    required this.sideEffects,
    required this.contraindications,
    required this.interactions,
    required this.storageConditions,
  });
}

class CartItem {
  final Medication medication;
  int quantity;
  String instructions;
  DateTime dispensedAt;

  CartItem({
    required this.medication,
    this.quantity = 1,
    this.instructions = '',
    required this.dispensedAt,
  });
}

class PharmacyManagementSystem extends StatefulWidget {
  @override
  _PharmacyManagementSystemState createState() =>
      _PharmacyManagementSystemState();
}

class _PharmacyManagementSystemState extends State<PharmacyManagementSystem> {
  final List<Medication> MEDICATION_DATABASE = [
    Medication(
      id: 11,
      name: 'Amoxicillin',
      genericName: 'Amoxicillin',
      brandNames: ['Amoxil', 'Trimox'],
      category: 'Antibiotics',
      dosage: '500mg',
      forms: ['Capsule', 'Tablet', 'Suspension'],
      description: 'Beta-lactam antibiotic used to treat bacterial infections',
      dosageInfo: '250-500mg every 8 hours',
      route: 'Oral',
      stockQuantity: 250,
      expiryDate: '2025-12-30',
      manufacturer: 'GlaxoSmithKline',
      price: 15.50,
      sideEffects: [
        'Nausea',
        'Vomiting',
        'Diarrhea',
        'Skin rash',
        'Abdominal pain',
      ],
      contraindications: ['Penicillin allergy', 'Severe kidney disease'],
      interactions: ['Warfarin', 'Methotrexate'],
      storageConditions: 'Store at room temperature, away from moisture',
    ),
    Medication(
      id: 1,
      name: 'Amoxicillin',
      genericName: 'Amoxicillin',
      brandNames: ['Amoxil', 'Trimox'],
      category: 'Antibiotics',
      dosage: '500mg',
      forms: ['Capsule', 'Tablet', 'Suspension'],
      description: 'Beta-lactam antibiotic used to treat bacterial infections',
      dosageInfo: '250-500mg every 8 hours',
      route: 'Oral',
      stockQuantity: 250,
      expiryDate: '2025-12-30',
      manufacturer: 'GlaxoSmithKline',
      price: 15.50,
      sideEffects: [
        'Nausea',
        'Vomiting',
        'Diarrhea',
        'Skin rash',
        'Abdominal pain',
      ],
      contraindications: ['Penicillin allergy', 'Severe kidney disease'],
      interactions: ['Warfarin', 'Methotrexate'],
      storageConditions: 'Store at room temperature, away from moisture',
    ),

    Medication(
      id: 2,
      name: 'Ibuprofen',
      genericName: 'Ibuprofen',
      brandNames: ['Advil', 'Motrin'],
      category: 'NSAIDs',
      dosage: '200mg',
      forms: ['Tablet', 'Capsule', 'Suspension'],
      description:
          'Nonsteroidal anti-inflammatory drug for pain relief and inflammation',
      dosageInfo: '200-400mg every 4-6 hours as needed',
      route: 'Oral',
      stockQuantity: 500,
      expiryDate: '2026-01-15',
      manufacturer: 'Pfizer',
      price: 10.00,
      sideEffects: ['Heartburn', 'Nausea', 'Dizziness'],
      contraindications: ['Peptic ulcer', 'Severe heart failure'],
      interactions: ['Aspirin', 'Warfarin'],
      storageConditions: 'Store at 20°C to 25°C',
    ),

    Medication(
      id: 3,
      name: 'Lisinopril',
      genericName: 'Lisinopril',
      brandNames: ['Zestril', 'Prinivil'],
      category: 'ACE Inhibitors',
      dosage: '10mg',
      forms: ['Tablet'],
      description: 'Used to treat high blood pressure and heart failure',
      dosageInfo: '10-40mg once daily',
      route: 'Oral',
      stockQuantity: 300,
      expiryDate: '2026-05-10',
      manufacturer: 'Merck',
      price: 12.00,
      sideEffects: ['Cough', 'Dizziness', 'Headache'],
      contraindications: ['Pregnancy', 'Angioedema'],
      interactions: ['Potassium supplements', 'Diuretics'],
      storageConditions: 'Keep in a cool, dry place',
    ),

    Medication(
      id: 4,
      name: 'Metformin',
      genericName: 'Metformin Hydrochloride',
      brandNames: ['Glucophage', 'Fortamet'],
      category: 'Antidiabetics',
      dosage: '500mg',
      forms: ['Tablet', 'Extended-release tablet'],
      description: 'Used to control blood sugar levels in type 2 diabetes',
      dosageInfo: '500-1000mg twice daily with meals',
      route: 'Oral',
      stockQuantity: 400,
      expiryDate: '2027-02-28',
      manufacturer: 'Teva Pharmaceuticals',
      price: 18.75,
      sideEffects: ['Nausea', 'Flatulence', 'Diarrhea'],
      contraindications: ['Severe kidney disease', 'Metabolic acidosis'],
      interactions: ['Alcohol', 'Cimetidine'],
      storageConditions: 'Store below 30°C',
    ),

    Medication(
      id: 5,
      name: 'Atorvastatin',
      genericName: 'Atorvastatin Calcium',
      brandNames: ['Lipitor'],
      category: 'Statins',
      dosage: '20mg',
      forms: ['Tablet'],
      description: 'Used to lower cholesterol and reduce risk of heart disease',
      dosageInfo: '10-80mg once daily',
      route: 'Oral',
      stockQuantity: 220,
      expiryDate: '2026-11-20',
      manufacturer: 'Pfizer',
      price: 22.00,
      sideEffects: ['Muscle pain', 'Constipation', 'Liver enzyme changes'],
      contraindications: ['Liver disease', 'Pregnancy'],
      interactions: ['Grapefruit juice', 'Warfarin'],
      storageConditions: 'Store in original container, away from heat',
    ),

    Medication(
      id: 6,
      name: 'Omeprazole',
      genericName: 'Omeprazole',
      brandNames: ['Prilosec'],
      category: 'Proton Pump Inhibitors',
      dosage: '20mg',
      forms: ['Capsule', 'Tablet'],
      description: 'Reduces stomach acid production for GERD and ulcers',
      dosageInfo: '20mg once daily before meals',
      route: 'Oral',
      stockQuantity: 180,
      expiryDate: '2026-06-30',
      manufacturer: 'AstraZeneca',
      price: 8.90,
      sideEffects: ['Headache', 'Abdominal pain', 'Nausea'],
      contraindications: ['Allergy to omeprazole'],
      interactions: ['Clopidogrel', 'Warfarin'],
      storageConditions: 'Store in dry place at room temperature',
    ),

    Medication(
      id: 7,
      name: 'Azithromycin',
      genericName: 'Azithromycin',
      brandNames: ['Zithromax', 'Z-Pak'],
      category: 'Antibiotics',
      dosage: '250mg',
      forms: ['Tablet', 'Suspension'],
      description:
          'Macrolide antibiotic used to treat respiratory and skin infections',
      dosageInfo: '500mg on day 1, then 250mg daily for 4 days',
      route: 'Oral',
      stockQuantity: 150,
      expiryDate: '2025-10-10',
      manufacturer: 'Pfizer',
      price: 25.00,
      sideEffects: ['Diarrhea', 'Nausea', 'Abdominal pain'],
      contraindications: ['Liver disease', 'QT prolongation'],
      interactions: ['Antacids', 'Warfarin'],
      storageConditions: 'Keep away from direct light',
    ),

    Medication(
      id: 8,
      name: 'Simvastatin',
      genericName: 'Simvastatin',
      brandNames: ['Zocor'],
      category: 'Statins',
      dosage: '40mg',
      forms: ['Tablet'],
      description: 'Used to lower cholesterol and triglyceride levels',
      dosageInfo: '5-40mg once daily in the evening',
      route: 'Oral',
      stockQuantity: 130,
      expiryDate: '2027-01-01',
      manufacturer: 'Merck',
      price: 14.25,
      sideEffects: ['Headache', 'Muscle pain', 'Nausea'],
      contraindications: ['Liver disease', 'Pregnancy'],
      interactions: ['Grapefruit juice', 'Amiodarone'],
      storageConditions: 'Store below 25°C',
    ),

    Medication(
      id: 9,
      name: 'Losartan',
      genericName: 'Losartan Potassium',
      brandNames: ['Cozaar'],
      category: 'ARBs',
      dosage: '50mg',
      forms: ['Tablet'],
      description:
          'Used to treat high blood pressure and protect kidneys in diabetes',
      dosageInfo: '50mg once daily',
      route: 'Oral',
      stockQuantity: 270,
      expiryDate: '2026-03-20',
      manufacturer: 'Teva',
      price: 11.30,
      sideEffects: ['Dizziness', 'Back pain', 'Fatigue'],
      contraindications: ['Pregnancy', 'Severe hepatic impairment'],
      interactions: ['Potassium supplements', 'NSAIDs'],
      storageConditions: 'Store in a dry place, away from heat',
    ),

    Medication(
      id: 10,
      name: 'Levothyroxine',
      genericName: 'Levothyroxine Sodium',
      brandNames: ['Synthroid', 'Euthyrox'],
      category: 'Thyroid Hormones',
      dosage: '100mcg',
      forms: ['Tablet'],
      description: 'Used to treat hypothyroidism',
      dosageInfo: '100mcg daily on empty stomach',
      route: 'Oral',
      stockQuantity: 200,
      expiryDate: '2026-09-10',
      manufacturer: 'AbbVie',
      price: 9.95,
      sideEffects: ['Palpitations', 'Insomnia', 'Weight loss'],
      contraindications: ['Thyrotoxicosis', 'Acute MI'],
      interactions: ['Calcium supplements', 'Warfarin'],
      storageConditions: 'Protect from light and moisture',
    ),
    // Add other medications similarly
  ];

  final List<String> CATEGORIES = [
    'All Categories',
    'Antibiotics',
    'Pain Relief',
    'Diabetes',
    'Cardiovascular',
    'Gastrointestinal',
  ];
  final List<String> FORMS = [
    'All Forms',
    'Tablet',
    'Capsule',
    'Syrup',
    'Suspension',
    'Gel',
    'Extended Release',
  ];

  String searchTerm = '';
  String selectedCategory = 'All Categories';
  String selectedForm = 'All Forms';
  Medication? selectedMedication;
  List<CartItem> cartItems = [];
  String activeView = 'search';
  Map<String, String> patientInfo = {
    'name': '',
    'phone': '',
    'prescriptionId': '',
  };

  List<Medication> get filteredMedications {
    return MEDICATION_DATABASE.where((med) {
      final matchesSearch =
          med.name.toLowerCase().contains(searchTerm.toLowerCase()) ||
          med.genericName.toLowerCase().contains(searchTerm.toLowerCase()) ||
          med.brandNames.any(
            (brand) => brand.toLowerCase().contains(searchTerm.toLowerCase()),
          );

      final matchesCategory =
          selectedCategory == 'All Categories' ||
          med.category == selectedCategory;
      final matchesForm =
          selectedForm == 'All Forms' || med.forms.contains(selectedForm);

      return matchesSearch && matchesCategory && matchesForm;
    }).toList();
  }

  void addToCart(
    Medication medication, {
    int quantity = 1,
    String instructions = '',
  }) {
    setState(() {
      final existingIndex = cartItems.indexWhere(
        (item) => item.medication.id == medication.id,
      );
      if (existingIndex != -1) {
        cartItems[existingIndex].quantity += quantity;
      } else {
        cartItems.add(
          CartItem(
            medication: medication,
            quantity: quantity,
            instructions: instructions,
            dispensedAt: DateTime.now(),
          ),
        );
      }
    });
  }

  void removeFromCart(int medicationId) {
    setState(() {
      cartItems.removeWhere((item) => item.medication.id == medicationId);
    });
  }

  void updateCartQuantity(int medicationId, int quantity) {
    setState(() {
      if (quantity <= 0) {
        removeFromCart(medicationId);
        return;
      }

      final index = cartItems.indexWhere(
        (item) => item.medication.id == medicationId,
      );
      if (index != -1) {
        cartItems[index].quantity = quantity;
      }
    });
  }

  double getTotalAmount() {
    return cartItems.fold(
      0,
      (total, item) => total + (item.medication.price * item.quantity),
    );
  }

  Map<String, dynamic> getStockStatus(int quantity) {
    if (quantity == 0)
      return {
        'status': 'Out of Stock',
        'color': Colors.red,
        'bgColor': Colors.red[100]!,
      };
    if (quantity < 50)
      return {
        'status': 'Low Stock',
        'color': Colors.orange,
        'bgColor': Colors.orange[100]!,
      };
    return {
      'status': 'In Stock',
      'color': Colors.green,
      'bgColor': Colors.green[100]!,
    };
  }

  List<String> checkInteractions() {
    List<String> interactions = [];
    for (int i = 0; i < cartItems.length; i++) {
      for (int j = i + 1; j < cartItems.length; j++) {
        final med1 = cartItems[i].medication;
        final med2 = cartItems[j].medication;
        if (med1.interactions.contains(med2.name) ||
            med2.interactions.contains(med1.name)) {
          interactions.add('${med1.name} and ${med2.name}');
        }
      }
    }
    return interactions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        actions: [
          _buildViewButton('Search Drugs', Icons.search, 'search'),
          _buildViewButton('Dispense', Icons.person, 'dispense'),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: _buildMainContent()),
            SizedBox(width: 16),
            Expanded(flex: 1, child: _buildSidebar()),
          ],
        ),
      ),
    );
  }

  Widget _buildViewButton(String text, IconData icon, String view) {
    return Container(
      color: Colors.white,

      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: TextButton(
        onPressed: () => setState(() => activeView = view),
        style: TextButton.styleFrom(
          backgroundColor: activeView == view ? Colors.blue[100] : null,
          foregroundColor:
              activeView == view ? Colors.blue[700] : Colors.grey[600],
        ),
        child: Row(
          children: [
            Icon(icon, size: 16),
            SizedBox(width: 4),
            Text(text),
            if (view == 'dispense' && cartItems.isNotEmpty)
              Container(
                margin: EdgeInsets.only(left: 4),
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  cartItems.length.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    if (activeView == 'search') {
      return Column(
        children: [
          _buildSearchFilters(),
          SizedBox(height: 16),
          Expanded(child: _buildMedicationsGrid()),
        ],
      );
    } else {
      return _buildDispenseView();
    }
  }

  Widget _buildSearchFilters() {
    return Card(
      color: Colors.white,

      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search by drug name, generic name, or brand...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => searchTerm = value),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory,
                    items:
                        CATEGORIES
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ),
                            )
                            .toList(),
                    onChanged:
                        (value) => setState(() => selectedCategory = value!),
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedForm,
                    items:
                        FORMS
                            .map(
                              (form) => DropdownMenuItem(
                                value: form,
                                child: Text(form),
                              ),
                            )
                            .toList(),
                    onChanged: (value) => setState(() => selectedForm = value!),
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationsGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.4,
      ),
      itemCount: filteredMedications.length,
      itemBuilder: (context, index) {
        final medication = filteredMedications[index];
        final stockStatus = getStockStatus(medication.stockQuantity);

        return Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.blue),
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () => setState(() => selectedMedication = medication),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              medication.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              medication.genericName,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Chip(
                              label: Text(medication.category),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: stockStatus['bgColor'],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          stockStatus['status'],
                          style: TextStyle(
                            color: stockStatus['color'],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Column(
                    children: [
                      _buildInfoRow('Dosage:', medication.dosage),
                      _buildInfoRow(
                        'Stock:',
                        '${medication.stockQuantity} units',
                      ),
                      _buildInfoRow('Price:', '\$${medication.price}'),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton( style:ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 156, 196, 228)),
                    onPressed:
                        medication.stockQuantity == 0
                            ? null
                            : () => addToCart(medication),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 16),
                        SizedBox(width: 4),
                        Text('Add'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDispenseView() {
    return Column(
      children: [
        Card(
      color: Colors.white,

          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Patient Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(labelText: 'Patient Name'),
                        onChanged:
                            (value) =>
                                setState(() => patientInfo['name'] = value),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(labelText: 'Phone Number'),
                        onChanged:
                            (value) =>
                                setState(() => patientInfo['phone'] = value),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Prescription ID',
                        ),
                        onChanged:
                            (value) => setState(
                              () => patientInfo['prescriptionId'] = value,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        Expanded(
          child: Card(
      color: Colors.white,

            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Dispensing Cart',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child:
                      cartItems.isEmpty
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.local_pharmacy,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No medications in cart. Add medications from the search tab.',
                                ),
                              ],
                            ),
                          )
                          : ListView.builder(
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              return ListTile(
                                title: Text(item.medication.name),
                                subtitle: Text(
                                  '${item.medication.dosage} • ${item.medication.forms[0]}',
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed:
                                          () => updateCartQuantity(
                                            item.medication.id,
                                            item.quantity - 1,
                                          ),
                                    ),
                                    Text(item.quantity.toString()),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed:
                                          () => updateCartQuantity(
                                            item.medication.id,
                                            item.quantity + 1,
                                          ),
                                    ),
                                    Text(
                                      '\$${(item.medication.price * item.quantity).toStringAsFixed(2)}',
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed:
                                          () => removeFromCart(
                                            item.medication.id,
                                          ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                ),
                if (cartItems.isNotEmpty) ...[
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${getTotalAmount().toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Complete Dispensing'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: Size(double.infinity, 48),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSidebar() {
    return ListView(
      children: [
        if (selectedMedication != null) _buildMedicationDetails(),
        if (cartItems.length > 1) SizedBox(height: 16),
        if (cartItems.length > 1) _buildInteractionChecker(),
        SizedBox(height: 16),
        _buildQuickStats(),
      ],
    );
  }

  Widget _buildMedicationDetails() {
    return Card(color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medication Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              selectedMedication!.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              selectedMedication!.genericName,
              style: TextStyle(color: Colors.grey),
            ),
            Wrap(
              spacing: 4,
              children:
                  selectedMedication!.brandNames
                      .map((brand) => Chip(label: Text(brand)))
                      .toList(),
            ),
            SizedBox(height: 16),
            Text(selectedMedication!.description),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Dosage:', selectedMedication!.dosageInfo),
                _buildDetailRow('Route:', selectedMedication!.route),
                _buildDetailRow('Forms:', selectedMedication!.forms.join(', ')),
                _buildDetailRow(
                  'Manufacturer:',
                  selectedMedication!.manufacturer,
                ),
                _buildDetailRow('Expiry:', selectedMedication!.expiryDate),
              ],
            ),
            SizedBox(height: 16),
            Text('Side Effects', style: TextStyle(fontWeight: FontWeight.bold)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  selectedMedication!.sideEffects
                      .map((effect) => Text('• $effect'))
                      .toList(),
            ),
            SizedBox(height: 16),
            Text(
              'Contraindications',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  selectedMedication!.contraindications
                      .map((contra) => Text('• $contra'))
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: '$label ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionChecker() {
    final interactions = checkInteractions();

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Drug Interactions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            interactions.isEmpty
                ? Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text('No interactions detected'),
                  ],
                )
                : Column(
                  children:
                      interactions
                          .map(
                            (interaction) => ListTile(
                              leading: Icon(
                                Icons.warning,
                                color: Colors.orange,
                              ),
                              title: Text('Potential Interaction'),
                              subtitle: Text(interaction),
                            ),
                          )
                          .toList(),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Card(
      color: Colors.white,

      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Stats',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildStatRow(
              'Total Medications',
              MEDICATION_DATABASE.length.toString(),
            ),
            _buildStatRow('In Cart', cartItems.length.toString()),
            _buildStatRow(
              'Low Stock Items',
              MEDICATION_DATABASE
                  .where((med) => med.stockQuantity < 50)
                  .length
                  .toString(),
              color: Colors.orange,
            ),
            _buildStatRow(
              'Out of Stock',
              MEDICATION_DATABASE
                  .where((med) => med.stockQuantity == 0)
                  .length
                  .toString(),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
