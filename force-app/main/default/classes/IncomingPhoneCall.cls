@RestResource(urlMapping='/incomingPhoneCall')
global class IncomingPhoneCall {
    @HttpGet
    global static String incomingPhoneCall(){
        RestContext.response.addHeader('Content-Type', 'text/plain');
        String toPhoneNumber = RestContext.request.params.get('to');
        String fromPhoneNumber = RestContext.request.params.get('from');
        String key = RestContext.request.params.get('key');

        if (String.isBlank(key)) {
            return '403 - Forbidden';
        }
        if (!IncomingPhoneCallHelper.isKeyMatch(key)) {
            return '401 - Unauthorized';
        }

        Incoming_Phone_Call__e incomingPhoneCallEvent = new Incoming_Phone_Call__e(
            To__c = toPhoneNumber,
            From__c = fromPhoneNumber
        );
        Database.SaveResult sr = EventBus.publish(incomingPhoneCallEvent);

        return '200 - OK';
    }
}