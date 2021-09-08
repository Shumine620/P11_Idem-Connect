@isTest
public with sharing class TestDataFactory {
    
    public static Account createAccount(String name) {
        Account account = new Account(Name = name);
        insert account;
        return account;
    }
    public static Contract createContract(Id accountId) {
        Contract contract = New Contract(AccountId= accountId,
                                         StartDate= System.today(),
                                         ContractTerm=12,
                                         Status='Draft',
                                         Name = 'contractTest');
        insert contract;
        contract.Status = 'Activated';
        update contract;
        return contract;
    }
    
    public static Product2 createProduct() {
        Product2 product = new Product2(
            IsActive =true,
            Name = 'ProductTest'
        );
        insert product;
        return product;
    }
    
    public static PricebookEntry createPricebookEntry(Id productId, Decimal amount) {
        PricebookEntry pricebookEntry = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = productId,
            UnitPrice = amount,
            IsActive = false
        );
        insert priceBookEntry;
        return priceBookEntry;     
    }
    
    public static Order createOrder(Id accountId, Id contractId){
        
        Order order = New Order (
            AccountId = accountId,
            ContractId = contractId,
            Status ='Draft',
            EffectiveDate = Date.today(),
            Pricebook2Id = Test.getStandardPricebookId()
        );       
        insert order;
        return order;   
    }  
    //Methode to create One account with several orders
    public static List<Order> createAccountWithOrders(Integer numberOrders, Id accountId){
        
        List<Order> orders = new List<Order>();
        for(Integer i=0; i<numberOrders; i++) {
            Order order = new Order(
                AccountId = accountId,
                Pricebook2Id = Test.getStandardPricebookId(),
                status = 'draft',
                effectiveDate = Date.today()
            );
            orders.add(order);
        }
        insert orders;
        Product2 product2 = TestDataFactory.createProduct();
        PricebookEntry pricebookEntry = TestDataFactory.createPricebookEntry(product2.Id, 100);
        
        List<OrderItem> items = new List<OrderItem>();
        for(Order order: orders) {
            OrderItem item = new OrderItem (OrderId = order.Id, PricebookEntryId = pricebookEntry.Id, Quantity=1, UnitPrice = 100);
            items.add(item);
        }
        insert items;     
        
        update orders;
        return orders;
    }
    //Method to create a list of Accounts
    public static List<Account> createAccounts(Integer numberOfaccounts) {
        List<Account> accounts = new List<Account>();
        
        for (Integer i = 0 ; i < numberOfaccounts; i++) {
            Account accts = new Account(
                Name = 'AccountTest '+i
            );
            accounts.add(accts);
        }
        insert accounts;
        return accounts;
    }
}