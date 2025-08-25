public with sharing class DummyJSONGetQueueable implements Queueable, Database.AllowsCallouts {
  public string dummyUserId;

  public DummyJSONGetQueueable(String dummyUserId) {
    this.dummyUserId = dummyUserId;
  }

  public void execute(QueueableContext qc) {
    // Create HTTP request to send.
    HttpRequest request = new HttpRequest();

    // Set the endpoint URL. Use direct URL or for best practices use Named Credential.
    request.setEndpoint('callout:DummyJsonUser' + '/' + dummyUserId);
    // Set the HTTP method to GET.
    request.setMethod('GET');
    // Send the HTTP request and get the response.
    Http http = new Http();

    try {
      HttpResponse response = http.send(request);

      System.debug('JSON Response: ' + response.getBody());

      // If the HTTP response code is successful, parse the JSON response and update the contact.
      if (response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
        Contact cont = DummyJSONCallout.createContactFromJson(
          response.getBody()
        );
        Database.upsert(cont, Contact.DummyJSON_Id__c, AccessLevel.SYSTEM_MODE); //insert/update from the JSON response using the external id (dummyUserId)
      }
    } catch (Exception e) {
      System.debug(LoggingLevel.ERROR, e.getMessage());
    }
  }
}
