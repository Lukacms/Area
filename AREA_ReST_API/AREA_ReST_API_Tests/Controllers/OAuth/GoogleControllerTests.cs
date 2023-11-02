using AREA_ReST_API;
using AREA_ReST_API.Classes;
using AREA_ReST_API.Controllers.OAuth;
using AREA_ReST_API.Models;
using AREA_ReST_API.Models.OAuth.Google;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Moq;

namespace TestProject2.Controllers.OAuth;

public class GoogleControllerTests
{
    private GoogleController _validController;
    private GoogleController _invalidController;
    private AppDbContext _database;
    private readonly string _googleUrl = "https://oauth2.googleapis.com/token";
    private readonly string _token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IkthbmUwMDg2IiwiZW1haWwiOiJiYXNzYWdhbC5sb3Vpc0BlcGl0ZWNoLmV1IiwiYWRtaW4iOiJUcnVlIiwiaWQiOiIxIiwibmJmIjoxNjk4NjgyMjkzLCJleHAiOjE3MzAzMDQ2OTMsImlhdCI6MTY5ODY4MjI5MywiaXNzIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6ODA4MCIsImF1ZCI6Imh0dHBzOi8vbG9jYWxob3N0OjgwODAifQ.tplFBrPe1o2FCYZK34DFhuf-tFnn-aaUg8gCgiWRtHI";

    public GoogleControllerTests()
    {
        var httpServiceMock = new Mock<HttpService>();
        var httpServiceMockInvalid = new Mock<HttpService>();
        httpServiceMock.Setup(service => service.PostAsync(_googleUrl, It.IsAny<Dictionary<string,string>>(), "application/x-www-forms-urlencoded", It.IsAny<string>()))
            .ReturnsAsync(new string("{\"access_token\":\"accessToken\", \"refresh_token\":\"refreshToken\", \"expires_in\":\"3600\"}"));
        httpServiceMockInvalid.Setup(service => service.PostAsync(_googleUrl, It.IsAny<Dictionary<string,string>>(), "application/x-www-forms-urlencoded", It.IsAny<string>()))
            .ReturnsAsync(new string("ERROR"));
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: "GoogleControllerTest")
            .Options;
        _database = new AppDbContext(options);
        _database.Services.Add(new ServicesModel
        {
            Name = "Google",
            Logo = new byte[] { 0123 },
            ConnectionLink = "ConnectionLink",
            ConnectionLinkMobile = "MobileConnectionLink",
            Endpoint = "Endpoint",
            IsConnectionNeeded = true
        });
        _database.SaveChanges();
        _validController = new GoogleController(_database, httpServiceMock.Object);
        _invalidController = new GoogleController(_database, httpServiceMockInvalid.Object);
    }

    [Test]
    public void Test_RequestGoogleToken_Valid()
    {
        var googleModel = new GoogleModel
        {
            Code = "Code",
        };
        var result = _validController.RequestGoogleToken(googleModel, "Bearer " + _token);
        var userService = _database.UserServices.First();
        Assert.Multiple(() =>
        {
            Assert.That(result.Result, Is.TypeOf<OkResult>());
            Assert.That(userService.AccessToken, Is.EqualTo("accessToken"));
            Assert.That(userService.RefreshToken, Is.EqualTo("refreshToken"));
            Assert.That(userService.ExpiresIn, Is.EqualTo(3600));
        });
    }

    [Test]
    public void Test_RequestGoogleToken_Invalid()
    {
        var googleModel = new GoogleModel
        {
            Code = "Code",
        };
        var result = _invalidController.RequestGoogleToken(googleModel, "Bearer " + _token);
        Assert.That(result.Result, Is.TypeOf<BadRequestObjectResult>());
    }

    [Test]
    public void Test_RequestGoogleTokenMobile_Valid()
    {
        var googleModel = new GoogleModel
        {
            Code = "Code",
        };
        var result = _validController.RequestGoogleTokenMobile(googleModel, "Bearer " + _token);
        var userService = _database.UserServices.First();
        Assert.Multiple(() =>
        {
            Assert.That(result.Result, Is.TypeOf<OkResult>());
            Assert.That(userService.AccessToken, Is.EqualTo("accessToken"));
            Assert.That(userService.RefreshToken, Is.EqualTo("refreshToken"));
            Assert.That(userService.ExpiresIn, Is.EqualTo(3600));
        });
    }

    [Test]
    public void Test_RequestGoogleTokenMobile_Invalid()
    {
        var googleModel = new GoogleModel
        {
            Code = "Code",
        };
        var result = _invalidController.RequestGoogleTokenMobile(googleModel, "Bearer " + _token);
        Assert.That(result.Result, Is.TypeOf<BadRequestObjectResult>());
    }
}