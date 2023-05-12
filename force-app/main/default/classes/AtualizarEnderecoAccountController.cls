public with sharing class AtualizarEnderecoAccountController {
    @AuraEnabled(cacheable=true)
    public static String getEndereco(String cep) {
        String url = 'https://viacep.com.br/ws/' + cep + '/json/';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        System.debug('WISERLOG: ' + response);
        System.debug('WISERLOG: ' + response.getBody());
        return response.getBody();
    }

/*     @AuraEnabled
    public static void atualizarEndereco(Id accountId, String logradouro, String cidade) {
        // atualiza os campos de endereço na conta
        Account account = new Account(Id=accountId);
        account.CEP_Logradouro__c = logradouro;
        account.CEP_localidade__c = cidade;
        System.debug('WISERLOG Account updated');
        update account;
    } */
}
