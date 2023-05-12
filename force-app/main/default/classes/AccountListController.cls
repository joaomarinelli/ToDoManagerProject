public with sharing class AccountListController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(){
        return [SELECT Id, Name, Description, Website FROM Account ORDER BY Name];
    }
}