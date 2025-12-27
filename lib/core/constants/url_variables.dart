
enum Environment {prod }

const Environment currentEnvironment = Environment.prod;

// Auth baseurl
final String authBaseUrl = _getAuthBaseUrl();
// API baseurl  
final String baseUrl = _getBaseUrl();

String _getAuthBaseUrl() {
return "https://auth.civishealth.com/api/auth";
    
}

String _getBaseUrl() {
 return "https://auth.civishealth.com/api";
  
}

