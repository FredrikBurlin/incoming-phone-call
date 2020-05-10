trigger IncomingPhoneCallTrigger on Incoming_Phone_Call__e (after insert) {
    for (Incoming_Phone_Call__e event : Trigger.new) {
        IncomingPhoneCallHelper.handler(event.To__c, event.From__c);
    }
}