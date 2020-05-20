public without sharing class IncomingPhoneCallHelper {
    private static final String NOTIFICATION_PREFIX = '📞 ';
    private static final String TASK_SUBJECT_PREFIX = 'Received Call ';
    private static final String TASK_STATUS = 'Completed';
    private static final String TASK_PRIORITY = 'Normal';
    private static final String TASK_TYPE = 'Call';
    private static final String NEW_LEAD_CURRENCY = 'AUD';
    private static final String NEW_LEAD_COMPANY = 'Unknown';
    private static final String NEW_LEAD_LASTNAME = 'Unknown';

    private static Id ownerId;
    private static String fromPhoneNumber;

    public static Boolean isKeyMatch(String key) {
        Incoming_Phone_Call_Key__c keyInstance = Incoming_Phone_Call_Key__c.getInstance();
        try {
            return key == String.valueOf(keyInstance.get('Key__c'));
        } catch (Exception e) {
            return false;
        }
    }

    private static Id getOwnerId(String calledNumber) {
        Id ownerId;
        try {
            ownerId = [SELECT Id FROM User WHERE Phone =: calledNumber LIMIT 1].Id;
        } catch (Exception e) {
            ownerId = UserInfo.getUserId();
        }
        return ownerId;
    }

    public static void handler(String toPhoneNumber, String fromNumber) {
        ownerId = getOwnerId(toPhoneNumber);
        fromPhoneNumber = fromNumber;
        Integer matches = 0;
        matches += findMatchingContacts();
        matches += findMatchingLeads();

        if (matches == 0) {
            createLead();
        }
    }

    private static Integer findMatchingContacts() {
        List<Contact> contacts = [
            SELECT Id, FirstName, LastName, Account.Name, AccountId, Phone, MobilePhone, OwnerId
            FROM Contact
            WHERE (Phone =: fromPhoneNumber OR MobilePhone =: fromPhoneNumber)];
        for (Contact cont : contacts) {
            sendNotification(
                String.isBlank(cont.FirstName) ? cont.LastName : cont.FirstName + ' ' + cont.LastName,
                cont.Account.Name,
                cont.Id,
                ownerId);
            addTask(
                cont.Id,
                cont.AccountId
            );
        }
        return contacts.size();
    }

    private static Integer findMatchingLeads() {
        List<Lead> leads = [
            SELECT Id, FirstName, LastName, Company, Phone, MobilePhone, OwnerId
            FROM Lead
            WHERE (Phone =: fromPhoneNumber OR MobilePhone =: fromPhoneNumber)
            AND isConverted = false];
        for (Lead led : leads) {
            sendNotification(
                String.isBlank(led.FirstName) ? led.LastName : led.FirstName + ' ' + led.LastName,
                led.Company,
                led.Id,
                led.OwnerId);
            addTask(
                led.Id,
                null
            );
        }
        return leads.size();
    }

    private static void createLead() {
        Lead led = new Lead(
            FirstName = '',
            LastName = NEW_LEAD_LASTNAME,
            Company = NEW_LEAD_COMPANY,
            CurrencyIsoCode = NEW_LEAD_CURRENCY,
            MobilePhone = fromPhoneNumber,
            OwnerId = ownerId);
        insert led;

        sendNotification(
            led.LastName,
            led.Company,
            led.Id,
            led.OwnerId);
        addTask(
            led.Id,
            null
        );
    }

    private static void sendNotification(String fullName, String body, Id targetId, Id ownerId) {
        new CustomNotification()
            .type('Incoming_Phone_Call')
            .title(NOTIFICATION_PREFIX + fullName)
            .body(body)
            .targetId(targetId)
            .sendToCurrentUser(ownerId);
    }

    private static void addTask(Id whoId, Id whatId) {
       insert new Task(
            Subject = TASK_SUBJECT_PREFIX + fromPhoneNumber,
            Status = TASK_STATUS,
            Priority = TASK_PRIORITY,
            Type = TASK_TYPE,
            OwnerId = ownerId,
            WhoId = whoId,
            WhatId = whatId,
            ActivityDate = Date.today()
       );
    }
}