public class LocationTriggerHandler {
    @future(callout=true)
    public static void verifyAddress(String id){

        
        Location__c location=[SELECT Id,Postal_Code__c,State__c,City__c FROM Location__c
                                            WHERE Id=:id];

        String baseUrl='https://api.postalpincode.in/pincode/';
        String endpoint =baseUrl+location.Postal_Code__c;                                     

        HttpRequest httpReq = new HttpRequest();
        httpReq.setMethod('GET');
        httpReq.setEndpoint(endpoint);
        httpReq.setHeader('Content-Type', 'application/json');

        HttpResponse httpRes = new HttpResponse();

        Http http = new Http();
        try {
            httpRes= http.send(httpReq);
            System.debug(httpRes);
            if (httpRes.getStatusCode() == 200 && httpRes.getStatus()=='OK') {
                String responseBody = httpReq.getBody();
                JSONToPostOfficeRespApex objPO=  (JSONToPostOfficeRespApex) System.JSON.deserialize(responseBody, JSONToPostOfficeRespApex.class);                         
                List<JSONToPostOfficeRespApex.PostOffice> pO=objPO.PostOffice;
                System.debug(pO);
                for (JSONToPostOfficeRespApex.PostOffice variable : pO) {
                    if (location.Postal_Code__c==variable.PINCode && location.State__c==variable.State
                                 && location.City__c==variable.Circle ) {
                        location.Verified__c=true;
                    }else {
                        location.Verified__c=false;
                    }
                    update location;
                }
            }else {
                TransactionLogHandler.doHandleExceptionWithError(httpReq.getBody(), 'LocationTriggerHandler');
            }

        } catch (System.CalloutException ex) {
            TransactionLogHandler.doHandleException(ex, 'LocationTriggerHandler');
        }
       


    }
}
