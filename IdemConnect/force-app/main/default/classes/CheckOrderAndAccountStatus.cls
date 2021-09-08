/** 
* Class checking the status of orders and accounts before updates 
**/
public with sharing class CheckOrderAndAccountStatus {
    
    //Check that there are products on the order
    public static void checkItemsOnOrders(List<Order> orders){
        
        for (Order ord : orders){
            List <OrderItem> items = [SELECT Id FROM OrderItem WHERE orderId = :ord.Id]; 
            if(ord.Status =='Activated' && items != null && items.isEmpty()){
                ord.addError('A product is required to activate the order');
            } 
        } 
    }
    //Remove the tick from the active box when orders are deleted   
    public static void unCheckActiveBox(List <Order> deletedOrders) {
        List<Account> accounts = new List<Account>();
        
        Set<Id> accIds=new Set<Id>();
        for(Order ord :deletedOrders){
            accIds.add(ord.AccountId);
            
            accounts =[SELECT Id, Active__c FROM Account WHERE Id IN :accIds]; 
            for (Account acc : accounts){
                List<Order> orders = [ SELECT Id FROM Order WHERE AccountId = :accIds];
                if (orders.size() == 0){
                    acc.Active__c = false;
                }
            }
        }
        update accounts;
    } 
    //Add the tick to the active box when accounts have orders
    public static void checkActiveBox (List<Order> ordersToCheck){
        List<Account> accounts = new List<Account>();
        
        Set<Id> accIds=new Set<Id>();
        for(Order ord :ordersToCheck){
            accIds.add(ord.AccountId);
            
            accounts =[SELECT Id, Active__c FROM Account WHERE Id IN :accIds]; 
            for (Account acc : accounts){
                List<Order> orders = [ SELECT Id FROM Order WHERE AccountId = :accIds];
                if (orders.size() != 0){
                    acc.Active__c = true;
                }  
            }
        }
        update accounts;
    } 
}