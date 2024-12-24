# store_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
# store_app


# Node code
As after creating the node code in the project
Api's are created in the auth.js where we have created the sign-in and sign-up which we will connect with the flutter code

# Connecting of API 

1. As to connect create the similar file for the user information as created in the node.
2. put in the detail as having the user information as also add the information from the DB
3. Do mapping of the user information
4. convert the map to json string using the json.encode()
     As to convert it import the 'dart:convert'
     As converting to the json.encode() means serialization of the information that is to be used or taken from the user to send it to the DB for checking it.

5. After serialization of the data deserialization is also important
     As this is important to convert the string to the User object
     As mapping with in the object can be done easily
     or want to display the data for the ui
6. AS after the deserialization we have to take the information from the factory and the convert it to the map then user objects

7. To connect the node and flutter we have to add the http with 'dart pub add http' 