/**
* Batch locating accounts without tasks and launching reminder calls
**/
global with sharing class BatchTasksOnAccounts implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext info) {
        //Select all the accounts with a task 'Call 
        return Database.getQueryLocator('SELECT OwnerId, (SELECT Id FROM Orders), (SELECT Id FROM Tasks WHERE Subject=\'Call\') FROM Account');
    }
    
    global void execute(Database.BatchableContext info, List<Account> scope) {
        
        List<Task> tasks =new List<Task>();
        // Create the Task's reminder for the accounts without orders
        for(Account account: scope){
            if(account.Tasks.isEmpty() && account.Orders.isEmpty()) {
                Task task = new Task();
                task.Subject = 'Call';
                task.Status = 'New';
                task.Priority = 'Normal';
                task.WhatId = account.Id;
                task.OwnerId = account.OwnerId;
                task.IsReminderSet = true;
                task.ReminderDateTime = System.today() + 5;
                tasks.add(task);
            }
        }
        if(tasks.size()>0){
            insert tasks;
        }
    }                 
    global void finish(Database.BatchableContext info) {  
    }
}