# API
Application Programming Interface

## Project
C# Application server for Area project.

It uses [dotnet](https://dotnet.microsoft.com/en-us/learn) and is the interface between the front (web and mobile) and the database.

```mermaid
sequenceDiagram
    title API relations with Database and Client·s
    participant Database
    participant API
    participant Client
    Client->>API: Ask for data
    API->>API: Make operations
    API->>Database: Fetch data
    API->>Client: Give Data
```

### Database

![](https://cdn.discordapp.com/attachments/1153248070306373683/1169995399088574584/image-removebg-preview.png?ex=65576e20&is=6544f920&hm=336a54b8c2ad81e81a7ecc297482c3490cb1ac8965c1fbf7109cc2702163ca8e&)

## Commands
The commands should be in the AREA_ReST_API folder

| Command          | Result                                          |
| ---------------- | ----------------------------------------------- |
| `dotnet restore` | Restores the dependencies and tools of a project |
| `dotnet build` | Builds a project and all of its dependencies |
| `dotnet test` | .NET test driver used to execute unit tests. |
