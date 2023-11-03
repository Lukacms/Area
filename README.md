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

It's a C# dotnet application.

## Clients
Web and mobile clients. User interface and Experience.

### Web
React application only responsible for displaying screens and forwarding requests from user to API.

The user first connect (via google login or normal login); then is in the Home page to handle Areas.

Detailed documentation [here](./client_web) and screenshots [here](./docs/ScreenshotsWeb.md)

### Mobile
Flutter application available for iOS and Android.
More detailed documentation [here](./mobile) and screenshots [here](./docs/ScreenshotsMobile.md)

## Build
The application is build with [`docker`](https://docs.docker.com/), using a `docker-compose` file.

The files architectures look like this:
```
.
├── AREA_ReST_API
│   └── Dockerfile
├── client_web
│   └── Dockerfile
├── docker-compose.yml
├── docs
└── mobile
    └── Dockerfile
```
Each part has a Dockerfile that launch them on required configurations (back on port 8080, front-web on port 8081), and the docker-compose build them.
To build, you should use `docker-compose build` and to launch the project, `docker-compose up`.

Then, the web application is available on http://localhost:8081

## Authors
* [Luka Camus](https://github.com/Lukacms)
* [Louis Bassagal](https://github.com/LouisBassagal)
* [Samuel Florentin](https://github.com/SamuelFlorentin)
* [Elliot Janvier](https://github.com/eljanvier2)
* [Guillaume Lebreton](https://github.com/Lebonvieuxgui)
