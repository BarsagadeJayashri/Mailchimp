trigger ContactCallout on Contact (after insert, after update) {
    
    if(Trigger.isAfter && Trigger.isInsert){
        MailChimpInt.subscribecontact(trigger.newmap.keyset());
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        MailChimpInt.statuschange(trigger.newmap.keyset());
    }
}
  



