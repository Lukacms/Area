using AREA_ReST_API;
using AREA_ReST_API.Classes;
using AREA_ReST_API.Controllers.OAuth;
using AREA_ReST_API.Models;
using AREA_ReST_API.Models.OAuth.Github;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Moq;

namespace TestProject2.Controllers.OAuth;

public class GithubControllerTests
{
    private readonly GithubController _validController;
    private readonly GithubController _invalidController;
    private readonly AppDbContext _database;
    private const string _token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IkthbmUwMDg2IiwiZW1haWwiOiJiYXNzYWdhbC5sb3Vpc0BlcGl0ZWNoLmV1IiwiYWRtaW4iOiJUcnVlIiwiaWQiOiIxIiwibmJmIjoxNjk4NjgyMjkzLCJleHAiOjE3MzAzMDQ2OTMsImlhdCI6MTY5ODY4MjI5MywiaXNzIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6ODA4MCIsImF1ZCI6Imh0dHBzOi8vbG9jYWxob3N0OjgwODAifQ.tplFBrPe1o2FCYZK34DFhuf-tFnn-aaUg8gCgiWRtHI";

    public GithubControllerTests()
    {
        var httpServiceMock = new Mock<HttpService>();
        var httpServiceMockInvalid = new Mock<HttpService>();
        httpServiceMock.Setup(service => service.PostWithQueryAsync(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
            .ReturnsAsync(new string("{\"access_token\":\"accessToken\", \"refresh_token\":\"refreshToken\", \"expires_in\":\"3600\"}"));
        httpServiceMockInvalid.Setup(service => service.PostWithQueryAsync(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
            .ReturnsAsync(new string("ERROR"));
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: "GithubControllerTest")
            .Options;
        _database = new AppDbContext(options);
        _database.Services.Add(new ServicesModel
        {
            Name = "Github",
            Logo = new byte[] { 0123 },
            ConnectionLink = "ConnectionLink",
            ConnectionLinkMobile = "MobileConnectionLink",
            Endpoint = "Endpoint",
            IsConnectionNeeded = true
        });
        _database.SaveChanges();
        _validController = new GithubController(_database, httpServiceMock.Object);
        _invalidController = new GithubController(_database, httpServiceMockInvalid.Object);
    }

    [Test]
    public async Task Test_RequestGithubToken_Valid()
    {
        var githubModel = new GithubModel
        {
            Code = "Code",
        };
        var result = await _validController.RequestGithubToken(githubModel, "Bearer " + _token);
        var userService = _database.UserServices.First();
        Assert.Multiple(() =>
        {
            Assert.That(result, Is.TypeOf<OkResult>());
            Assert.That(userService.AccessToken, Is.EqualTo("accessToken"));
            Assert.That(userService.RefreshToken, Is.EqualTo("refreshToken"));
            Assert.That(userService.ExpiresIn, Is.EqualTo(3600));
        });
    }

    [Test]
    public void Test_RequestGithubToken_Invalid()
    {
        var githubModel = new GithubModel
        {
            Code = "Code",
        };
        var result = _invalidController.RequestGithubToken(githubModel, "Bearer " + _token);
        Assert.That(result.Result, Is.TypeOf<BadRequestObjectResult>());
    }

    [Test]
    public void Test_RequestGithubTokenMobile_Valid()
    {
        var githubModel = new GithubModel
        {
            Code = "Code",
        };
        var result = _validController.RequestGithubTokenMobile(githubModel, "Bearer " + _token);
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
    public void Test_RequestGithubTokenMobile_Invalid()
    {
        var githubModel = new GithubModel
        {
            Code = "Code",
        };
        var result = _invalidController.RequestGithubTokenMobile(githubModel, "Bearer " + _token);
        Assert.That(result.Result, Is.TypeOf<BadRequestObjectResult>());
    }
}