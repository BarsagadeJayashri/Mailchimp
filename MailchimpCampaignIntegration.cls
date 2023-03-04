public class MailchimpIntegration {
    @AuraEnabled
    public static void sendcampaign(String senderEmail, String subject, String html) {
        String apiKey = 'YOUR_MAILCHIMP_API_KEY';
        String listId = 'YOUR_MAILCHIMP_LIST_ID';
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://us13.api.mailchimp.com/3.0/campaigns');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'apikey ' + apiKey);
        
        String jsonBody = '{"recipients":{"list_id":"' + listId + '"},'
            + '"type":"regular",'
            + '"settings":{'
            + '"subject_line":"' + subject + '",'
            + '"from_name":"KAJAL",'
            + '"reply_to":"' + senderEmail + '",'
            + '"html":"' + html + '"'
            + '}'
            + '}';
        
        request.setBody(jsonBody);
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() != 200) {
            throw new AuraHandledException(response.getStatus() + ' - ' + response.getBody());
        }
    }
}