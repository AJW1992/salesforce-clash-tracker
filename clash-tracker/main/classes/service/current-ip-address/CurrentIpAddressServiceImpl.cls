public with sharing class CurrentIpAddressServiceImpl implements ICurrentIpAddressService {
    public String getIpAddress() {
        Http client = new Http();

        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Ip_Address');
        request.setMethod('GET');

        HttpResponse response = client.send(request);
        return response.getBody();
    }
}