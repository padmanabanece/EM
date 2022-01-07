@isTest
public  class EventAttendeeTriggerTest {

   @testSetup
   public static void setupData(){
       Event_Organizer__c org = new Event_Organizer__c(
           Name='Amit Singh',
           Phone__c='9888888888',
           Email__c='sfdcpanther@gmail.com.dev',
           Alternative_Email__c='sfdcpanther@gmail.com',
           Alternative_Phone__c='9777777777'
       );
        insert org;

        Event__c event = new Event__c(
            Name__c = 'Max Fit Campaign',
            Event_Organizer__c=org.Id,
            Event_Type__c='Virtual',
            Frequency__c='Weekly',
            Max_Seats__c=40,
            Recurring__c=true,
            Live__c=true,
            Start_DateTime__c=System.now(),
            End_Date_Time__c=System.now().addDays(3)

        );
        insert event;

        Attendee__c att = new Attendee__c(
            Name='Akash Jain',
            Email__c='akash.jain@gmail.com',
            Phone__c='9666666666'
        );
        insert att;

        Event_Attendee__c evtAtt = new Event_Attendee__c(
            Event__c=event.Id,
            Attendee__c=att.Id
        );
        insert evtAtt;
   }

   @isTest
   static  void sendEmailTest(){
    
   }
}
