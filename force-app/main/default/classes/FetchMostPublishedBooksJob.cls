global class FetchMostPublishedBooksJob implements Schedulable {
    global void execute(SchedulableContext sc) {
        // Schedule class should delegate callout logic to a future method for async processing
        processBooks();
    }

    /**
     * Processes books by making an HTTP callout and publishing platform events.
     */
    @Future(callout = true)
    private static void processBooks() {
        // as an example we can Fetch endpoint from custom setting but to avoid the post deployment steps commented for now
        /* APIConfiguration__c config = APIConfiguration__c.getInstance();

        if (config == null || String.isBlank(config.API_Endpoint__c)) {
            logError('Custom setting or endpoint is not configured properly.');
            return;
        }

        String endpoint = config.API_Endpoint__c; */

        try {
            // Perform HTTP callout
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://eoheai3ashoyzos.m.pipedream.net');
            request.setMethod('GET');
            HttpResponse response = http.send(request);

            // Process the response
            if (response.getStatusCode() == 200) {
                List<Publisher> publishers = (List<Publisher>) JSON.deserialize(response.getBody(), List<Publisher>.class);
                if (publishers == null || publishers.isEmpty()) {
                    logError('No publishers found in response.');
                    return;
                }

                // Collect, filter, and sort books
                List<Book> filteredBooks = new List<Book>();
                for (Publisher publisher : publishers) {
                    for (Book book : publisher.Books) {
                        if (book.Edition > 600000) {
                            filteredBooks.add(book);
                        }
                    }
                }

                if (filteredBooks.isEmpty()) {
                    logError('No books found with Edition > 600,000.');
                    return;
                }

                // Sort books by descending edition size
                filteredBooks.sort(new DescendingEditionSizeComparator());

                // Publish platform events
                for (Book book : filteredBooks) {
                    MostPublishedBooks__e event = new MostPublishedBooks__e(
                        Author__c = book.Author,
                        Title__c = book.Title,
                        EditionSize__c = book.Edition
                    );
                    EventBus.publish(event);
                }
            } else {
                logError('Failed to fetch data. HTTP Status: ' + response.getStatusCode());
            }
        } catch (Exception ex) {
            logError('Error during HTTP callout: ' + ex.getMessage());
        }
    }

    /**
     * Helper method to log errors for debugging purposes.
     */
    private static void logError(String errorMessage) {
        System.debug('FetchMostPublishedBooksJob Error: ' + errorMessage);
        // Optionally, we can use a custom object or platform events for error logging
    }

    /**
     * Represents the structure of a publisher from the API response.
     */
    public class Publisher {
        public String Publisher;
        public List<Book> Books;
    }

    /**
     * Represents the structure of a book from the API response.
     */
    public class Book {
        public String Author;
        public String Title;
        public Integer Edition;
    }

    /**
     * Comparator class for sorting books by descending edition size.
     */
    public class DescendingEditionSizeComparator implements Comparator<Book> {
        public Integer compare(Object o1, Object o2) {
            Book book1 = (Book) o1;
            Book book2 = (Book) o2;

            // Compare by Edition size in descending order
            if (book1.Edition > book2.Edition) {
                return -1; // book1 should come before book2
            } else if (book1.Edition < book2.Edition) {
                return 1; // book1 should come after book2
            } else {
                return 0; // both are equal
            }
        }
    }
}