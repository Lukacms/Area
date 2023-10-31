using AREA_ReST_API;
using AREA_ReST_API.Controllers;
using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace TestProject2;

public class ActionsControllerTests
{
    private ActionsController _controller;
    private readonly AppDbContext _database;
    private readonly string _adminToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IkthbmUwMDg2IiwiZW1haWwiOiJiYXNzYWdhbC5sb3Vpc0BlcGl0ZWNoLmV1IiwiYWRtaW4iOiJUcnVlIiwiaWQiOiIxIiwibmJmIjoxNjk4NjgyMjkzLCJleHAiOjE3MzAzMDQ2OTMsImlhdCI6MTY5ODY4MjI5MywiaXNzIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6ODA4MCIsImF1ZCI6Imh0dHBzOi8vbG9jYWxob3N0OjgwODAifQ.tplFBrPe1o2FCYZK34DFhuf-tFnn-aaUg8gCgiWRtHI";
    private readonly string _normalToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IkthbmUwMDg2IiwiZW1haWwiOiJiYXNzYWdhbC5sb3Vpc0BlcGl0ZWNoLmV1IiwiYWRtaW4iOiJGYWxzZSIsImlkIjoiMSIsIm5iZiI6MTY5ODY4MjI5MywiZXhwIjoxNzMwMzA0NjkzLCJpYXQiOjE2OTg2ODIyOTMsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0OjgwODAiLCJhdWQiOiJodHRwczovL2xvY2FsaG9zdDo4MDgwIn0.-HfPCUJaKTmMYqW1uIQhk3Yugsq8t9t3k3Xb1lvOGvc";

