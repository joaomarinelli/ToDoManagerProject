/* public with sharing class AtualizarEnderecoAccountController {
    
    @AuraEnabled(cacheable=true)
    public static void atualizarEndereco(String cep) {
        // constrói a URL da API do ViaCEP usando o CEP fornecido
        String url = 'https://viacep.com.br/ws/' + cep + '/json/';

        // faz a chamada HTTP GET para a API do ViaCEP
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        // verifica se a chamada foi bem-sucedida e se obteve um endereço válido
        if (response.getStatusCode() == 200) {
            String json = response.getBody();
            Map<String, Object> endereco = (Map<String, Object>) JSON.deserializeUntyped(json);
            if (!endereco.containsKey('erro')) {
                // atualiza os campos de logradouro e cidade da Account atual
                Account conta = [SELECT Id, CEP__c, Logradouro__c, Cidade__c FROM Account WHERE CEP__c = :cep LIMIT 1];
                conta.Logradouro__c = (String) endereco.get('logradouro');
                conta.Cidade__c = (String) endereco.get('localidade');
                update conta;
            }
        }
    }
}
 */