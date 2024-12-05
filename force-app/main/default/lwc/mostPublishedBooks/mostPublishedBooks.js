import { LightningElement, track } from 'lwc';
import { subscribe, unsubscribe } from 'lightning/empApi';

export default class MostPublishedBooks extends LightningElement {
    @track books = [];
    subscription = null;
    channelName = '/event/MostPublishedBooks__e';

    // Datatable columns
    columns = [
        { label: 'Author', fieldName: 'Author__c' },
        { label: 'Title', fieldName: 'Title__c' },
        { label: 'Edition Size', fieldName: 'EditionSize__c', type: 'number' }
    ];

    connectedCallback() {
        this.subscribeToPlatformEvent();
    }

    disconnectedCallback() {
        this.unsubscribeFromPlatformEvent();
    }

    subscribeToPlatformEvent() {
        const messageCallback = (response) => {
            const eventData = response.data.payload;
            // Add the event data to the books array
            this.books = [...this.books, {
                Author__c: eventData.Author__c,
                Title__c: eventData.Title__c,
                EditionSize__c: eventData.EditionSize__c
                
            }];
        };

        // Subscribe to the platform event channel
        subscribe(this.channelName, -1, messageCallback).then((response) => {
            console.log('Subscription successful: ', response);
            this.subscription = response;
        }).catch((error) => {
            console.error('Subscription error: ', error);
        });
    }

    unsubscribeFromPlatformEvent() {
        if (this.subscription) {
            unsubscribe(this.subscription).then(() => {
                console.log('Unsubscribed successfully');
                this.subscription = null;
            }).catch((error) => {
                console.error('Unsubscribe error: ', error);
            });
        }
    }
}