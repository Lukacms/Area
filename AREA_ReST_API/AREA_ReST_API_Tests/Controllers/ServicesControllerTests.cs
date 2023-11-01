using AREA_ReST_API;
using AREA_ReST_API.Controllers;
using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

namespace TestProject2.Controllers;

public class ServicesControllerTests
{
    private readonly ServicesController _controller;
    private readonly AppDbContext _database;
    private readonly string _adminToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IkthbmUwMDg2IiwiZW1haWwiOiJiYXNzYWdhbC5sb3Vpc0BlcGl0ZWNoLmV1IiwiYWRtaW4iOiJUcnVlIiwiaWQiOiIxIiwibmJmIjoxNjk4NjgyMjkzLCJleHAiOjE3MzAzMDQ2OTMsImlhdCI6MTY5ODY4MjI5MywiaXNzIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6ODA4MCIsImF1ZCI6Imh0dHBzOi8vbG9jYWxob3N0OjgwODAifQ.tplFBrPe1o2FCYZK34DFhuf-tFnn-aaUg8gCgiWRtHI";
    private readonly string _normalToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IkthbmUwMDg2IiwiZW1haWwiOiJiYXNzYWdhbC5sb3Vpc0BlcGl0ZWNoLmV1IiwiYWRtaW4iOiJGYWxzZSIsImlkIjoiMSIsIm5iZiI6MTY5ODY4MjI5MywiZXhwIjoxNzMwMzA0NjkzLCJpYXQiOjE2OTg2ODIyOTMsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0OjgwODAiLCJhdWQiOiJodHRwczovL2xvY2FsaG9zdDo4MDgwIn0.-HfPCUJaKTmMYqW1uIQhk3Yugsq8t9t3k3Xb1lvOGvc";

    public ServicesControllerTests()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: "ServicesControllerTest")
            .Options;
        _database = new AppDbContext(options);
        _controller = new ServicesController(_database);
    }

    [Test]
    public void Test_GetAllServices_EmptyList()
    {
        var result = _controller.GetAllServices();
        Assert.That(((List<ServicesModel>)((OkObjectResult)result.Result!).Value!).IsNullOrEmpty(), Is.EqualTo(true));
    }

    [Test]
    public void Test_GetAllServices_FilledList()
    {
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
        var result = _controller.GetAllServices();
        Assert.That(((List<ServicesModel>)((OkObjectResult)result.Result!).Value!).IsNullOrEmpty(), Is.EqualTo(false));
        _database.Services.RemoveRange(_database.Services);
        _database.SaveChanges();
    }
}