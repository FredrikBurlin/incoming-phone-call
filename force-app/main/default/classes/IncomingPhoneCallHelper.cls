public without sharing class IncomingPhoneCallHelper {
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
                cont.Account.Name + ' (Contact)',
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
                led.Company + ' (Lead)',
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
            LastName = 'Unknown',
            Company = 'Unknown',
            MobilePhone = fromPhoneNumber,
            OwnerId = ownerId);
        insert led;

        sendNotification(
            led.LastName,
            led.Company + ' (Lead)',
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
            .title('📞' + fullName)
            .body(body)
            .targetId(targetId)
            .sendToCurrentUser(ownerId);
    }

    private static void addTask(Id whoId, Id whatId) {
       insert new Task(
            Subject = 'Received Call ' + fromPhoneNumber,
            Status = 'Completed',
            Priority = 'Normal',
            OwnerId = ownerId,
            WhoId = whoId,
            WhatId = whatId,
            ActivityDate = Date.today()
       );
    }
}
