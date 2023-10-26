# Area
Automation platform of their digital life

## Project
The goal of the project Area is to reproduce a similar website as [IFTTT](https://ifttt.com/) or [Zapier](https://zapier.com/).
You must have [AREAs](#Areas) composed of [Actions](#Actions) and [REActions](#reactions).

The project is divided into 3 parts:
* [Application Server](#API) to implement the features
* [Web client](#web) to use from browser
* [Mobile client](#mobile) to use from phone application

The *Web* and *Mobile* clients must only serve as an user interface, and redirect request from/to App server.

## API
The Application Server (or API) has the following functionnalities:
* Register user on the app to obtain an account
* Confirm their enrollement before being able to use it (via email)
* User can subscribe to [Services](#Services)
* A services has:
  * [Actions](#Actions)
  * [Reactions](#Reactions)
* Compose Areas by merging an Action with Reaction·s

## Clients

### Web

### Mobile

## Authors
* [Luka Camus](https://github.com/Lukacms)
* [Louis Bassagal](https://github.com/LouisBassagal)
* [Samuel Florentin](https://github.com/SamuelFlorentin)
* [Elliot Janvier](https://github.com/eljanvier2)
* [Guillaume Lebreton](https://github.com/Lebonvieuxgui)
