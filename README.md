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

## Dependencies
- Firebase Auth
- Firebase Realtime database
- DropDown
- Mapkit

## New Feature to be added
- Allow user upload profile picture
- Auto select the pick/return due date based on different store's return policy
- Add the function to show the completed pickup/return
- Allow user select notification frequency (Hourly, Daily, Weekly, etc.)
