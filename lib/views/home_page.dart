import 'package:flutter/material.dart';
import '../controllers/exchange_controller.dart';
import '../models/exchange_rate.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ExchangeController _controller = ExchangeController();
  ExchangeRate? _exchangeRate;
  bool _isLoading = false;

  String _baseCurrency = "EUR";
  String _targetCurrency = "USD";

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    final rate = await _controller.fetchExchangeRate(
      base: _baseCurrency,
      symbols: _targetCurrency,
    );
    setState(() {
      _exchangeRate = rate;
      _isLoading = false;
    });
  }

  void _changeCurrencies(String base, String target) {
    setState(() {
      _baseCurrency = base;
      _targetCurrency = target;
    });
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Currency Exchange"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchData,
          )
        ],
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _exchangeRate != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/currency.png',
              width: 80,
              height: 80,
            ),
            SizedBox(height: 16),

            Text(
              "$_baseCurrency → $_targetCurrency",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),

            Text(
              "Exchange Rate: ${_exchangeRate!.rates[_targetCurrency]?.toStringAsFixed(4) ?? '---'}",
              style: TextStyle(
                fontSize: 24,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),

            Text(
              "Date: ${_exchangeRate!.date}",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 32),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (_targetCurrency == "USD") {
                  _changeCurrencies("EUR", "JPY");
                } else {
                  _changeCurrencies("EUR", "USD");
                }
              },
              child: Text(
                _targetCurrency == "USD"
                    ? "Change Currency Pair (EUR → JPY)"
                    : "Change Currency Pair (EUR → USD)",
              ),
            ),
          ],
        )
            : Text("No Data Found"),
      ),
    );
  }
}


