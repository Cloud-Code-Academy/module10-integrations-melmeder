public with sharing class DummyJSONPostQueueable implements Queueable, Database.AllowsCallouts {
  private string contactId;

  public DummyJSONPostQueueable(String contactId) {
    this.contactId = contactId;
  }

  public void execute(QueueableContext qc) {
    // Create HTTP request to send.
    HttpRequest request = new HttpRequest();
    // Set the endpoint URL. Use direct URL or for best practices use Named Credential.
    request.setEndpoint('callout:DummyJsonUser' + '/add');
    // Set the HTTP method to POST.
    request.setMethod('POST');
    // Set the body using generateDummyJsonUserPayload method.
    request.setHeader('Content-Type', 'application/json');
    request.setBody(DummyJSONCallout.generateDummyJsonUserPayload(contactId));
    // Send the HTTP request and get the response.
    try {
      Http http = new Http();
      HttpResponse response = http.send(request);

      // If the HTTP response code is successful, update the contact.
      if (response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
        Contact cont = new Contact(
          Id = contactId,
          DummyJSON_Last_Updated__c = System.today()
        );
        Database.update(cont, AccessLevel.SYSTEM_MODE);
      }
    } catch (Exception e) {
      System.debug(LoggingLevel.ERROR, e.getMessage());
    }
  }
}
