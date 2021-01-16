global class AccountTotalNumber implements Database.batchable<Sobject>, Database.Stateful{
	public Integer recordsProcessed = 0;
	List<Account> listAccounts = new List<Account>();
	global Database.QueryLocator start(Database.BatchableContext bc){
		String query = 'Select id,Name,TotalNum__c from Account';
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext bc, List<SObject> scope){
		for (Account tn : (Account[])scope){
			tn.TotalNum__c = scope.size();
			listAccounts.add(tn);
			recordsProcessed = recordsProcessed + 1;
		}
	}

	global void finish(Database.BatchableContext bc){
		if (!listAccounts.isEmpty()){
			update listAccounts;
			System.debug(recordsProcessed + ' records processed. Shazam!');
        		AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
           				    FROM AsyncApexJob
          				    WHERE Id = :bc.getJobId()];
        		// call some utility to send email
        		EmailUtils.sendMessage(job, recordsProcessed);
		}
	}
}
