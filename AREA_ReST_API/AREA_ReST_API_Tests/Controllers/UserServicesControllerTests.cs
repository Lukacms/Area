using AREA_ReST_API;
using AREA_ReST_API.Controllers;
using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

namespace TestProject2;

public class UserServicesControllerTests
{
    private readonly UserServicesController _controller;
    private readonly AppDbContext _database;
    private readonly string _goodToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IkpEb2UiLCJlbWFpbCI6ImpvaG4uZG9lQG1haWwuY29tIiwiYWRtaW4iOiJUcnVlIiwiaWQiOiIxIiwibmJmIjoxNjk4NjgyMjkzLCJleHAiOjE3MzAzMDQ2OTMsImlhdCI6MTY5ODY4MjI5MywiaXNzIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6ODA4MCIsImF1ZCI6Imh0dHBzOi8vbG9jYWxob3N0OjgwODAifQ.PF0Cxk6KD4q_uraATN7kbL74UBZ3n8jik6WpZjyk5so";
    private readonly string _badToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IkthbmUwMDg2IiwiZW1haWwiOiJiYXNzYWdhbC5sb3Vpc0BlcGl0ZWNoLmV1IiwiYWRtaW4iOiJGYWxzZSIsImlkIjoiMSIsIm5iZiI6MTY5ODY4MjI5MywiZXhwIjoxNzMwMzA0NjkzLCJpYXQiOjE2OTg2ODIyOTMsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0OjgwODAiLCJhdWQiOiJodHRwczovL2xvY2FsaG9zdDo4MDgwIn0.-HfPCUJaKTmMYqW1uIQhk3Yugsq8t9t3k3Xb1lvOGvc";

    public UserServicesControllerTests()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: "UserServiceControllerTests")
            .Options;
        _database = new AppDbContext(options);
        _database.Users.Add(new UsersModel
        {
            Email = "john.doe@mail.com",
            Password = "password",
            Username = "JDoe",
            Name = "John",
            Surname = "Doe"
        });
        _database.SaveChanges();
        _controller = new UserServicesController(_database);
    }

    [Test]
    public void TestGetUserServicesByUserId_FilledList()
    {
        var userService = new UserServicesModel
        {
            ServiceId = 1,
            UserId = 1,
            AccessToken = "AccessToken",
            RefreshToken = "RefreshToken",
            ExpiresIn = 3600
        };
        _database.UserServices.Add(userService);
        _database.SaveChanges();
        var result = _controller.GetUserServicesByUserId(1);
        Assert.Multiple(() =>
        {
            Assert.That(result.Result, Is.TypeOf<OkObjectResult>());
            Assert.That(((List<UserServicesModel>)((OkObjectResult)result.Result!).Value!).IsNullOrEmpty(), Is.EqualTo(false));
        });
        _database.UserServices.RemoveRange(_database.UserServices);
        _database.SaveChanges();
    }

    [Test]
    public void TestGetUserServicesByUserId_EmptyList()
    {
        var result = _controller.GetUserServicesByUserId(1);
        Assert.Multiple(() =>
        {
            Assert.That(result.Result, Is.TypeOf<OkObjectResult>());
            Assert.That(((List<UserServicesModel>)((OkObjectResult)result.Result!).Value!).IsNullOrEmpty(), Is.EqualTo(true));
        });
    }

    [Test]
    public void TestDeleteUserServiceById_Valid()
    {
        var userService = new UserServicesModel
        {
            ServiceId = 1,
            UserId = 1,
            AccessToken = "AccessToken",
            RefreshToken = "RefreshToken",
            ExpiresIn = 3600
        };
        var entity = _database.UserServices.Add(userService);
        _database.SaveChanges();
        var result = _controller.DeleteUserServiceById(entity.Entity.Id, "Bearer " + _goodToken);
        Assert.Multiple(() =>
        {
            Assert.That(result, Is.TypeOf<OkObjectResult>());
            Assert.That(_database.UserServices.ToList().IsNullOrEmpty, Is.EqualTo(true));
        });
        _database.UserServices.RemoveRange(_database.UserServices);
        _database.SaveChanges();
    }

    [Test]
    public void TestDeleteUserServiceById_InvalidToken()
    {
        var userService = new UserServicesModel
        {
            ServiceId = 1,
            UserId = 2,
            AccessToken = "AccessToken",
            RefreshToken = "RefreshToken",
            ExpiresIn = 3600
        };
        var entity = _database.UserServices.Add(userService);
        _database.SaveChanges();
        var result = _controller.DeleteUserServiceById(entity.Entity.Id, "Bearer " + _badToken);
        Assert.That(result, Is.TypeOf<UnauthorizedObjectResult>());
        _database.UserServices.RemoveRange(_database.UserServices);
        _database.SaveChanges();
    }

    [Test]
    public void TestDeleteUserServiceById_NotExist()
    {
        var result = _controller.DeleteUserServiceById(0, "Bearer " + _goodToken);
        Assert.That(result, Is.TypeOf<NotFoundObjectResult>());
    }
}