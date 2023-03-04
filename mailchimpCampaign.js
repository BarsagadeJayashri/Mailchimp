import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import sendCampaign from '@salesforce/apex/MailchimpIntegration.sendcampaign';

export default class MailchimpCampaign extends LightningElement {
@track name;
@track subject;
@track html;

handlename(event) {
this.sendermail = event.target.value;
}
handlesubject(event) {
this.subject = event.target.value;
}
handlehtml(event) {
this.html = event.target.value;
}
handleClick(event){
sendCampaign({ senderEmail: this.sendermail, subject: this.subject, html: this.html })
    .then(result => {
        console.log(result);
        const toastEvent = new ShowToastEvent({
            title: 'Success',
            message: 'Email campaign sent successfully',
            variant: 'success'
            });
            this.dispatchEvent(toastEvent);
        
    })
    .catch(error => {
        console.error(error);
        const toastEvent = new ShowToastEvent({
            title: 'Error',
            message: 'Email campaign failed to send',
            variant: 'error'
            });
            this.dispatchEvent(toastEvent);
    
    });
}
}