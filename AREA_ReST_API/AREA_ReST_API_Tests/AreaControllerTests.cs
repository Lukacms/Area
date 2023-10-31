using AREA_ReST_API;
using AREA_ReST_API.Controllers;
using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace TestProject2;

public class AreaControllerTests
{
    private AreasController _controller;
    private readonly AppDbContext _database;
    private readonly string _adminToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IkthbmUwMDg2IiwiZW1haWwiOiJiYXNzYWdhbC5sb3Vpc0BlcGl0ZWNoLmV1IiwiYWRtaW4iOiJUcnVlIiwiaWQiOiIxIiwibmJmIjoxNjk4NjgyMjkzLCJleHAiOjE3MzAzMDQ2OTMsImlhdCI6MTY5ODY4MjI5MywiaXNzIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6ODA4MCIsImF1ZCI6Imh0dHBzOi8vbG9jYWxob3N0OjgwODAifQ.tplFBrPe1o2FCYZK34DFhuf-tFnn-aaUg8gCgiWRtHI";
    private readonly string _normalToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IkthbmUwMDg2IiwiZW1haWwiOiJiYXNzYWdhbC5sb3Vpc0BlcGl0ZWNoLmV1IiwiYWRtaW4iOiJGYWxzZSIsImlkIjoiMSIsIm5iZiI6MTY5ODY4MjI5MywiZXhwIjoxNzMwMzA0NjkzLCJpYXQiOjE2OTg2ODIyOTMsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0OjgwODAiLCJhdWQiOiJodHRwczovL2xvY2FsaG9zdDo4MDgwIn0.-HfPCUJaKTmMYqW1uIQhk3Yugsq8t9t3k3Xb1lvOGvc";

