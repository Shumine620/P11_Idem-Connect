trigger TriggerOnOrders on order (before Insert, before Update, after Delete, after Insert) {
    
    //Checking the related products on the order while changing the status
    if(Trigger.isUpdate) {
        CheckOrderAndAccountStatus.checkItemsOnOrders(Trigger.new);
        
    //Activate the account when an order is created    
    }if(Trigger.isInsert){
        CheckOrderAndAccountStatus.CheckActiveBox(Trigger.new);
    }
    //Desactivate the account when an order is deleted   
    if(Trigger.isDelete){
        CheckOrderAndAccountStatus.unCheckActiveBox(Trigger.old); 
    }      
}