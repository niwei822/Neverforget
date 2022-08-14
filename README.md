# Neverforget
## An app that reminds customers about their in-store pickups and tracks the return order due date.

## Background
As a customer who enjoys shopping, I sometimes forget to pick up the order and return the merchandise. To ensure that I don't miss the opportunity to pick up or return my order, I would like to be reminded of my in-store pickup and return due dates. Although there are many great reminder applications, not many are focused on improving the shopping trip experience. Developing this application was solely motivated by this purpose.

## Summary
Neverforget is an APP that the user can register an account, then login to the APP. In the dashboard, it will list all the return and pickup records that the user has added. The return/pickup details can be displayed by tapping each cell, and the record can be modified if needed. In addition, the user can add a new pickup or return record and choose when they want to be reminded. The user can delete records by swiping them. The user can view the store's return policy website by selecting a store from the drop-down list. Before picking up or returning the order, the user can search for the nearest store to find the location.

## Tech Stack
- Xcode
- Swift
- UIKit
- UIApplication
- UserNotifications
- Cocoapods
- Firebase Auth
- Firebase Realtime Database
- DropDown
- Mapkit

## Features
The user can Sign Up for an account and Sign In to the dashboard, and if the password is forgotten, the user can reset it. This is accomplished by using the Firebase Auth API. After the user signs up for an account, Firebase Realtime Database will store the user's name and email to create an account entry.

![SignUp](/Neverforget/sc/signup.gif)

![SignIn](/Neverforget/sc/forgotpwsignin.gif)

After the user signs in, he or she will be taken to the dashboard, where you can see the list of added pickup/return entries divided by sections. The user is also able to add a new entry by clicking on the + icon. UserNotifications are used for setting up reminders. Firebase Realtime Database saves pickup/return entries. Each pickup/return entry is stored under the specific user's access with a timestamp as unique identification.

![Add entry and notification](/Neverforget/sc/addentryandnoti.gif)

By tapping on each pickup/return entry, the user is able to see the detailed information. The user has the option of editing all information for the entry. Reminder notifications and other information are updated to Firebase Realtime Database by looking up the timestamp for that specific entry.

![Update entry](/Neverforget/sc/updateentry.gif)

On the dashboard, the user can swipe on an entry to delete it, as well as its reminder notification. The entry is removed from Firebase Realtime Database by deleting the node.

![Delete entry](/Neverforget/sc/deleteentry.gif)

By choosing the store name from the drop-down list, users can view the store's return policy on creating a new entry or entry detail page. 

![Return Policy](/Neverforget/sc/checkreturnpolicy.gif)

When the user taps on the map icon, nearby store locations are displayed on the map. Using MapKit, this is accomplished.

![Map](/Neverforget/sc/openmap.gif)

## New Feature to be added
- Allow user to upload a profile picture
- Auto select the pick/return due date based on different store's return policy
- Add the function to show the completed pickup/return
- Allow user select notification frequency (Hourly, Daily, Weekly, etc.)
