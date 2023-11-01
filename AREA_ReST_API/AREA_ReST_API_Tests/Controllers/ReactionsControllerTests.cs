using AREA_ReST_API;
using AREA_ReST_API.Controllers;
using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

namespace TestProject2;

public class ReactionsControllerTests
{
    private readonly ReactionsController _controller;
    private readonly AppDbContext _database;
    private readonly string _adminToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IkthbmUwMDg2IiwiZW1haWwiOiJiYXNzYWdhbC5sb3Vpc0BlcGl0ZWNoLmV1IiwiYWRtaW4iOiJUcnVlIiwiaWQiOiIxIiwibmJmIjoxNjk4NjgyMjkzLCJleHAiOjE3MzAzMDQ2OTMsImlhdCI6MTY5ODY4MjI5MywiaXNzIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6ODA4MCIsImF1ZCI6Imh0dHBzOi8vbG9jYWxob3N0OjgwODAifQ.tplFBrPe1o2FCYZK34DFhuf-tFnn-aaUg8gCgiWRtHI";
    private readonly string _normalToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IkthbmUwMDg2IiwiZW1haWwiOiJiYXNzYWdhbC5sb3Vpc0BlcGl0ZWNoLmV1IiwiYWRtaW4iOiJGYWxzZSIsImlkIjoiMSIsIm5iZiI6MTY5ODY4MjI5MywiZXhwIjoxNzMwMzA0NjkzLCJpYXQiOjE2OTg2ODIyOTMsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0OjgwODAiLCJhdWQiOiJodHRwczovL2xvY2FsaG9zdDo4MDgwIn0.-HfPCUJaKTmMYqW1uIQhk3Yugsq8t9t3k3Xb1lvOGvc";

    public ReactionsControllerTests()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: "ReactionControllerTest")
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
        _controller = new ReactionsController(_database);
    }

    [Test]
    public void TestGetAllReactions_EmptyList()
    {
        var reactions = _controller.GetAllReactions();
        var emptyList = (List<ReactionsModel>)(((OkObjectResult)reactions.Result!)!).Value!;
        Assert.That(emptyList.IsNullOrEmpty(), Is.EqualTo(true));
    }

    [Test]
    public void TestGetAllReactions_FilledList()
    {
        _database.Reactions.Add(new ReactionsModel
        {
            ServiceId = 1,
            Name = "Reaction",
            Endpoint = "Endpoint"
        });
        _database.SaveChanges();
        var reactions = _controller.GetAllReactions();
        var filledList = (List<ReactionsModel>)(((OkObjectResult)reactions.Result!)!).Value!;
        Assert.That(filledList.IsNullOrEmpty(), Is.EqualTo(false));
        _database.Reactions.RemoveRange(_database.Reactions);
        _database.SaveChanges();
    }

    [Test]
    public void TestGetReactionByServiceId_EmptyList()
    {
        var reactions = _controller.GetReactionsByServiceId(1);
        var emptyList = (List<ReactionsModel>)(((OkObjectResult)reactions.Result!)!).Value!;
        Assert.That(emptyList.IsNullOrEmpty(), Is.EqualTo(true));
    }

    [Test]
    public void TestGetReactionByServiceId_FilledList()
    {
        _database.Reactions.Add(new ReactionsModel
        {
            ServiceId = 1,
            Name = "Reaction",
            Endpoint = "Endpoint"
        });
        _database.SaveChanges();
        var reactions = _controller.GetReactionsByServiceId(1);
        var filledList = (List<ReactionsModel>)(((OkObjectResult)reactions.Result!)!).Value!;
        Assert.That(filledList.IsNullOrEmpty(), Is.EqualTo(false));
        _database.Reactions.RemoveRange(_database.Reactions);
        _database.SaveChanges();
    }

    [Test]
    public void TestCreateNewReaction_Valid()
    {
        var newReaction = new ReactionsModel
        {
            ServiceId = 1,
            Name = "Name",
            Endpoint = "Endpoint"
        };
        var result = _controller.CreateNewReaction(newReaction, "Bearer " + _adminToken);
        Assert.That(result, Is.TypeOf<CreatedResult>());
        _database.Reactions.RemoveRange(_database.Reactions);
        _database.SaveChanges();
    }

    [Test]
    public void TestCreateNewReaction_NoName()
    {
        var newReaction = new ReactionsModel
        {
            ServiceId = 1,
            Name = "",
            Endpoint = "Endpoint"
        };
        var result = _controller.CreateNewReaction(newReaction, "Bearer " + _adminToken);
        Assert.That(result, Is.TypeOf<BadRequestObjectResult>());
    }

    [Test]
    public void TestCreateNewReaction_NoEndpoint()
    {
        var newReaction = new ReactionsModel
        {
            ServiceId = 1,
            Name = "Name",
            Endpoint = ""
        };
        var result = _controller.CreateNewReaction(newReaction, "Bearer " + _adminToken);
        Assert.That(result, Is.TypeOf<BadRequestObjectResult>());
    }

    [Test]
    public void TestCreateNewReaction_NoService()
    {
        var newReaction = new ReactionsModel
        {
            ServiceId = 0,
            Name = "Name",
            Endpoint = "Endpoint"
        };
        var result = _controller.CreateNewReaction(newReaction, "Bearer " + _adminToken);
        Assert.That(result, Is.TypeOf<BadRequestObjectResult>());
    }

    [Test]
    public void TestCreateNewReaction_NonExistingService()
    {
        var newReaction = new ReactionsModel
        {
            ServiceId = 1000,
            Name = "Name",
            Endpoint = "Endpoint"
        };
        var result = _controller.CreateNewReaction(newReaction, "Bearer " + _adminToken);
        Assert.That(result, Is.TypeOf<BadRequestObjectResult>());
    }

    [Test]
    public void TestCreateNewReaction_NotAdmin()
    {
        var newReaction = new ReactionsModel
        {
            ServiceId = 1,
            Name = "Name",
            Endpoint = "Endpoint"
        };
        var result = _controller.CreateNewReaction(newReaction, "Bearer " + _normalToken);
        Assert.That(result, Is.TypeOf<UnauthorizedObjectResult>());
    }

    [Test]
    public void TestDeleteReaction_Valid()
    {
        var newReaction = new ReactionsModel
        {
            ServiceId = 1,
            Name = "Name",
            Endpoint = "Endpoint"
        };
        var reactionEntry = _database.Reactions.Add(newReaction);
        _database.SaveChanges();
        var result = _controller.DeleteReaction(reactionEntry.Entity.Id, "Bearer " + _adminToken);
        Assert.That(result, Is.TypeOf<OkObjectResult>());
        _database.Reactions.RemoveRange(_database.Reactions);
        _database.SaveChanges();
    }

    [Test]
    public void TestDeleteReaction_NotAdmin()
    {
        var newReaction = new ReactionsModel
        {
            ServiceId = 1,
            Name = "Name",
            Endpoint = "Endpoint"
        };
        var reactionEntry = _database.Reactions.Add(newReaction);
        _database.SaveChanges();
        var result = _controller.DeleteReaction(reactionEntry.Entity.Id, "Bearer " + _normalToken);
        Assert.That(result, Is.TypeOf<UnauthorizedObjectResult>());
    }

    [Test]
    public void TestDeleteReaction_NotExist()
    {
        var result = _controller.DeleteReaction(57, "Bearer " + _adminToken);
        Assert.That(result, Is.TypeOf<NotFoundObjectResult>());
    }
}