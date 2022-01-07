global class DeleteEventBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext batchContext ){
        String query= 'SELECT Id,Name FROM Event__c WHERE Live__c = true  AND End_Date_Time__c < LAST_N_MONTHS:2';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext batchContext, List<Event__c> eventList){
        if (!eventList.isEmpty()) {
            List<Database.DeleteResult> deleteResult = Database.delete(eventList);
            for (Database.DeleteResult variable : deleteResult) {
                if (!variable.isSuccess()) {
                    List<Database.Error> errors= variable.getErrors();
                    String errorInString=String.join(errors, ',');
                    TransactionLogHandler.doHandleExceptionWithError(errorInString, 'DeleteEventBatch');
                }
            }
            

        }
    }

    global void finish(Database.BatchableContext batchContext){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Batch Delete process is completed');
        List<String> toAddress = new List<String>();
        toAddress.add('padexe12@gmail.com');
        mail.setToAddresses(toAddress);
        mail.setHtmlBody('The DeleteEventBatch batch processing has been completed');
        messaging.sendEmail(new List<Messaging.SingleEmailMessage> {mail});

    }
}
