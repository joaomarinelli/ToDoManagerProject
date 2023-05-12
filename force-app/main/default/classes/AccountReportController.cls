public with sharing class AccountReportController {

    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getCustomerPriority(){
        List<Map<String, String>> options = new List<Map<String, String>>();
        List<Schema.PicklistEntry> pickListValues = new Map<String,sObjectField>(Account.sObjectType.getDescribe().fields.getMap()).get('CustomerPriority__c').getDescribe().getPicklistValues();
        
        for(Schema.PicklistEntry pickListValuesAux : pickListValues){
            options.add(new Map<String,String>{
                'value' => pickListValuesAux.getLabel(),
                'label' => pickListValuesAux.getLabel()
            });
        }
        return options;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(Date startDate, Date endDate, String customerPriority) {
        if(customerPriority != null){
            List<Account> accounts = [SELECT Id, Name, CreatedDate FROM Account WHERE CreatedDate >= :startDate AND CreatedDate <= :endDate AND CustomerPriority__c = :customerPriority];
            return accounts;
        }else {
            List<Account> accounts = [SELECT Id, Name, CreatedDate FROM Account WHERE CreatedDate >= :startDate AND CreatedDate <= :endDate];
            return accounts;
        }
        
    }
    
}
