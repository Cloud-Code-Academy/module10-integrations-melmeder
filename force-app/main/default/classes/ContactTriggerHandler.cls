public with sharing class ContactTriggerHandler extends TriggerHandler {
  // When a contact is inserted
  // if DummyJSON_Id__c is null, generate a random number between 0 and 100 and set this as the contact's DummyJSON_Id__c value

  //When a contact is inserted
  // if DummyJSON_Id__c is less than or equal to 100, call the getDummyJSONUserFromId API

  //When a contact is updated
  // if DummyJSON_Id__c is greater than 100, call the postCreateDummyJSONUser API

  List<Contact> triggerNew = new List<Contact>();
  Map<Id, Contact> triggerNewMap = new Map<Id, Contact>();

  public ContactTriggerHandler() {
    this.triggerNew = (List<Contact>) Trigger.new;
    this.triggerNewMap = (Map<Id, Contact>) Trigger.newMap;
  }

  public override void beforeInsert() {
    for (Contact contact : triggerNew) {
      if (contact.DummyJSON_Id__c == null) {
        Integer randomNumber = Math.floor(Math.random() * 101).intValue();
        contact.DummyJSON_Id__c = String.valueOf(randomNumber);
      }
    }
  }

  public override void afterInsert() {
    for (Contact contact : triggerNew) {
      if (Integer.valueOf(contact.DummyJSON_Id__c) <= 100) {
        DummyJSONCallout.getDummyJSONUserFromId(contact.DummyJSON_Id__c);
      }
    }
  }

  public override void afterUpdate() {
    for (Contact contact : triggerNew) {
      if (Integer.valueOf(contact.DummyJSON_Id__c) > 100) {
        DummyJSONCallout.postCreateDummyJSONUser(contact.DummyJSON_Id__c);
      }
    }
  }
}
