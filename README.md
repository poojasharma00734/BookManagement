# Billie Take Home Assignment:
## Description

## 1. Implement a schedulable apex class that makes a callout to the https://eoheai3ashoyzos.m.pipedream.net endpoint. As a result it should publish a platform event MostPublishedBooks__e containing a list of books sorted by the edition (the number of copies published), from highest to lowest, where the edition size exceeds 600,000 copies.
   For this usecase a schedule class has been developed - `FetchMostPublishedBooksJob.cls` which needs to be scheduled and there could be multiple option to schedule it daily , hourly or every 10 mins to get the response from the given end point.
   
   

## 2. Implement a LWC which subscribes to the MostPublishedBooks__e event with lightning/empApi and displays the list of books in a user-friendly format.
   LWC component has been developed - `mostPublishedBooks` which showing the subscription of published event in a User friendly format , currently its placed on the home page of a Lightning app named `Book Management` created for this use case.


## Expected output

# - Github repository containing all the developed components

Repository link - https://github.com/poojasharma00734/BookManagement/tree/main
Component List
| Component Name  | Type | Description |
| ------------- | ------------- | ------------- |
| FetchMostPublishedBooksJob  | Apex Class  | To schedule the the end point callout and publish the platform event  |
| ScheduledCalloutTest.cls  | Apex Test Class  | To cover the unit test cases  |
| mostPublishedBooks  | LWC  | To display the subscribed event in a user friendly format  |
| APIConfiguration__c  | Custom setting  | To store the end point to avoid hard coding the end point in Class as a best practing, in future this could be used to store Sandbox and production endpoints segregation and use in class to avoid Manual steps of changing endpoints |
| MostPublishedBooks__e  | Platform Event  | Contains fields provided in the end point response  |
| Book Management  | Lightning App  | App the place the LWC component to displays the list of books   |
  
# - Unit tests for the most critical functionality
All the unit tests cases are covered in `ScheduledCalloutTest.cls` including positive and negative scenarios

# - Instructions on how to deploy the solution into a scratch org or, ideally, how to create an
unlocked package and install it into a scratch org
Assumptions : VS code is already installed with SFDX and Salesforce CLI 

## Step 1: Clone this repository to your local when you want to push the source code 
git clone https://github.com/poojasharma00734/BookManagement
The git clone command creates the BookManagement folder using the Salesforce DX project structure, and contains a DX project file and a scratch org definition file.

<img width="351" alt="Screenshot 2024-12-06 at 12 28 20" src="https://github.com/user-attachments/assets/a8c47695-dc43-43a4-9481-f785fdbae543">


## Step 2 : To To create a package and to use the scratch org in the Org enter Dev Hub in the Quick Find box and select Dev Hub.
<img width="1153" alt="Screenshot 2024-12-06 at 12 19 45" src="https://github.com/user-attachments/assets/1e889f63-4d40-4e89-a8d8-9489ae0d19af">

## Step 3 : Select Enable Unlocked Packages and Second-Generation Managed Packages
<img width="1154" alt="Screenshot 2024-12-06 at 12 20 19" src="https://github.com/user-attachments/assets/d9b34d0d-9c28-45a3-bce4-3e8eca8eaa1b">

## Step 4: we need to first authorize to your Dev Hub org, and log in to it.
sf org login web --set-default-dev-hub --alias DevHub

## Step 5: Create an unlocked package without a namespace
sf package create --name Assignment --description "My Package" --package-type Unlocked --path force-app --no-namespace --target-dev-hub DevHub

--name is the package name. This name is an alias you can use when running subsequent packaging commands.
--path is the directory that contains the contents of the package.
--packagetype indicates which kind of package you’re creating, in this case, unlocked.

## Step 6: Open sfdx-project.json to verify the package created , you can see the package name that you defined, with placeholders for the version name and version number. The command also creates a packageAliases section, which maps the package name (Assignment) to its corresponding package ID (0HodM0000000aoHSAQ)

<img width="570" alt="Screenshot 2024-12-06 at 12 43 58" src="https://github.com/user-attachments/assets/4817830d-19bf-4be2-90e8-e0cf328e4fd1">

