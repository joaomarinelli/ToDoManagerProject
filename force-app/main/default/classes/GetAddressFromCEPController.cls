public with sharing class GetAddressFromCEPController {
    @AuraEnabled(cacheable=true)
    public static String getAddressFromCEP(String cep) {
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setEndpoint('https://viacep.com.br/ws/'+cep+'/json/');
      request.setMethod('GET');
      HttpResponse response = http.send(request);
      if (response.getStatusCode() == 200) {
        return response.getBody();
      }
      return null;
    }
  }
  