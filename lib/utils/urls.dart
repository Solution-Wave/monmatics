String baseUrl = '';
String loginUrl = '';
String registerUrl = '';
String getTasksUrl = '';
String getCallsUrl = '';
String getContacts = '';
String getLeads = '';
String getNotes = '';
String getCustomer = '';
String saveTasksUrl = '';
String saveCallsUrl = '';
String saveContacts = '';
String saveLeads = '';
String saveNotes = '';

void updateUrls(String newBaseUrl) {
  baseUrl = newBaseUrl;
  loginUrl = '$baseUrl/login';
  registerUrl = '$baseUrl/register';
  getTasksUrl = '$baseUrl/get_tasks';
  getCallsUrl = '$baseUrl/get_calls';
  getContacts = '$baseUrl/get_contacts';
  getLeads = '$baseUrl/get_leads';
  getNotes = '$baseUrl/get_notes';
  getCustomer = '$baseUrl/get_customer';
  saveTasksUrl = '$baseUrl/save_tasks';
  saveCallsUrl = '$baseUrl/save_calls';
  saveContacts = '$baseUrl/save_contacts';
  saveLeads = '$baseUrl/save_leads';
  saveNotes = '$baseUrl/save_notes';
}
