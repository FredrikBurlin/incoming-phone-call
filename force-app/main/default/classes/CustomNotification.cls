/**
 * Fun basic example of what an Apex Custom Notification API might look like!
 * https://github.com/afawcett/customnotificationdemo
 *
    new CustomNotification()
        .type('BatchApexError')
        .title('Batch Error')
        .body('Some useful information')
        .sendToCurrentUser();
 */
public without sharing class CustomNotification {

    private String notificationTypeId;
    private String notificationTypeName;
    private String notificationBody;
    private String notificationTitle;
    private Id notificationTargetId;
    private List<Id> recipientIds;
    private Id senderId;

    public CustomNotification() {}

    public CustomNotification targetId(Id targetId) {
        this.notificationTargetId = targetId;
        return this;
    }

    public CustomNotification type(String type) {
        this.notificationTypeName = type;
        return this;
    }

    public CustomNotification title(String title) {
        this.notificationTitle = title;
        return this;
    }

    public CustomNotification body(String body) {
        this.notificationBody = body;
        return this;
    }

    public CustomNotification sendToCurrentUser(Id ownerId) {
        this.recipientIds = new List<Id> { ownerId };
        return send();
    }

    // TODO: Add more methods to add multiple recipients for example
    // ...

    public CustomNotification send() {
        // Until there is an Apex API for Custom Notification
        //   delegage to an Autolaunch Flow wrapper
        new FlowProcess()
            .named('SendCustomNotification')
            .with('CustomNotificationTypeId', getIdFromType(this.notificationTypeName))
            .with('NotificationBody', this.notificationBody)
            .with('NotificationTitle', this.notificationTitle)
            .with('RecipientIds', this.recipientIds)
            .with('TargetId', this.notificationTargetId)
            .run();
        // TODO: Error handling
        // ...
        return this;
    }

    private static Id getIdFromType(String notificationTypeName) {
        return [SELECT Id FROM CustomNotificationType WHERE DeveloperName =: notificationTypeName].Id;
    }
}