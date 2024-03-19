

// SharedPreferences prefs = await SharedPreferences.getInstance();
// print(prefs.getString('token'));

String baseUrl = 'https://dev.monmatics.com/api';

String loginUrl = '$baseUrl/login';
String registerUrl= '$baseUrl/register';

//Get Urls
String getTasksUrl = '$baseUrl/get_tasks';
String getCallsUrl = '$baseUrl/get_calls';
String getContacts = '$baseUrl/get_contacts';
String getLeads = '$baseUrl/get_leads';
String getNotes = '$baseUrl/get_notes';
String getCustomer = '$baseUrl/get_customer';

//Post Urls
String saveTasksUrl = '$baseUrl/save_tasks';
String saveCallsUrl = '$baseUrl/save_calls';
String saveContacts = '$baseUrl/save_contacts';
String saveLeads = '$baseUrl/save_leads';
String saveNotes = '$baseUrl/save_notes';