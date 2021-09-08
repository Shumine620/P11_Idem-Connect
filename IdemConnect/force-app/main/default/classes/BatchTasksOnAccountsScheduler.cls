/**
* Class scheduling the next reminder on accounts without tasks
**/
global without sharing class BatchTasksOnAccountsScheduler implements Schedulable{
    
    //Scheduler to be run on the 1st Monday of every months
    public static String CRON_EXP = '0 0 0 ? * 2#1 *';
    
    global void execute(SchedulableContext sc){
        
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger WHERE Id = :sc.getTriggerId()];
        
        //Action to be run with the batch with the related batch 
        BatchTasksOnAccounts batchTasks = new BatchTasksOnAccounts();
        database.executeBatch(batchTasks);
    }
}