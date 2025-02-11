class Futsal {
  final String id;
  final String name;
  final String location;
  final double price;
  final String ownerId;
  final String timeSlots;

  Futsal({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.ownerId,
    required this.timeSlots
  });

  // Convert JSON to Futsal object
  factory Futsal.fromJson(Map<String, dynamic> json) {
    return Futsal(
      id: json['_id'],
      location: json['location'],
      name: json['name'],
      price: json['price'],
      ownerId: json['owner_id'],
      timeSlots: json['timeSlots']
    );
  }

  // Convert Futsal object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location': location,
      'name':name,
      'price': price,
      'owner_id': ownerId,
      'timeSlots':timeSlots
    };
  }
}