## Step 7: Create Scratch org to test your package version

sf org create scratch --definition-file config/project-scratch-def.json --duration-days 30 --alias AssignmentOrg --target-dev-hub DevHub

## Step 8: Create the Package Version and Install It in Your Scratch Org
   1. Open the sfdx-project.json to update the package version options
   2. Change the versionName to Version 1.0, and the versionNumber to 1.0.0.NEXT , once updated it would look like this 
        <img width="577" alt="Screenshot 2024-12-06 at 12 49 03" src="https://github.com/user-attachments/assets/af07e4ed-43a3-4f6e-a6a3-a1330bba983d">

Run this command to create package version : sf package version create --package dreamhouse --installation-key test1234 --wait 10 --target-dev-hub DevHub
you might see an error
Error (1): The sfdx-project.json file must include one, and only one, default package directory (path). Because your sfdx-project.json file contains only one package directory, it must be the default. Remove the `"default": false` key and try again.

If yes remove the `"default": false` and run the command again.

On Success a message will show "Successfully created the package version"

<img width="981" alt="Screenshot 2024-12-06 at 12 54 03" src="https://github.com/user-attachments/assets/694ad209-7649-436c-8866-a57f794dd6b5">


## Steps 9: Notice that the packageAliases section in sfdx-project.json has a new entry. Use the package version alias to install the package in scratch org

sf package install --wait 10 --publish-wait 10 --package Assignment@1.0.0-1 --installation-key test1234 --no-prompt --target-org AssignmentOrg

Step 10: Once the package is installed you can open the scratch org

sf org open --target-org AssignmentOrg

<img width="1182" alt="Screenshot 2024-12-06 at 12 59 06" src="https://github.com/user-attachments/assets/00374c05-db48-41ae-925f-ee63c4e1ce40">



## - Instructions on how to perform end-to-end testing in the scratch org
  
1. To perform the end-to-end testing , Open the app launcher and select the Book Management App , then go to Home tab the LWC component is placed on the Home tab which will display the list of books , intialy it will show 'No books available' as there is no event published yet.
2. To publish the event the class needs to be scheduled with the cron expression or schedule class option and to run it instantly for test go to developer console and run the piece of code -> open the execute anaonymous window and paste this code "new FetchMostPublishedBooksJob().execute(null);" and click on execute.
3. This will execute the schedule class instantly and publish the platform event.
4. Once the event is published the results will be displayed on the home page in real time , keep the Home page open in a separate tab to see the real time results.

## Considerations: 
1. As the schedule frequency is not defined , it can be run every 10 mins , every hour , every day
2. Ephemeral Nature of Platform Events:
   a. Real-time Streaming: Platform events are designed for real-time, transient communication. They are not stored for long-term access. Once an event is published and delivered to active subscribers, it's not retained indefinitely.
   b. No Automatic Persistence: If the LWC is refreshed or the subscription is interrupted, previously published events that occurred before the subscription was re-established are not retained or replayed.
3. To solve this problem
   a. Store Platform Event Data in a Salesforce Object : When the Platform Event is published, also store its data in a custom Salesforce object. LWC can then query this object to retrieve the data whenever needed, even after a page refresh.
   b. Use Replay IDs to Fetch Missed Events : Replay IDs allow you to replay missed events within Salesforce's 24-hour retention period (72 hours for retention period). Store the last processed Replay ID in a persistent store (e.g., Custom Metadata or Custom Settings). On page refresh, pass this Replay ID to the EMP API in LWC.
   c. Persist Data in Browser Storage : If the data does not need to be stored permanently in Salesforce, you can temporarily persist it in the browser using Local Storage or Session Storage.

## Best Practices
1. Real-time + Persistent Data: Use Platform Events for real-time updates and store critical event data in Salesforce for persistence.
2. Data Cleanup: Schedule jobs to archive or delete stale event data from the custom object.
3. Avoid Duplication: Ensure events are processed and stored only once by checking for existing records or using unique identifiers.





