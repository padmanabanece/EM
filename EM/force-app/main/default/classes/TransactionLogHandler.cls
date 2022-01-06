public with sharing class TransactionLogHandler {
    public static void doHandleException(System.Exception ex, String processName){

        Error_Log__c transactionLog = new Error_Log__c(
            Log_Details__c = ex.getStackTraceString() + '<br/><strong>message is</strong>'+ex.getMessage()
            + '</br>' + ex.getCause() + '</br>' + ex.getTypeName() + '</br>'  +
            ex.getLineNumber(),
            Lod_DateTime__c=System.now(),
            Process_Name__c=processName
            
         );
         if (Schema.SObjectType.Error_Log__c.isCreateable()) {
             insert transactionLog;
         }
    }
    public static void doHandleExceptionWithError(String errors, String processName){
        Error_Log__c transactionLog = new Error_Log__c(
            Log_Details__c = errors,
            Lod_DateTime__c=System.now(),
            Process_Name__c=processName
            
         );
         if (Schema.SObjectType.Error_Log__c.isCreateable()) {
            insert transactionLog;
        }
    }
}
