class Address {
  const Address({required this.id, required this.label, required this.street, required this.commune, required this.wilaya});

  final String id, label, street, commune, wilaya;
}

class Client {
  const Client({required this.id, required this.name, required this.phone, required this.balance, required this.addresses});

  final String id, name, phone;

  /// Yassir Cash, in DZD.
  final int balance;
  final List<Address> addresses;

  Client copyWith({int? balance}) =>
      Client(id: id, name: name, phone: phone, balance: balance ?? this.balance, addresses: addresses);
}
