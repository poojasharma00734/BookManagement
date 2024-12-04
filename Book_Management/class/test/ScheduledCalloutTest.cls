@IsTest
public class ScheduledCalloutTest {
    @IsTest
    static void testExecute() {
        // Setup custom setting
        APIConfiguration__c config = new APIConfiguration__c();
        config.API_Endpoint__c = 'https://eoheai3ashoyzos.m.pipedream.net';
        insert config;
        
        // Mock the HTTP callout
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Execute the schedulable class
        FetchMostPublishedBooksJob callout = new FetchMostPublishedBooksJob();
        String cronExp = '0 0 12 * * ?'; // Example Cron Expression
        System.schedule('Test Schedule', cronExp, callout);
        
        Test.stopTest();
    }
    @IsTest
    static void testExecuteWithoutEndpoint() {
        // Setup custom setting
        APIConfiguration__c config = new APIConfiguration__c();
        config.API_Endpoint__c = '';
        insert config;
        
        // Mock the HTTP callout
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Execute the schedulable class
        FetchMostPublishedBooksJob callout = new FetchMostPublishedBooksJob();
        String cronExp = '0 0 12 * * ?'; // Example Cron Expression
        System.schedule('Test Schedule', cronExp, callout);
        
        Test.stopTest();
    }
    @IsTest
    static void testExecuteException() {
        // Setup custom setting
        APIConfiguration__c config = new APIConfiguration__c();
        config.API_Endpoint__c = 'https://eoheai3ashoyzos.m.pipedream.net';
        insert config;
        
        // Mock the HTTP callout
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpBadResponseGenerator());
        
        // Execute the schedulable class
        FetchMostPublishedBooksJob callout = new FetchMostPublishedBooksJob();
        String cronExp = '0 0 12 * * ?'; // Example Cron Expression
        System.schedule('Test Schedule', cronExp, callout);
        
        Test.stopTest();
    }
    
    @IsTest
    static void testExecuteEqualEditions() {
        // Setup custom setting
        APIConfiguration__c config = new APIConfiguration__c();
        config.API_Endpoint__c = 'https://eoheai3ashoyzos.m.pipedream.net';
        insert config;
        
        // Mock the HTTP callout
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpBadResponseGenerator());
        
        // Execute the schedulable class
        FetchMostPublishedBooksJob callout = new FetchMostPublishedBooksJob();
        String cronExp = '0 0 12 * * ?'; // Example Cron Expression
        System.schedule('Test Schedule', cronExp, callout);
        
        Test.stopTest();
    }
    
    // Mock HttpCallout
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('[{"Publisher":"Manning Publications","Books":[{"Author":"Eric Freeman","Title":"Sample Book","Edition":1000000},{"Author":"David Flanagan","Title":"JavaScript: The Definitive Guide","Edition":1100000}]}]');
            return res;
        }
    }
    
    // Mock HttpCallout
    private class MockHttpBadResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('[{"Author":"Eric Freeman","Title":"Sample Book","Edition":1000000},{"Author":"David Flanagan","Title":"JavaScript: The Definitive Guide","Edition":1100000}]');
            return res;
        }
    }
     // Mock HttpCallout
    private class MockHttpEqualEditionResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('[{"Publisher":"Manning Publications","Books":[{"Author":"Eric Freeman","Title":"Sample Book","Edition":1000000},{"Author":"David Flanagan","Title":"JavaScript: The Definitive Guide","Edition":1000000}]}]');
            return res;
        }
    }
}