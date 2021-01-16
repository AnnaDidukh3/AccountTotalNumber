@isTest
private class AccountTotalNumberTest {
    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        // insert 10 accounts
        for (Integer i=0;i<10;i++) {
            accounts.add(new Account(name='Account '+i, totalNum__c = 10));
        }
        insert accounts;
    }
    @isTest static void test() {
        Test.startTest();
        AccountTotalNumber tn = new AccountTotalNumber();
        Id batchId = Database.executeBatch(tn);
        Test.stopTest();
    }
}