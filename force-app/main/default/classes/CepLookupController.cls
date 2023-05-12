public with sharing class CepLookupController {
    @AuraEnabled(cacheable=true)
    public static ViaCepResponse getCep(String cep) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://viacep.com.br/ws/' + cep + '/json/');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        System.debug('WISERLOG: ' + response);
        if (response.getStatusCode() == 200) {
            ViaCepResponse result = (ViaCepResponse) JSON.deserialize(response.getBody(), ViaCepResponse.class);
            return result;
        } else {
            return null;
        }
    }

    public class ViaCepResponse {
        public String logradouro;
        public String bairro;
        public String localidade;
        public String uf;
    }
}
