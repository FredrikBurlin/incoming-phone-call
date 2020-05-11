@isTest
public class IncomingPhoneCallTest {
    @isTest
    static void incomingPhoneCall_Forbidden() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.addHeader('httpMethod', 'GET');
        req.requestUri = '/services/apexrest/incomingPhoneCall';
        req.addParameter('to', '+61488850205');
        req.addParameter('from', '+61400000001');
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        System.assertEquals('403 - Forbidden', IncomingPhoneCall.incomingPhoneCall());
        Test.stopTest();
    }

    @isTest
    static void incomingPhoneCall_Unauthorized() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.addHeader('httpMethod', 'GET');
        req.requestUri = '/services/apexrest/incomingPhoneCall';
        req.addParameter('to', '+61488850205');
        req.addParameter('from', '+61400000001');
        req.addParameter('key', 'qwerty123');
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        System.assertEquals('401 - Unauthorized', IncomingPhoneCall.incomingPhoneCall());
        Test.stopTest();
    }

    @isTest
    static void incomingPhoneCall_OK() {
        Test.startTest();
        Incoming_Phone_Call_Key__c setting = new Incoming_Phone_Call_Key__c();
        setting.Key__c = 'qwerty123';
        insert setting;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.addHeader('httpMethod', 'GET');
        req.requestUri = '/services/apexrest/incomingPhoneCall';
        req.addParameter('to', '+61488850205');
        req.addParameter('from', '+61400000001');
        req.addParameter('key', 'qwerty123');
        RestContext.request = req;
        RestContext.response = res;
        System.assertEquals('200 - OK', IncomingPhoneCall.incomingPhoneCall());
        Test.getEventBus().deliver();
        Test.stopTest();
        Lead led = [SELECT Id, LastName FROM Lead WHERE MobilePhone = '+61400000001'];
        System.assertEquals('Unknown',led.LastName);
        Task tsk = [SELECT Id, Subject FROM Task WHERE WhoId =: led.Id];
        System.assertEquals('Received Call +61400000001',tsk.Subject);
    }

    @isTest
    static void incomingPhoneCall_OK_contactMatch() {
        Test.startTest();
        Incoming_Phone_Call_Key__c setting = new Incoming_Phone_Call_Key__c();
        setting.Key__c = 'qwerty123';
        insert setting;

        Account acn = new Account(
            Name = 'Annas Pepparkakor');
        insert acn;

        Contact con = new Contact(
            FirstName = 'Anna',
            LastName = 'Svensson',
            AccountId = acn.Id,
            MobilePhone = '+61400000001');
        insert con;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.addHeader('httpMethod', 'GET');
        req.requestUri = '/services/apexrest/incomingPhoneCall';
        req.addParameter('to', '+61488850205');
        req.addParameter('from', '+61400000001');
        req.addParameter('key', 'qwerty123');
        RestContext.request = req;
        RestContext.response = res;
        System.assertEquals('200 - OK', IncomingPhoneCall.incomingPhoneCall());
        Test.getEventBus().deliver();
        Test.stopTest();
        con = [SELECT Id, LastName FROM Contact WHERE MobilePhone = '+61400000001'];
        System.assertEquals('Svensson',con.LastName);
        Task tsk = [SELECT Id, Subject FROM Task WHERE WhoId =: con.Id];
        System.assertEquals('Received Call +61400000001',tsk.Subject);
    }

    @isTest
    static void incomingPhoneCall_OK_leadMatch() {
        Test.startTest();
        Incoming_Phone_Call_Key__c setting = new Incoming_Phone_Call_Key__c();
        setting.Key__c = 'qwerty123';
        insert setting;

        Lead led = new Lead(
            FirstName = 'Lisbeth',
            LastName = 'Salander',
            Company = 'Independent',
            Phone = '+61400000002');
        insert led;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.addHeader('httpMethod', 'GET');
        req.requestUri = '/services/apexrest/incomingPhoneCall';
        req.addParameter('to', '+61488850205');
        req.addParameter('from', '+61400000002');
        req.addParameter('key', 'qwerty123');
        RestContext.request = req;
        RestContext.response = res;
        System.assertEquals('200 - OK', IncomingPhoneCall.incomingPhoneCall());
        Test.getEventBus().deliver();
        Test.stopTest();
        led = [SELECT Id, LastName FROM Lead WHERE Phone = '+61400000002'];
        System.assertEquals('Salander',led.LastName);
        Task tsk = [SELECT Id, Subject FROM Task WHERE WhoId =: led.Id];
        System.assertEquals('Received Call +61400000002',tsk.Subject);
    }
}