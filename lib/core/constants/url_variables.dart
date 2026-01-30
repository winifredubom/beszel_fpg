
enum Environment {prod }

const Environment currentEnvironment = Environment.prod;

// Auth baseurl
final String authBaseUrl = _getAuthBaseUrl();
// API baseurl  
final String baseUrl = _getBaseUrl();

String _getAuthBaseUrl() {
return "https://beszel.flexipgroup.com/api";
    
}

String _getBaseUrl() {
 return "https://beszel.flexipgroup.com/api";
  
}

