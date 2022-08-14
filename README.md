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
User can Sign Up an account and Sign In to the dashboard, user is able to reset the password if can't remember the password. This is realized by using Firebase Auth API. After the user signed up an account, it will save the user's name and email to Firebase Realtime Database to create an entry for the user.

![SignUp](/Neverforget/sc/signup.gif)

![SignIn](/Neverforget/sc/forgotpwsignin.gif)

After user signed in, it will be redirected to the dashboard where you can see the list of added pickup/return entries divided by sections. User is also able to add new entry by click on the + icon. UserNotifications is used to setup the user reminder notifications. New pickup/return entry is saved to Firebase Realtime Database using Firebase Realtime Database. Each pickup/return entry is saved under the specific user's entry with timestamp as unique identification.

![Add entry and notification](/Neverforget/sc/addentryandnoti.gif)

By tap on each pickup/return entry user is able to see the detailed information. User is able to modify all the information for the entry. Reminder notification is updated, other information are updated to Firebase Realtime Database by looking up the timestamp for that specific entry.

![Update entry](/Neverforget/sc/updateentry.gif)

On the dashboard user can swipe on an entry to delete an entry and it's reminder notification. The entry is deleted from Firebase Realtime Database by deleting the node.

![Delete entry](/Neverforget/sc/deleteentry.gif)

On add new entry or entry detail page, user can check store's return policy by choosing the store name from the drop down list. 

![Return Policy](/Neverforget/sc/checkreturnpolicy.gif)

By tapping on the map icon, user is able to search the nearby store locations and show them on the map. This is done by using the MapKit.

![Map](/Neverforget/sc/openmap.gif)

## New Feature to be added
- Allow user upload profile picture
- Auto select the pick/return due date based on different store's return policy
- Add the function to show the completed pickup/return
- Allow user select notification frequency (Hourly, Daily, Weekly, etc.)
