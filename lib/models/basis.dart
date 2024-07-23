class Basis {
  final int basis_locatioID;
  final String full_name;
  final String posting_date;
  final double price;
  final String product_name;
  final double distance;
  final bool is_spot;
  final double futuresprice;
  final double cashprice;
  final double basisLatitude;
  final double basisLongitude;
  double estCashPriceAfterDel;

  Basis.fromJson(Map<String, dynamic> json)
      : basis_locatioID = int.tryParse(json['basis_locatioID'].toString()) ?? 1,
        full_name = json['full_name'],
        posting_date = json['posting_date'],
        price = double.tryParse(json['price'].toString()) ?? 0,
        product_name = json['product_name'],
        distance = json['distance'],
        is_spot = json['is_spot'],
        futuresprice = double.parse(json['futuresprice'].toString()),
        cashprice = json['cashprice'],
        basisLatitude = double.tryParse(json['latitude'].toString()) ?? 0,
        basisLongitude = double.tryParse(json['longitude'].toString()) ?? 0,
        estCashPriceAfterDel = double.parse('0.0');

  Map<String, dynamic> toJson() {
    return {
      'id': basis_locatioID,
      'BasisLocationName': full_name,
      'description': product_name,
      'price': price,
      'distance': distance,
      'posting_date': posting_date,
      'futuresprice': futuresprice,
      'cashprice': cashprice,
      'latitude': basisLatitude,
      'longitude': basisLongitude,
      'estCashPriceAfterDel': estCashPriceAfterDel,
    };
  }
}
