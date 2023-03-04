Mailchimp-Integration-with-Salesforce:

This repository contains a solution for integrating Salesforce with the Mailchimp. The solution allows Salesforce users to send email to the Mailchimp contacts from Salesforce by creating their own template.


Pre-requisites:

1. Before using this solution, you need to have an API key and listId from Mailchimp (signup on https://login.mailchimp.com to get API key and listId).
2. A Salesforce account with access to the Contact object.
3. A Mailchimp account with the API access enabled.


Features:

The solution is designed for the following processes:
1. To mark the contacts from Salesforce as subscribed or unsubscribed in Mailchimp and send the mail to the subscribed contacts.
2. Once a contact is unsubscribed you won't be able to make it subscribed but once a contact is subscribed you can make it unsubscribe.
3. Create a campaign in Mailchimp from Salesforce (Also provided the front-end to create it).

