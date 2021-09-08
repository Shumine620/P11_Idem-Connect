@isTest
public class CheckAccountActivationBoxTest {
    
    @TestSetup
    static void setup(){
        Account account = testDataFactory.createAccount('AccountTest'); 
        Product2 product2 = TestDataFactory.createProduct();
        PricebookEntry priceBookEntry = TestDataFactory.createPriceBookEntry(product2.Id, 100);
        Contract contract = TestDataFactory.createContract(account.Id);  
        Order order = testDataFactory.createOrder(account.Id, contract.Id);     
    }
    //Checking that an account with an order will have the Active box checked   
    @isTest 
    static void testChekAccountWithOrder() {
        
        List<Order> orders = [SELECT Id, Status, AccountId FROM Order];
        
        List<Account> accounts = [SELECT Id, Active__c
                                  FROM Account WHERE Name LIKE 'AccountTest'];
        
        Test.startTest();
        CheckOrderAndAccountStatus.checkActiveBox(orders);
        Test.stopTest();
        
        for (Account acc1 : accounts){
            system.assertEquals(1, orders.size());
            System.AssertEquals(True, acc1.Active__c);
        }
    }  
}