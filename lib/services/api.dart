import 'package:flutura/models/Category.dart';
import 'package:flutura/models/Transaction.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  late String token;

  ApiService(String token) {
    this.token = token;
  }

  final String baseUrl = 'http://fluterapi.test/api/';

  Future<List<Category>> fetchCategories() async {
    http.Response response = await http.get(Uri.parse(baseUrl + 'categories'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    List categories = jsonDecode(response.body);

    return categories.map((category) => Category.fromJson(category)).toList();
  }

  Future<Category> updateCategory(Category category) async {
    String uri = baseUrl + 'categories/' + category.id.toString();

    http.Response response = await http.put(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode({'name': category.name}));

    if (response.statusCode != 200) {
      throw Exception('Error Happened on Update');
    }

    return Category.fromJson(jsonDecode(response.body));
  }

  Future<Category> addCategory(String name) async {
    String uri = baseUrl + 'categories';

    http.Response response = await http.post(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode({'name': name}));

    if (response.statusCode != 201) {
      throw Exception('Error Happened on created');
    }

    return Category.fromJson(jsonDecode(response.body));
  }

  Future<void> deleteCategory(id) async {
    String uri = baseUrl + 'categories/' + id.toString();

    http.Response response = await http.delete(Uri.parse(uri),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );


    if (response.statusCode != 204) {
      throw Exception('Error Happened on delete');
    }
  }

  Future<List<Transaction>> fetchTransactions() async {
    http.Response response = await http.get(Uri.parse(baseUrl + 'transaction'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    List transactions = jsonDecode(response.body);

    return transactions.map((transaction) => Transaction.fromJson(transaction)).toList();
  }

  Future<Transaction> updateTransaction(Transaction transaction) async {
    String uri = baseUrl + 'transaction/' + transaction.id.toString();

    http.Response response = await http.put(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode({
          'description': transaction.description,
          'category_id': transaction.categoryId,
          'amount': transaction.amount,
          'transaction_date': transaction.transactionDate,
        }));

    if (response.statusCode != 200) {
      throw Exception('Error Happened on Update');
    }

    return Transaction.fromJson(jsonDecode(response.body));
  }

  Future<Transaction> addTransaction(String description, String amount, String category, String date) async {
    String uri = baseUrl + 'transaction';

    http.Response response = await http.post(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode({
          'description': description,
          'category_id': category,
          'amount': amount,
          'transaction_date': date,
        }));

    if (response.statusCode != 201) {
      throw Exception('Error Happened on created');
    }

    return Transaction.fromJson(jsonDecode(response.body));
  }

  Future<void> deleteTransaction(id) async {
    String uri = baseUrl + 'transaction/' + id.toString();

    http.Response response = await http.delete(Uri.parse(uri),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );


    if (response.statusCode != 204) {
      throw Exception('Error Happened on delete');
    }
  }

  Future<String> register(String name, String email, String password, String passwordConfirm, String deviceName) async {
    String uri = baseUrl + 'auth/register';

    // http.Response response = await http.delete(Uri.parse(uri));

    http.Response response = await http.post(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email' : email,
          'password' : password,
          'password_confirmation': passwordConfirm,
          'device_name': deviceName
        }));

    if (response.statusCode == 422) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String errorMessage = '';
      errors.forEach((key, value) {
        value.forEach((element) {
          errorMessage += element + '\n';
        });
      });
      throw Exception(errorMessage);
    }

    return response.body;
  }

  Future<String> login(String email, String password, String deviceName) async {
    String uri = baseUrl + 'auth/login';

    // http.Response response = await http.delete(Uri.parse(uri));

    http.Response response = await http.post(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        },
        body: jsonEncode({
          'email' : email,
          'password' : password,
          'device_name': deviceName
        }));

    if (response.statusCode == 422) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String errorMessage = '';
      errors.forEach((key, value) {
        value.forEach((element) {
          errorMessage += element + '\n';
        });
      });
      throw Exception(errorMessage);
    }

    return response.body;
  }
}
