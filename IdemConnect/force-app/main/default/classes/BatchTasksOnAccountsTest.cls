/**
* @Description : Apex class to test the batch execution. Verify that a task is created
*/
@isTest
public class BatchTasksOnAccountsTest {
    
    //Set up the data from TestDataFactory class accounts created without tasks
    @TestSetup
    static void setup(){
        
        List<Account> accounts = TestDataFactory.createAccounts(150);
    }
    
    @isTest
    static void TestCheckAccountRelatedList(){
        List<Task> task = new List <Task>();
        
        Test.startTest();
        BatchTasksOnAccounts batchOnTask = new BatchTasksOnAccounts();
        Id batchId = Database.executeBatch(batchOnTask);
        Test.stopTest();
        
        task = [SELECT Id FROM Task WHERE Subject='Call' AND OwnerId IN (SELECT Id FROM User WHERE isActive=true)];
        
        //Verifiying that the number of tasks created through the batch are the same of the number of accounts without tasks     
        System.assertEquals(150, task.size());   
    }
}