    public ActionsControllerTests()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: "InMemoryDatabase")
            .Options;
        _database = new AppDbContext(options);
        var service = new ServicesModel
        {
            Name = "Service",
            Endpoint = "Endpoint",
            ConnectionLink = "ConnectionLink",
            Logo = "Logo"u8.ToArray(),
            ConnectionLinkMobile = "ConnectionLinkMobile",
            IsConnectionNeeded = false,
        };
        _database.Services.Add(service);
        _database.SaveChanges();
        _controller = new ActionsController(_database);
    }

    [SetUp]
    public void Setup()
    {
    }

    [Test]
    public void TestGetAllActions()
    {
        var response = _controller.GetAllActions();
        Assert.That(response.Result, Is.TypeOf<OkObjectResult>());
    }

    [Test]
    public void TestGetActionByServiceId()
    {
        var response = _controller.GetActionsByServiceId(1);
        Assert.That(response.Result, Is.TypeOf<OkObjectResult>());
    }

    [Test]
    public void TestCreateNewAction_Valid()
    {
        var newAction = new ActionsModel
        {
            Name = "Action Test",
            ServiceId = 1,
            DefaultConfiguration = "{}",
            Endpoint = "https://fr.endpoint-test.com/"
        };
        var response = _controller.CreateNewAction(newAction, "Bearer " + _adminToken);
        Assert.That(response.Result, Is.TypeOf<CreatedResult>());
        _database.Actions.RemoveRange(_database.Actions);
        _database.SaveChanges();
    }

    [Test]
    public void TestCreateNewAction_NotAdmin()
    {
        var newAction = new ActionsModel
        {
            Name = "Action Test",
            ServiceId = 1,
            DefaultConfiguration = "{}",
            Endpoint = "https://fr.endpoint-test.com/"
        };
        var response = _controller.CreateNewAction(newAction, "Bearer " + _normalToken);
        Assert.That(response.Result, Is.TypeOf<UnauthorizedObjectResult>());
        _database.Actions.RemoveRange(_database.Actions);
        _database.SaveChanges();
    }

    [Test]
    public void TestCreateNewAction_NotValidServiceId()
    {
        var newAction = new ActionsModel
        {
            Name = "Action Test",
            ServiceId = 2,
            DefaultConfiguration = "{}",
            Endpoint = "https://fr.endpoint-test.com/"
        };
        var response = _controller.CreateNewAction(newAction, "Bearer " + _adminToken);
        Assert.That(response.Result, Is.TypeOf<BadRequestObjectResult>());
        _database.Actions.RemoveRange(_database.Actions);
        _database.SaveChanges();
    }

    [Test]
    public void TestCreateNewAction_InvalidName()
    {
        var newAction = new ActionsModel
        {
            Name = "",
            ServiceId = 1,
            DefaultConfiguration = "{}",
            Endpoint = "https://fr.endpoint-test.com/"
        };
        var response = _controller.CreateNewAction(newAction, "Bearer " + _adminToken);
        Assert.That(response.Result, Is.TypeOf<BadRequestObjectResult>());
        _database.Actions.RemoveRange(_database.Actions);
        _database.SaveChanges();
    }

    [Test]
    public void TestCreateNewAction_InvalidServiceId()
    {
        var newAction = new ActionsModel
        {
            Name = "Action Test",
            ServiceId = 0,
            DefaultConfiguration = "{}",
            Endpoint = "https://fr.endpoint-test.com/"
        };
        var response = _controller.CreateNewAction(newAction, "Bearer " + _adminToken);
        Assert.That(response.Result, Is.TypeOf<BadRequestObjectResult>());
        _database.Actions.RemoveRange(_database.Actions);
        _database.SaveChanges();
    }

    [Test]
    public void TestCreateNewAction_InvalidEndpoint()
    {
        var newAction = new ActionsModel
        {
            Name = "Action Test",
            ServiceId = 1,
            DefaultConfiguration = "{}",
            Endpoint = ""
        };
        var response = _controller.CreateNewAction(newAction, "Bearer " + _adminToken);
        Assert.That(response.Result, Is.TypeOf<BadRequestObjectResult>());
        _database.Actions.RemoveRange(_database.Actions);
        _database.SaveChanges();
    }

    [Test]
    public void TestGetActionsByServiceId()
    {
        var newAction = new ActionsModel
        {
            Name = "Action Test",
            DefaultConfiguration = "{}",
            Endpoint = "https://fr.endpoint-test.com/",
            ServiceId = 1,
        };
        _database.Actions.Add(newAction);
        _database.SaveChanges();
        var results = _controller.GetActionsByServiceId(1);
        var content = (OkObjectResult)results.Result!;
        var list = (List<ActionsModel>)content.Value!;
        Assert.That(list[0].Name, Is.SameAs("Action Test"));
        _database.Actions.RemoveRange(_database.Actions);
        _database.SaveChanges();
    }

    [Test]
    public void TestDeleteAction_AdminToken()
    {
        var newAction = new ActionsModel
        {
            Name = "Action Test",
            DefaultConfiguration = "{}",
            Endpoint = "https://fr.endpoint-test.com/",
            ServiceId = 1,
        };
        var action = _database.Actions.Add(newAction).Entity;
        _database.SaveChanges();
        var results = _controller.DeleteAction(action.Id, "Bearer " + _adminToken);
        Assert.That(results.Result, Is.TypeOf<OkObjectResult>());
        _database.Actions.RemoveRange(_database.Actions);
        _database.SaveChanges();
    }

    [Test]
    public void TestDeleteAction_NormalToken()
    {
        var newAction = new ActionsModel
        {
            Name = "Action Test",
            DefaultConfiguration = "{}",
            Endpoint = "https://fr.endpoint-test.com/",
            ServiceId = 1,
        };
        var action = _database.Actions.Add(newAction).Entity;
        _database.SaveChanges();
        var results = _controller.DeleteAction(action.Id, "Bearer " + _normalToken);
        Assert.That(results.Result, Is.TypeOf<UnauthorizedObjectResult>());
        _database.Actions.RemoveRange(_database.Actions);
        _database.SaveChanges();
    }

    [Test]
    public void TestDeleteAction_ActionNotExist()
    {
        var results = _controller.DeleteAction(0, "Bearer " + _adminToken);
        Assert.That(results.Result, Is.TypeOf<NotFoundObjectResult>());
        _database.Actions.RemoveRange(_database.Actions);
        _database.SaveChanges();
    }
}