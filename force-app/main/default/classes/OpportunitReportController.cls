public with sharing class OpportunitReportController {


    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunities(Date closeDate, String selectedAccount, String stage) {
        String query = 'SELECT Id, Name, CloseDate, StageName, Account.Name, Amount FROM Opportunity WHERE CloseDate = :closeDate';

        if (selectedAccount != null){
            query += ' AND AccountId = :selectedAccount ';
        }
        
        if(stage != null){
            query += ' AND StageName = :stage ';
        }
        
        List<Object> bindParams = new List<Object>{ closeDate };
        if (selectedAccount != null){
            bindParams.add(selectedAccount);
        }
        
        if(stage != null){
            bindParams.add(stage);
        }
        
        String formattedQuery = String.format(query, bindParams);
        List<Opportunity> opps = Database.query(formattedQuery);
        System.debug('LISTA:: ' + opps.size());

        return opps;
    }
    

    @AuraEnabled(cacheable=true)
    public static List<Map<String,String>> getStageOptions(){
        List<Map<String, String>> stages = new List<Map<String,String>>();
        List<Schema.PicklistEntry> pickListValues = new Map<String,SObjectField>(Opportunity.sObjectType.getDescribe().fields.getMap()).get('StageName').getDescribe().getPicklistValues();

        for(Schema.PicklistEntry pickListValuesAux : pickListValues){
            stages.add(new Map<String,String>{
                'value' => pickListValuesAux.getLabel(),
                'label' => pickListValuesAux.getLabel()
            });
        }
        return stages;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String,String>> getAccountOptions(){
        List<Map<String, String>> accounts = new List<Map<String,String>>();
        List<Schema.PicklistEntry> pickListValues = new Map<String,SObjectField>(Account.sObjectType.getDescribe().fields.getMap()).get('Name').getDescribe().getPicklistValues();

        for(Schema.PicklistEntry pickListValuesAux : pickListValues){
            accounts.add(new Map<String,String>{
                'value' => pickListValuesAux.getLabel(),
                'label' => pickListValuesAux.getLabel()
            });
        }
        return accounts;
    }
}