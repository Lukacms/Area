using AREA_ReST_API;
using AREA_ReST_API.Controllers;
using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

namespace TestProject2.Controllers;

public class UserActionsControllerTests
{
    private readonly UserActionsController _controller;
    private readonly AppDbContext _database;

    public UserActionsControllerTests()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: "UserActionControllerTests")
            .Options;
        _database = new AppDbContext(options);
        _controller = new UserActionsController(_database);
    }

    [Test]
    public void Test_GetUserActionByAreaId_Valid()
    {
        var userAction = new UserActionsModel
        {
            ActionId = 1,
            AreaId = 1,
            Timer = 10,
            Configuration = "{}"
        };
        _database.UserActions.Add(userAction);
        _database.SaveChanges();
        var result = _controller.GetUserActionByAreaId(1);
        Assert.That(result.Result, Is.TypeOf<OkObjectResult>());
        _database.UserActions.RemoveRange(_database.UserActions);
        _database.SaveChanges();
    }

    [Test]
    public void Test_GetUserActionByAreaId_NoAction()
    {
        var result = _controller.GetUserActionByAreaId(1);
        Assert.That(result.Result, Is.TypeOf<NotFoundObjectResult>());
    }

    [Test]
    public void Test_CreateNewUserAction_Valid()
    {
        var newUserAction = new UserActionsModel
        {
            ActionId = 1,
            AreaId = 1,
            Timer = 100,
            Configuration = "{}"
        };
        _controller.CreateNewUserAction(newUserAction);
        var savedUserAction = _database.UserActions.First();
        Assert.Multiple(() =>
        {
            Assert.That(savedUserAction.AreaId, Is.EqualTo(1));
            Assert.That(savedUserAction.Timer, Is.EqualTo(100));
            Assert.That(savedUserAction.ActionId, Is.EqualTo(1));
            Assert.That(savedUserAction.Configuration, Is.EqualTo("{}"));
        });
        _database.UserActions.RemoveRange(_database.UserActions);
        _database.SaveChanges();
    }

    [Test]
    public void Test_DeleteUserAction_Valid()
    {
        var newUserAction = new UserActionsModel
        {
            ActionId = 1,
            AreaId = 1,
            Timer = 100,
            Configuration = "{}"
        };
        var entity = _database.UserActions.Add(newUserAction);
        _database.SaveChanges();
        var result = _controller.DeleteUserAction(entity.Entity.Id);
        Assert.Multiple(() =>
        {
            Assert.That(result, Is.TypeOf<OkObjectResult>());
            Assert.That(_database.UserActions.ToList().IsNullOrEmpty(), Is.EqualTo(true));
        });
        _database.UserActions.RemoveRange(_database.UserActions);
        _database.SaveChanges();
    }

    [Test]
    public void Test_DeleteUserAction_NotExist()
    {
        var result = _controller.DeleteUserAction(0);
        Assert.That(result, Is.TypeOf<NotFoundObjectResult>());
    }
}