    public AreaControllerTests()
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
        var action = new ActionsModel
        {
            Name = "Action",
            DefaultConfiguration = "{}",
            Endpoint = "Endpoint",
            ServiceId = 1,
        };
        var reaction = new ReactionsModel
        {
            Name = "Reaction",
            DefaultConfiguration = "{}",
            Endpoint = "Endpoint",
            ServiceId = 1
        };
        var user = new UsersModel
        {
            Admin = true,
            Email = "email",
            Name = "Name",
            Password = "password",
            Surname = "Surname",
            Username = "Username"
        };
        _database.Services.Add(service);
        _database.Actions.Add(action);
        _database.Reactions.Add(reaction);
        _database.Users.Add(user);
        _database.SaveChanges();
        _controller = new AreasController(_database);
    }

    [Test]
    public void TestGetAllAreasByUserId()
    {
        var result = _controller.GetAllAreasByUserId(1);
        Assert.That(result.Result, Is.TypeOf<OkObjectResult>());
    }

    [Test]
    public void TestCreateNewArea_Valid()
    {
        var area = new AreasModel
        {
            Favorite = false,
            Name = "Area",
            UserId = 1,
        };
        var result = _controller.CreateNewArea(area);
        Assert.That(result.Result, Is.TypeOf<CreatedResult>());
        _database.Areas.RemoveRange(_database.Areas);
        _database.SaveChanges();
    }

    [Test]
    public void TestCreateNewArea_Invalid()
    {
        var area = new AreasModel
        {
            Favorite = false,
            Name = "",
            UserId = 1,
        };
        var result = _controller.CreateNewArea(area);
        Assert.That(result.Result, Is.TypeOf<BadRequestObjectResult>());
    }

    [Test]
    public void TestCreateNewAreaWithActionAndReaction_Valid()
    {
        var area = new AreaWithActionReaction
        {
            Favorite = true,
            Name = "Area",
            UserAction = new UserActionsModel
            {
                ActionId = 1,
                Configuration = "{}",
                AreaId = 0,
                Timer = 0,
            },
            UserReactions = new List<UserReactionsModel>
            {
                new UserReactionsModel
                {
                    ReactionId = 1,
                    AreaId = 0,
                    Configuration = "{}"
                }
            },
            UserId = 1
        };

        var results = _controller.CreateNewAreaWithActionAndReaction(area);
        Assert.That(results.Result, Is.TypeOf<CreatedResult>());
        _database.UserActions.RemoveRange(_database.UserActions);
        _database.UserReactions.RemoveRange(_database.UserReactions);
        _database.Areas.RemoveRange(_database.Areas);
        _database.SaveChanges();
    }

    [Test]
    public void TestCreateNewAreaWithActionAndReaction_InvalidName()
    {
        var area = new AreaWithActionReaction
        {
            Favorite = true,
            Name = "",
            UserAction = new UserActionsModel
            {
                ActionId = 1,
                Configuration = "{}",
                AreaId = 0,
                Timer = 0,
            },
            UserReactions = new List<UserReactionsModel>
            {
                new UserReactionsModel
                {
                    ReactionId = 1,
                    AreaId = 0,
                    Configuration = "{}"
                }
            },
            UserId = 1
        };

        var results = _controller.CreateNewAreaWithActionAndReaction(area);
        Assert.That(results.Result, Is.TypeOf<BadRequestObjectResult>());
        _database.UserActions.RemoveRange(_database.UserActions);
        _database.UserReactions.RemoveRange(_database.UserReactions);
        _database.Areas.RemoveRange(_database.Areas);
        _database.SaveChanges();
    }

    [Test]
    public void TestDeleteAreaWithActionAndReaction_Valid()
    {
        var area = new AreaWithActionReaction
        {
            Favorite = true,
            Name = "Area",
            UserAction = new UserActionsModel
            {
                ActionId = 1,
                Configuration = "{}",
                AreaId = 0,
                Timer = 0,
            },
            UserReactions = new List<UserReactionsModel>
            {
                new UserReactionsModel
                {
                    ReactionId = 1,
                    AreaId = 0,
                    Configuration = "{}"
                }
            },
            UserId = 1
        };
        var results = _controller.CreateNewAreaWithActionAndReaction(area);
        var content = (CreatedResult)results.Result!;
        var areaRes = (AreaWithActionReaction)content.Value!;
        Assert.That(_controller.DeleteAreaWithActionAndReaction(areaRes.Id).Result, Is.TypeOf<OkObjectResult>());
    }

    [Test]
    public void TestDeleteAreaWithActionAndReaction_Invalid()
    {
        Assert.That(_controller.DeleteAreaWithActionAndReaction(0).Result, Is.TypeOf<NotFoundObjectResult>());
    }

    [Test]
    public void TestModifyArea()
    {
        var area = new AreasModel
        {
            Favorite = false,
            Name = "Area",
            UserId = 1,
        };
        var result = _controller.CreateNewArea(area);
        var id = ((AreasModel)((CreatedResult)result.Result!).Value!).Id;
        result = _controller.ModifyArea(new AreasModel
        {
            Id = id,
            Favorite = true,
            Name = "Another Name",
            UserId = 1,
        });
        var modifiedArea = _database.Areas.First(s => s.Id == id);
        Assert.That(modifiedArea.Name, Is.SameAs("Another Name"));
        _database.Areas.RemoveRange(_database.Areas);
        _database.SaveChanges();
    }

    /*[Test]
    public void TestGetAllAreasFullByUserId()
    {
        var area = new AreaWithActionReaction
        {
            Favorite = true,
            Name = "Area",
            UserAction = new UserActionsModel
            {
                ActionId = 1,
                Configuration = "{}",
                AreaId = 0,
                Timer = 0,
            },
            UserReactions = new List<UserReactionsModel>
            {
                new UserReactionsModel
                {
                    ReactionId = 1,
                    AreaId = 0,
                    Configuration = "{}"
                }
            },
            UserId = 1
        };
        _controller.CreateNewAreaWithActionAndReaction(area);
        var result = _controller.GetAllAreasFullByUserId(1);
        Assert.That(result.Result, Is.TypeOf<OkObjectResult>());
        _database.UserActions.RemoveRange(_database.UserActions);
        _database.UserReactions.RemoveRange(_database.UserReactions);
        _database.Areas.RemoveRange(_database.Areas);
        _database.SaveChanges();
    } */
}