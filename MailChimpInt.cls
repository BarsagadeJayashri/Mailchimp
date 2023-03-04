public class MailChimpInt {
    
    @future (callout=true)
    public static void subscribecontact(set<id>conList){
        system.debug(conList);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://us13.api.mailchimp.com/3.0/lists/{list_id}/members');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'apikey Your_API_key_here');
        Contact objCon = new Contact(); 
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for(contact con : [select Id,FirstName,LastName,Email,HasOptedOutOfEmail from Contact where Id IN: conList]){
            objCon.FirstName=con.FirstName;
            objCon.LastName=con.LastName;
            objCon.Email=con.Email;
            objCon.HasOptedOutOfEmail=con.HasOptedOutOfEmail;
            objCon.Id=con.Id;
            system.debug(objCon);
        }
        String jsonBody;
        if(objcon.HasOptedOutOfEmail){
            jsonBody = '{"email_address": "' + objCon.Email + '","status": "unsubscribed","merge_fields": {"FNAME": "' + objCon.FirstName + '","LNAME": "' + objCon.LastName + '"}}';
        }
        else{
            jsonBody = '{"email_address": "' + objCon.Email + '","status": "subscribed","merge_fields": {"FNAME": "' + objCon.FirstName + '","LNAME": "' + objCon.LastName + '"}}';
            
            EmailTemplate template = [SELECT Id, Subject, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'mailchimp'];
            
            
            string[] toAddresses = new string[]{objCon.Email};
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTemplateId(template.Id);
            email.setTargetObjectId(objCon.Id);
            email.setSaveAsActivity(false);
            email.setToAddresses(toAddresses);
            email.setTemplateID(template.Id);
            
            emails.add(email);
            
            
        }
        request.setBody(jsonBody);
        HttpResponse response = http.send(request);        
        System.debug('response '+response.getStatusCode());
        system.debug(response.getBody());
        
        if (emails.size() > 0) {
            List<Messaging.SendEmailResult>  results = Messaging.sendEmail(emails);
            system.debug('!@#$'+results);
        }
    }
    
    @future(callout=true)
    public static void statuschange(set<id>conList){
        Http http2 = new Http();
        
        Contact objCon2 = new Contact(); 
        for(contact con2 : [select FirstName,LastName,Email,HasOptedOutOfEmail from Contact where Id IN: conList]){
            objCon2.FirstName=con2.FirstName;
            objCon2.LastName=con2.LastName;
            objCon2.Email=con2.Email;
            objCon2.HasOptedOutOfEmail=con2.HasOptedOutOfEmail;
            system.debug(objCon2);
        }
        
        if ( objCon2 != null) {
            
            String email = objCon2.Email;
            Blob emailBlob = Blob.valueOf(email.toLowerCase());
            String subscriberHash = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', emailBlob));    	
            String endpoint = 'https://us13.api.mailchimp.com/3.0/lists/{list_id}/members/';
            
            HttpRequest request2 = new HttpRequest();
            request2.setEndpoint(endpoint + subscriberHash);
            request2.setMethod('PATCH');
            request2.setHeader('Content-Type', 'application/json');
            request2.setHeader('Authorization', 'apikey Your_API_key_here');
            
            
            String jsonBody2 = '';
            if (objCon2.HasOptedOutOfEmail) {
                jsonBody2 = '{"email_address": "' + objCon2.Email + '","status": "unsubscribed","merge_fields": {"FNAME": "' + objCon2.FirstName + '","LNAME": "' + objCon2.LastName + '"}}';
                
            }
            request2.setBody(jsonBody2);
            
            HttpResponse response2 = http2.send(request2);
            System.debug('response2 '+response2.getStatusCode());
            system.debug(response2.getBody());
        }
    }
}
    
    