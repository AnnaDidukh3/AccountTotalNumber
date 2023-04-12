global class AccountTotalNumber implements Database.Batchable<SObject>, Database.Stateful {
	private final static Integer recordsProcessed = 0;
	
	List<Account> accounts = new List<Account>();
	
	global Database.QueryLocator start(Database.BatchableContext bc) {
		String query = [SELECT Id, Name, TotalNum__c FROM Account];
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext bc, List<SObject> scope) {
		for (Account account : (Account[])scope) {
			account.TotalNum__c = scope.size();
			accounts.add(account);
			recordsProcessed = recordsProcessed + 1;
		}
	}

	global void finish(Database.BatchableContext bc) {
		update accounts;
		AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
				    FROM AsyncApexJob
				    WHERE Id = :bc.getJobId()];
		EmailUtils.sendMessage(job, recordsProcessed);
	}
}
