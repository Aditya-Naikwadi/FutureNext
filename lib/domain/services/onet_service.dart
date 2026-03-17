import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:futurenext/data/models/occupation_model.dart';

class OnetService {
  final String _baseUrl = 'https://services.onetcenter.org/ws';
  
  // O*NET uses Basic Authentication (Username:Password)
  // User should replace these with their own credentials
  final String _username = 'YOUR_ONET_USERNAME';
  final String _password = 'YOUR_ONET_PASSWORD';

  Map<String, String> get _headers {
    final credentials = base64Encode(utf8.encode('$_username:$_password'));
    return {
      'Authorization': 'Basic $credentials',
      'Accept': 'application/json',
    };
  }

  /// Searches for occupation codes based on a job title
  Future<List<Map<String, String>>> searchOccupations(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/online/search?keyword=$query&end=5'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['occupation'] as List? ?? [];
        return results.map((occ) => {
          'code': occ['code'].toString(),
          'title': occ['title'].toString(),
        }).toList();
      }
    } catch (e) {
      // Handle search error silently or via logging framework
    }
    return [];
  }

  /// Fetches deep-dive details for a specific occupation SOC code
  Future<OccupationDetails?> getOccupationDetails(String socCode) async {
    try {
      // Fetch basic summary, outlook, and wages
      final summaryRes = await http.get(Uri.parse('$_baseUrl/online/occupations/$socCode/summary'), headers: _headers);
      
      if (summaryRes.statusCode == 200) {
        final data = jsonDecode(summaryRes.body);
        
        // In a real implementation, we would make secondary calls to /wages, /outlook etc.
        // For this professional demo, we'll parse the summary and simulated outlook data
        return OccupationDetails(
          code: socCode,
          title: data['title'] ?? 'Occupation',
          description: data['description'] ?? '',
          tasks: _extractList(data, 'tasks', 'task'),
          skills: _extractList(data, 'skills', 'skill'),
          technology: _extractList(data, 'tools_technology', 'tool'),
          outlook: 'Bright Outlook', // Placeholder for actual outlook API call
          education: 'Bachelor\'s Degree', // Placeholder 
          medianSalary: '\$85,000 / year', // Placeholder
        );
      }
    } catch (e) {
      // Handle details error
    }
    return null;
  }

  List<String> _extractList(Map<String, dynamic> data, String parentKey, String itemKey) {
    try {
      final parent = data[parentKey];
      if (parent != null && parent[itemKey] != null) {
        final List items = parent[itemKey];
        return items.take(5).map((e) => e['name'].toString()).toList();
      }
    } catch (_) {}
    return [];
  }
}
