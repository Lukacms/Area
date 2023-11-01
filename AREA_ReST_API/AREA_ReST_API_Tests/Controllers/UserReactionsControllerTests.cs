using AREA_ReST_API;
using AREA_ReST_API.Controllers;
using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

namespace TestProject2;

public class UserReactionsControllerTests
{
    private readonly UserReactionsController _controller;
    private readonly AppDbContext _database;

    public UserReactionsControllerTests()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: "UserReactionControllerTests")
            .Options;
        _database = new AppDbContext(options);
        _controller = new UserReactionsController(_database);
    }

    [Test]
    public void TestsCreateNewUserReaction_Valid()
    {
        var userReaction = new UserReactionsModel
        {
            ReactionId = 1,
            AreaId = 1,
            Configuration = "{}"
        };
        var result = _controller.CreateNewUserReaction(userReaction);
        var savedUserReaction = _database.UserReactions.First();
        Assert.Multiple(() =>
        {
            Assert.That(result, Is.TypeOf<CreatedResult>());
            Assert.That(savedUserReaction.AreaId, Is.EqualTo(1));
            Assert.That(savedUserReaction.ReactionId, Is.EqualTo(1));
            Assert.That(savedUserReaction.Configuration, Is.EqualTo("{}"));
        });
        _database.UserReactions.RemoveRange(_database.UserReactions);
        _database.SaveChanges();
    }

    [Test]
    public void TestsGetUserReactionByAreaId_FilledList()
    {
        var userReaction = new UserReactionsModel
        {
            ReactionId = 1,
            AreaId = 1,
            Configuration = "{}"
        };
        _database.UserReactions.Add(userReaction);
        _database.SaveChanges();
        var result = _controller.GetUserReactionByAreaId(1);
        Assert.Multiple(() =>
        {
            Assert.That(result.Result, Is.TypeOf<OkObjectResult>());
            Assert.That(((List<UserReactionsModel>)((OkObjectResult)result.Result!).Value!).IsNullOrEmpty(), Is.EqualTo(false));
        });
        _database.UserReactions.RemoveRange(_database.UserReactions);
        _database.SaveChanges();
    }

    [Test]
    public void TestsGetUserReactionByAreaId_EmptyList()
    {
        var result = _controller.GetUserReactionByAreaId(1);
        Assert.Multiple(() =>
        {
            Assert.That(result.Result, Is.TypeOf<OkObjectResult>());
            Assert.That(((List<UserReactionsModel>)((OkObjectResult)result.Result!).Value!).IsNullOrEmpty(), Is.EqualTo(true));
        });
        _database.UserReactions.RemoveRange(_database.UserReactions);
        _database.SaveChanges();
    }

    [Test]
    public void TestsDeleteUserReactionById_Valid()
    {
        var userReaction = new UserReactionsModel
        {
            ReactionId = 1,
            AreaId = 1,
            Configuration = "{}"
        };
        var entity = _database.UserReactions.Add(userReaction);
        _database.SaveChanges();
        var result = _controller.DeleteUserReactionById(entity.Entity.Id);
        Assert.That(result, Is.TypeOf<OkObjectResult>());
        _database.UserReactions.RemoveRange(_database.UserReactions);
        _database.SaveChanges();
    }

    [Test]
    public void TestsDeleteUserReactionById_NotExist()
    {
        var result = _controller.DeleteUserReactionById(0);
        Assert.That(result, Is.TypeOf<NotFoundObjectResult>());
        _database.UserReactions.RemoveRange(_database.UserReactions);
        _database.SaveChanges();
    }
}