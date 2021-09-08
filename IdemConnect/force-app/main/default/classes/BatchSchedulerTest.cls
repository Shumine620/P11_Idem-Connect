/**
* @Description : Class to test scheduler of the batch and the next running time of the BatchTasksOnAccounts class 
*/

@isTest
public with sharing class BatchSchedulerTest { 
    
    static testMethod void BatchTasksOnAccountsTest() {
        
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('testBasicScheduledApex', BatchTasksOnAccountsScheduler.CRON_EXP, 
                                       new BatchTasksOnAccountsScheduler());
        BatchTasksOnAccountsScheduler updateScheduler = new BatchTasksOnAccountsScheduler();
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                          NextFireTime FROM CronTrigger WHERE id = :jobId];
        
        System.assertEquals(BatchTasksOnAccountsScheduler.CRON_EXP,  ct.CronExpression);
        
        Test.stopTest();
    }
    
    static testMethod void nextTimeJobRunTest() {
        // This test runs a scheduled job for the 1st Monday of each month (04th Oct 2021).  
        Test.startTest();
        String jobId = System.schedule('testBasicScheduledApex', BatchTasksOnAccountsScheduler.CRON_EXP, 
                                       new BatchTasksOnAccountsScheduler());
        BatchTasksOnAccountsScheduler updateScheduler = new BatchTasksOnAccountsScheduler();
        
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                          NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals('2021-10-04 00:00:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();
    }
}