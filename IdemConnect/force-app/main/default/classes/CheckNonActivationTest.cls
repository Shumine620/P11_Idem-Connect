@isTest
public class CheckNonActivationTest {
    
    @TestSetup
    static void setup(){
        Account acc = TestDataFactory.createAccount('AccountTest');
        List <Order> ordersList = TestDataFactory.createAccountWithOrders(10, acc.Id);
    }
    @isTest
    static void testDeleteSeveralOrders(){
        Account  account = [SELECT Id, Active__c FROM Account WHERE Name LIKE 'AccountTest'];
        List <Order> orders = [SELECT AccountId FROM Order WHERE Account.Id = :account.Id ];
        //Delete all orders from the account
        Test.startTest();
        delete (orders);
        
        Account accVoid = [SELECT Id, Active__c  FROM Account WHERE Name = 'AccountTest'];
        Test.stopTest();
        
        System.assertEquals(False, accVoid.Active__c);
    }
    @isTest
    static void testDeleteFewOrders(){
        Account  account = [SELECT Id, Active__c FROM Account WHERE Name LIKE 'AccountTest'];
        List <Order> orders = [SELECT AccountId FROM Order WHERE Account.Id = :account.Id ];
        
        //Delete some orders from the account
        Test.startTest();
        orders.remove(5);
        orders.remove(8);
        
        Account newAcc = [SELECT Id, Active__c  FROM Account WHERE Name = 'AccountTest'];
        
        Test.stopTest();
        
        system.assertEquals(8, orders.size());
        System.assertEquals(True, newAcc.Active__c);
    }
}