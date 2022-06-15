
## Serverless Student Portal with Terraform

This project deploys the backend of student-portal with Terraform.

*Total Resources: 24*

---

# Student Portal

  
  
  

## Features

  

- Allow Super Admin User to log in

  

- Allow Super Admin User to create Faculty Users

  

- Allow Faculty Users to create other Faculty Users

  

- Allow Faculty Users to create Student User Account with Department and Class No.

  

- Allow Faculty Users to update Student User Account with Class No

  

- Allow Students to log in and check their current Department and Class No

  

- Allow Faculty Users to Add/Edit Student detail with “key/value” like combinations

  

- For example, they can set these detail

- Key: “Semester 1 Result”, Value: JSON object data

- Key: “Year 1 Report”, Value: JSON object data

- Key: “Workshop ABC Report” Value: JSON object data

  

- Students can log in and check all the detail created for their user and view the UI

  

- Students CAN ONLY VIEW the detail, they can not modify the data

  

- Faculty members can ADD/UPDATE/VIEW detail for any student based on the Student ID or Email address

  
  

## AWS Services

  

- Amazon Cognito

  

- To create user accounts with Cognito Group assignment

  

- Amazon Lambda

  

- To run the NodeJS code to interact with DynamoDB

  

- Amazon DynamoDB

  

- To save the Student detail

  

- AWS S3

  

- To host the UI for interacting with the system