String baseUrl = '';
String loginUrl = '';
String registerUrl = '';
String getTasksUrl = '';
String getCallsUrl = '';
String getContacts = '';
String getLeads = '';
String getNotes = '';
String getCustomer = '';
String getOpportunities = '';
// String saveTasksUrl = '';
// String saveCallsUrl = '';
// String saveContacts = '';
// String saveLeads = '';
// String saveCustomers = '';
// String saveNotes = '';
String getUsers = '';
String deleteNotes = '';
String deleteTasks = "";
String deleteCalls = "";

String saveUpdateNotes = "";
String saveUpdateTasks = "";
String saveUpdateCalls = "";
String saveUpdateCustomers = "";
String saveUpdateContacts = "";
String saveUpdateOpportunity = "";
String saveUpdateLeads = "";

void updateUrls(String newBaseUrl) {

  baseUrl = newBaseUrl;
  loginUrl = '$baseUrl/login';
  registerUrl = '$baseUrl/register';

  // Get APIs
  getTasksUrl = '$baseUrl/get_tasks';
  getCallsUrl = '$baseUrl/get_calls';
  getContacts = '$baseUrl/get_contacts';
  getLeads = '$baseUrl/get_leads';
  getNotes = '$baseUrl/get_notes';
  getCustomer = '$baseUrl/get_customers';
  getUsers = '$baseUrl/get_users';
  getOpportunities = '$baseUrl/get_opportunity';

  // Save and Update APIs
  // saveLeads = '$baseUrl/save_leads';
  saveUpdateNotes = '$baseUrl/save-or-update_note';
  saveUpdateTasks = '$baseUrl/save-or-update-task';
  saveUpdateCalls = '$baseUrl/save-or-update-call';
  saveUpdateCustomers = '$baseUrl/save-or-update_customers';
  saveUpdateContacts = '$baseUrl/save-or-update_contacts';
  saveUpdateOpportunity = '$baseUrl/save-or-update_opportunity';
  saveUpdateLeads = '$baseUrl/save-or-update_leads';

  //Delete APIs
  deleteNotes = '$baseUrl/delete_notes';
  deleteTasks = '$baseUrl/delete_tasks';
  deleteCalls = '$baseUrl/delete_calls';
}
