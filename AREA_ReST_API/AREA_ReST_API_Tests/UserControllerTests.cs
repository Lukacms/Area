using System.Net;
using System.Text.Json.Nodes;
using AREA_ReST_API;
using AREA_ReST_API.Classes.Register;
using AREA_ReST_API.Classes.Jwt;
using AREA_ReST_API.Classes.Login;
using AREA_ReST_API.Controllers;
using AREA_ReST_API.Middleware;
using AREA_ReST_API.Models;
using Castle.Components.DictionaryAdapter.Xml;
using Microsoft.AspNetCore.Authentication.OAuth.Claims;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;

namespace TestProject2;

public class TestsUserController
{
    private UsersController _usrCtr;
    private readonly AppDbContext _db;
    private readonly string _adminToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IkthbmUwMDg2IiwiZW1haWwiOiJiYXNzYWdhbC5sb3Vpc0BlcGl0ZWNoLmV1IiwiYWRtaW4iOiJUcnVlIiwiaWQiOiIxIiwibmJmIjoxNjk4NjgyMjkzLCJleHAiOjE3MzAzMDQ2OTMsImlhdCI6MTY5ODY4MjI5MywiaXNzIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6ODA4MCIsImF1ZCI6Imh0dHBzOi8vbG9jYWxob3N0OjgwODAifQ.tplFBrPe1o2FCYZK34DFhuf-tFnn-aaUg8gCgiWRtHI";
    private readonly string _normalToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IkthbmUwMDg2IiwiZW1haWwiOiJiYXNzYWdhbC5sb3Vpc0BlcGl0ZWNoLmV1IiwiYWRtaW4iOiJGYWxzZSIsImlkIjoiMSIsIm5iZiI6MTY5ODY4MjI5MywiZXhwIjoxNzMwMzA0NjkzLCJpYXQiOjE2OTg2ODIyOTMsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0OjgwODAiLCJhdWQiOiJodHRwczovL2xvY2FsaG9zdDo4MDgwIn0.-HfPCUJaKTmMYqW1uIQhk3Yugsq8t9t3k3Xb1lvOGvc";

    public TestsUserController()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: "InMemoryDatabase")
            .Options;
        _db = new AppDbContext(options);
        var user = new UsersModel
        {
            Admin = true,
            Email = "email",
            Name = "Name",
            Password = "password",
            Surname = "Surname",
            Username = "Username"
        };
        _db.Users.Add(user);
        _db.SaveChanges();
        _usrCtr = new UsersController(_db);
    }

    [SetUp]
    public void Setup()
    {
    }

    [Test]
    public void TestValidLogin()
    {

        var register = new RegisterClass
        {
            Email = "rdm.email@email.com",
            Password = "password",
            Username = "username",
            Name = "name",
            Surname = "surname"
        };
        var opt = new JwtOptions
        {
            Audience = "https://localhost:8080",
            ExpirationSeconds = 3600,
            Issuer = "https://localhost:8080",
            SigningKey = "tjA0480DiekkF4ykTnlQ4wufT5KS6xgk",
        };

        _usrCtr.CreateNewUser(register);
        var cred = new Credentials
        {
            Email = register.Email,
            Password = register.Password
        };
        var user = _db.Users.FirstOrDefault();
        user.IsMailVerified = true;
        _db.Users.Update(user);
        _db.SaveChanges();
        var test = _usrCtr.LoginUser(cred, opt);
        _db.SaveChanges();
        Assert.That(test, Is.TypeOf<OkObjectResult>());
        _db.Users.RemoveRange(_db.Users);
        _db.SaveChanges();
    }

    [Test]
    public void TestInValidLoginNullCredential()
    {
        var register = new RegisterClass
        {
            Email = "rdm.email@email.com",
            Password = "password",
            Username = "username",
            Name = "name",
            Surname = "surname"
        };
        var opt = new JwtOptions();
        opt.Issuer = "ff";
        opt.Audience = "ff";
        opt.SigningKey =
            "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\ngbIj9CAr6FfVWSmp1wNPqh5HKkRO\n ";
        var _usrCtr = new UsersController(_db);
        _usrCtr.CreateNewUser(register);
        var usr = _db.Users.FirstOrDefault();
        var cred = new Credentials
        {
            Email = register.Email,
            Password = ""
        };
        var test = _usrCtr.LoginUser(cred, opt);
        var retBadRequestObjRes = new BadRequestObjectResult(new JsonObject());
        if (test.GetType() == retBadRequestObjRes.GetType())
            Assert.Pass();
        Assert.Fail();
        _db.Users.RemoveRange(_db.Users);
        _db.SaveChanges();
    }


    [Test]
    public void TestInValidLoginEmailNotVerif()
    {
        var register = new RegisterClass
        {
            Email = "rdm.email@email.com",
            Password = "password",
            Username = "username",
            Name = "name",
            Surname = "surname"
        };
        var opt = new JwtOptions();
        opt.Issuer = "ff";
        opt.Audience = "ff";
        opt.SigningKey =
            "MIIJQQIBADANBgkqhkiG9w0BAQEFAASCCSswggknAgEAAoICAQCIYQyXIjgnCtXp\nu8RlG0pbDNZPrUhY0aoTJx+hdFvl2r3/jzj0MEBr/kU34cd69VyhLI99sCXQQQ4g\nzkpWZY43lNIK5+dA1lMqzYa9si6Xvn/Qqk/mjTDOlmxw21pRQSE3a8vBq7O1xkUL\nJXZ4pkQge2CpRIMR/DIT16jWOjOzuMKRfZLZXBW8Y3+7ebP9ifZ11MFyKM1PHkzo\njfUqmwNkBWNpfVL3/mpoO5/DrzuSNlxPghCVXxOxDODDl9+u8O+yuT2QnE0Tukzx\nvJqytUAKO9H19AYhxWARkDN+pzJOJwUwSI5dvXOER+wN6qypPtOVQM9+Jv9t6fwM\nc228kTvTrIfLhUZS8mjs+7XVRIqxGifnyv1IX8lwj3Nn+AOgg2QekxmLH2SQGlzk\njdSfYRC2cJMzfhP+l2xHOvGNcaVz1//wb9sacZlL//GQ5QVCbzBVHaZrSSTVvtbd\nG3H0Gqw7As+4GCuw78c/rJn+NKhfBqnk2AxmZnHsGjSJwqz11Qa7TwjHGg6EPIKl\n8qIHXyrgujbneGp0/hC1ThvL32AgftGfiTiWMDuT6TPHPtIMo7nep6+5ciEzeep9\n5V/w1qUTEVltYXgJz6fjpdQrJnnAfjCvm3upXLCcg2I714pKTE4KkTjd36aB4J8R\nkim/e7JqbMrUKj80+3D7fI3MBOYqlwIDAQABAoIB/zpi683IckHeYbZ8RmVpSZ9L\nEtvWhyKyoIP5CMTjcnSPMZVq7vc1sSu+FrEJK5ESR2K5SrVRgUVA+zHdH4/dhDit\n5HH6CdQeuq+YgUpO/nBfHllqkMqKDlswcaMSrGTp47UJpJh46hDoaw0nYyqqaoBK\nUeSMPSqpNGDj82SQuZHRh+GOrhzG6VQkeCSX9hCVzO4+9JK4GGD6MYyRoGSdLAmm\nROlLJKChGCBUmastWlOk8kaxaGgkTEnm0yAdGHNmszg3SVdsxl+ryUVOrOw73/u0\n08h4sI3Ev1xfLN/ZG0nz0RGnmBiJ0B4FEwp71DyhD44Jystqs4n0osCx3Xx3F4u0\nucCvskjjC6mAK5/NX3LpD85a8HG1eT5faa3Q6nFic83fvnzbHF4DkmK4qe+VgnSP\ncNmRcd79z308kawNFan8ZlZClTZYCyXlxrbAQXItcskRKnzgiu1fnpMrs3eDga9T\n3UmYe5u8acQFlS7dgSCascOAdMtZA1XqJcM1OJ48aQe4xLIJ9U24rDE7Op6/zjFm\n2HEMe3w+VzuTFay/WfTyK40IOk4VrEx3PYEyl/02+2SBX9TylULK3RAVZg1v4bS9\nE5OmsxKDIO17DOcIW+uJINT+lc7LFAKgLSUxb+tvZ623ZTypDTmuHsoXGXih6J6r\nOZ4iUn3DZktNLMlvXEECggEBALvu/a7X4QGMFAqkkVqyzSLIZOWjX4coVszVtLGT\nWxJBK8p21h6mQp8qFfpLXR8J/uE5QPrmpYRn/5lX3Hf2d9SFEvn8xFbf8jbsnZhi\nXjtM6T/NwbBPIZ0xC82cqwQx90rRyqEggwRxl7UrmaTzVc81kOSy/RNPCitmN9Ya\nQkSR10nCaYjM5dV7zsCfJNOlKpO3Fxok42Xx7p8hVgn6//cKvrqJZQrC+9tktn4Q\nQg8YQZJgkXhkjNiovFZuHpmYscSv3VTtPEeprK39wWerqfo9zCrGC6HaS0H9LeIi\nFcZaIN8DqvDih8H/2ERaho0AH7nQS8GCk4q7V3uLo7v7au8CggEBALnF+x+o6Ctr\ncsK+SZVLoAjd1noIoFM3Ku/MS3/pIE1pDC6YhOLZV+8x36S0kgeGoAn89cL0uxd/\na3317w9GEr1CDW/7mRQNsNA0Gy1ogRa0U04ToRZthK1zfE4feaMnHVUS6g4A5Ig/\ndl3bsf8nCeWm2veB1EstbrcFQ4vpEGTx7uyE7H/YpMG1we45a/BeI3KOMch+P4xh\nZqXUCdiamyoMuY+rImbsfKKBlkUy35UqeOiKKgbIT1RaYtmLqfrdzDrzkhYsndqt\nTdZA9qGyouhGHgPSkwkeQDICjZATYxHOvfekBfShrLs+0+g6wfeejJ7JR5H8kkqo\nbRxouYvX2tkCggEAEOs3E2KD8yu1MjAWld+68AKycqn+k6BiEBa9Ka9mZ4JOeu+v\n3xqArOuRBvN58q1nsMcCvpO9Gupx7FAonPQnXY6NYswKsPeASsmKdomEijomVYQk\nh8bX89rSgTQ1gS8uYCH65/6RTPkc+0ZtkpgFhZ4A6VXjyrU26SlOpYu/o4StqQpD\njflER6/ZsSWinxsjdiDph4UCo87f+Jt7r3JVUNw6x3hPDGT5X4r1kuvLxqgcXx0q\ne3gx5d9q9Sz8vD8u4dIjTt38q0bvMMrDep3Ns6WUl9U0fuG0HMC6PL1s0GqUwv8F\niKIcLq7lvWGY82CreoLyDv2+YqLzAUBVATtlKQKCAQEArnaStxHeL+CxntgrrIyg\nF5OWN3bgciYOKbOXd+GM14X+zceojI4GufkBieGWfoDczWSFvPguuAuO/HU5dAOf\n16MvkWocQav10CIPH97T1Gm3Dkz67GAfyPD63TdL+X/jWSDxNAN8m8PVuqF3ESMt\ndUH0w5pmr89T+Yd0/vD614Ipmm/e1tWzLMQwAzRj/RG7gnqtoBeIQKK8TqHKOWRA\nsgXPQnA6V6RiDA9c+1Gijaicce5HN6VoctSLnrg+Av3HLdnO6QovmM1Gmx7ZP9PO\nkApBZ9+a/GYvbYfeQF8km/Wni+i7OxmWaSbAxYhg3tZEQ17N2vjyvjBcf+CN2Bn4\nSQKCAQAcXkiBocHIHpyjlFEXE300uwIAFtwmqoxMj3Dp4eVtBZEyPEacg511Zjhf\nygMZHQG352uhSJ58JBmZdruuSLywh8BNcKqf1HQHp/Pfi/7hhATYM/sP3cjRN0Lm\n/gGclrAaOcXdcTS82oUPGnjcOl8qNjGeOAOWxAeeQTfRACSZZMxBVnr1o99Omo9L\n6C2Mk2nXmydioGbqps9dxec82ZWgkoYXalDiatPclT2KRsFCI7dUzed2UqF+5lq3\nmQN5zC2ms4zOkPgPzkkQkeg5PSNk6YlvANTf4u10hOiWhVxSpXu67v7YfT8AvB8Y\ngbIj9CAr6FfVWSmp1wNPqh5HKkRO\n ";
        _usrCtr.CreateNewUser(register);
        var usr = _db.Users.FirstOrDefault();
        var cred = new Credentials
        {
            Email = register.Email,
            Password = "wrong"
        };
        var test = _usrCtr.LoginUser(cred, opt);
        Assert.That(test, Is.TypeOf<UnauthorizedObjectResult>());
        _db.Users.RemoveRange(_db.Users);
        _db.SaveChanges();
    }
    public void TestInValidLoginWrongPassword()
    {
        var register = new RegisterClass
        {
            Email = "rdm.email@email.com",
            Password = "password",
            Username = "username",
            Name = "name",
            Surname = "surname"
        };
        var opt = new JwtOptions();
        opt.Issuer = "ff";
        opt.Audience = "ff";
        opt.SigningKey =
            "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\ngbIj9CAr6FfVWSmp1wNPqh5HKkRO\n ";
        _usrCtr.CreateNewUser(register);
        var usr = _db.Users.FirstOrDefault();
        _db.Users.FirstOrDefault().IsMailVerified = true;
        _db.Update(_db.Users.FirstOrDefault());
        var cred = new Credentials
        {
            Email = register.Email,
            Password = "wrong"
        };
        var test = _usrCtr.LoginUser(cred, opt);
        Assert.That(test, Is.TypeOf<UnauthorizedObjectResult>());
        _db.Users.RemoveRange(_db.Users);
        _db.SaveChanges();
    }



    [Test]
    public void TestInValidLoginUserNotFound()
    {
        var register = new RegisterClass
        {
            Email = "rdm.email@email.com",
            Password = "password",
            Username = "username",
            Name = "name",
            Surname = "surname"
        };
        var opt = new JwtOptions();
        opt.Issuer = "ff";
        opt.Audience = "ff";
        opt.SigningKey =
            "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\ngbIj9CAr6FfVWSmp1wNPqh5HKkRO\n ";
        _usrCtr.CreateNewUser(register);
        var usr = _db.Users.FirstOrDefault();
        var cred = new Credentials
        {
            Email = "ff",
            Password = register.Password
        };
        var test = _usrCtr.LoginUser(cred, opt);
        var retnotfound = new NotFoundObjectResult(null);
        if (test.GetType() == retnotfound.GetType())
            Assert.Pass();
        Assert.Fail();
        _db.Users.RemoveRange(_db.Users);
        _db.SaveChanges();
    }



    [Test]
    public void TestCreateNewUserAlreadyCreated()
    {
        var register = new RegisterClass
        {
            Email = "rdm.email@email.com",
            Password = "password",
            Username = "username",
            Name = "name",
            Surname = "surname"
        };
        var opt = new JwtOptions();
        opt.Issuer = "ff";
        opt.Audience = "ff";
        opt.SigningKey =
            "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\ngbIj9CAr6FfVWSmp1wNPqh5HKkRO\n ";
        _usrCtr.CreateNewUser(register);
        var error = _usrCtr.CreateNewUser(register);
        var retConflictObjRes = new ConflictObjectResult(new JsonObject());
        if (error.GetType() == retConflictObjRes.GetType())
            Assert.Pass();
        Assert.Fail();
        _db.Users.RemoveRange(_db.Users);
        _db.SaveChanges();
    }


    [Test]
    public void TestCreateUserInvalid()
    {
        var register = new RegisterClass
        {
            Email = null,
            Password = "password",
            Username = "username",
            Name = "name",
            Surname = "surname"
        };
        var error = _usrCtr.CreateNewUser(register);
        var badRequestObjs = new BadRequestObjectResult(new JsonObject());
        if (error.GetType() == badRequestObjs.GetType())
            Assert.Pass();
        Assert.Fail();
        _db.Users.RemoveRange(_db.Users);
        _db.SaveChanges();
    }


    [Test]
    public void TestGetAllUsersValid()
    {
        var register = new RegisterClass
        {
            Email = "rdm.email@email.com",
            Password = "password",
            Username = "username",
            Name = "name",
            Surname = "surname"
        };
        var opt = new JwtOptions();
        opt.Issuer = "ff";
        opt.Audience = "ff";
        opt.SigningKey =
            "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\ngbIj9CAr6FfVWSmp1wNPqh5HKkRO\n ";
        _usrCtr.CreateNewUser(register);
        var usr = _db.Users.FirstOrDefault();
        usr.Admin = true;
        var cred = new Credentials
        {
            Email = register.Email,
            Password = register.Password
        };
        var result = _usrCtr.GetAllUsers("Bearer " +
                                        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IkthbmUwMDg2IiwiZW1haWwiOiJiYXNzYWdhbC5sb3Vpc0BlcGl0ZWNoLmV1IiwiYWRtaW4iOiJUcnVlIiwiaWQiOiIxIiwibmJmIjoxNjk4NjgyMjkzLCJleHAiOjE3MzAzMDQ2OTMsImlhdCI6MTY5ODY4MjI5MywiaXNzIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6ODA4MCIsImF1ZCI6Imh0dHBzOi8vbG9jYWxob3N0OjgwODAifQ.tplFBrPe1o2FCYZK34DFhuf-tFnn-aaUg8gCgiWRtHI");
        //Assert.That(result.Result, Is.TypeOf<UnauthorizedResult>() );
        Assert.That(result.Result, Is.TypeOf<OkObjectResult>());
        _db.Users.RemoveRange(_db.Users);
        _db.SaveChanges();
    }

    [Test]
    public void TestGetAllUsersNotValid()
    {
        var register = new RegisterClass
        {
            Email = "rdm.email@email.com",
            Password = "password",
            Username = "username",
            Name = "name",
            Surname = "surname"
        };
        var opt = new JwtOptions();
        opt.Issuer = "ff";
        opt.Audience = "ff";
        opt.SigningKey =
            "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\ngbIj9CAr6FfVWSmp1wNPqh5HKkRO\n ";
        _usrCtr.CreateNewUser(register);
        var usr = _db.Users.FirstOrDefault();
        var cred = new Credentials
        {
            Email = register.Email,
            Password = register.Password
        };
        var result = _usrCtr.GetAllUsers("Bearer " +
                                        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InVzZXJuYW1lIiwiZW1haWwiOiJyZG0uZW1haWxAZW1haWwuY29tIiwiYWRtaW4iOiJGYWxzZSIsImlkIjoiMSIsIm5iZiI6MTY5ODY4NjE0OCwiZXhwIjoxNzMwMzA4NTQ4LCJpYXQiOjE2OTg2ODYxNDgsImlzcyI6ImZmIiwiYXVkIjoiZmYifQ.gmsBW3vy3XE6aR-OjFH8w1wxcCAzZuoYEt2kRbq0ptk Non Admin\n");
        Assert.That(result.Result, Is.TypeOf<UnauthorizedObjectResult>());
        //Assert.That(result.Result, Is.TypeOf<OkObjectResult>() );
        _db.Users.RemoveRange(_db.Users);
        _db.SaveChanges();
    }


    [Test]
    public void TestGetUserNotAdm()
    {
        var register = new RegisterClass
        {
            Email = "rdm.email@email.com",
            Password = "password",
            Username = "username",
            Name = "name",
            Surname = "surname"
        };
        var opt = new JwtOptions();
        opt.Issuer = "ff";
        opt.Audience = "ff";
        opt.SigningKey =
            "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\ngbIj9CAr6FfVWSmp1wNPqh5HKkRO\n ";
        _usrCtr.CreateNewUser(register);
        var usr = _db.Users.FirstOrDefault();
        var cred = new Credentials
        {
            Email = register.Email,
            Password = register.Password
        };
        var result = _usrCtr.GetUser(0,
            "Bearer " +
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InVzZXJuYW1lIiwiZW1haWwiOiJyZG0uZW1haWxAZW1haWwuY29tIiwiYWRtaW4iOiJGYWxzZSIsImlkIjoiMSIsIm5iZiI6MTY5ODY4NjE0OCwiZXhwIjoxNzMwMzA4NTQ4LCJpYXQiOjE2OTg2ODYxNDgsImlzcyI6ImZmIiwiYXVkIjoiZmYifQ.gmsBW3vy3XE6aR-OjFH8w1wxcCAzZuoYEt2kRbq0ptk Non Admin\n");
        Assert.That(result.Result, Is.TypeOf<UnauthorizedObjectResult>());
        _db.Users.RemoveRange(_db.Users);
        _db.SaveChanges();
    }


    [Test]
    public void TestGetUserAdmAvailableUser()
    { 
        var user = new UsersModel
        {
            Admin = true,
            Email = "email",
            Name = "Name",
            Password = "password",
            Surname = "Surname",
            Username = "Username",
            Id = 2
        };
        _db.Users.Add(user);
        _db.SaveChanges();
        var result = _usrCtr.GetUser(2,
            "Bearer " + _adminToken);
        Assert.That(result.Result, Is.TypeOf<OkObjectResult>());
        _db.Users.RemoveRange(_db.Users);
        _db.SaveChanges();
    }


    [Test]
    public void TestGetUserAdmNotAvailableUser()
    {
        var user = new UsersModel
        {
            Admin = true,
            Email = "email",
            Name = "Name",
            Password = "password",
            Surname = "Surname",
            Username = "Username",
            Id = 2
        };
        _db.Users.Add(user);
        _db.SaveChanges();
        var result = _usrCtr.GetUser(3,
            "Bearer " + _adminToken);
        Assert.That(result.Result, Is.TypeOf<NotFoundObjectResult>());
        _db.Users.RemoveRange(_db.Users);
        _db.SaveChanges();
    }


    [Test]
    public void TestGetMeValid()
    {
        var register = new RegisterClass
        {
            Email = "rdm.email@email.com",
            Password = "password",
            Username = "username",
            Name = "name",
            Surname = "surname"
        };
        var opt = new JwtOptions();
        opt.Issuer = "ff";
        opt.Audience = "ff";
        opt.SigningKey =
            "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\ngbIj9CAr6FfVWSmp1wNPqh5HKkRO\n ";
        _usrCtr.CreateNewUser(register);
        var usr = _db.Users.FirstOrDefault();
        var cred = new Credentials
        {
            Email = register.Email,
            Password = register.Password
        };
        var result = _usrCtr.GetMe("Bearer " +
                                  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IkthbmUwMDg2IiwiZW1haWwiOiJiYXNzYWdhbC5sb3Vpc0BlcGl0ZWNoLmV1IiwiYWRtaW4iOiJUcnVlIiwiaWQiOiIxIiwibmJmIjoxNjk4NjgyMjkzLCJleHAiOjE3MzAzMDQ2OTMsImlhdCI6MTY5ODY4MjI5MywiaXNzIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6ODA4MCIsImF1ZCI6Imh0dHBzOi8vbG9jYWxob3N0OjgwODAifQ.tplFBrPe1o2FCYZK34DFhuf-tFnn-aaUg8gCgiWRtHI");
        Assert.That(result.Result, Is.TypeOf<OkObjectResult>());
        _db.Users.RemoveRange(_db.Users);
        _db.SaveChanges();
    }


    [Test]
    public void TestGetMeNotValid()
    {
        _db.Database.EnsureDeleted();
        var result = _usrCtr.GetMe("Bearer " +
                                  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IkthbmUwMDg2IiwiZW1haWwiOiJiYXNzYWdhbC5sb3Vpc0BlcGl0ZWNoLmV1IiwiYWRtaW4iOiJUcnVlIiwiaWQiOiIxIiwibmJmIjoxNjk4NjgyMjkzLCJleHAiOjE3MzAzMDQ2OTMsImlhdCI6MTY5ODY4MjI5MywiaXNzIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6ODA4MCIsImF1ZCI6Imh0dHBzOi8vbG9jYWxob3N0OjgwODAifQ.tplFBrPe1o2FCYZK34DFhuf-tFnn-aaUg8gCgiWRtHI");
        Assert.That(result.Result, Is.TypeOf<NotFoundObjectResult>());
        _db.Users.RemoveRange(_db.Users);
        _db.SaveChanges();
    }


    [Test]
    public void TestEraseValid()
    {
        var user = new UsersModel
        {
            Admin = true,
            Email = "email",
            Name = "Name",
            Password = "password",
            Surname = "Surname",
            Username = "Username",
            Id = 2
        };
        _db.Users.Add(user);
        _db.SaveChanges();
        var result = _usrCtr.DeleteUser(2);
        Assert.That(result, Is.TypeOf<OkObjectResult>());
        _db.Users.RemoveRange(_db.Users);
        _db.SaveChanges();
    }


    [Test]
    public void TestEraseNotValid()
    {
        var register = new RegisterClass
        {
            Email = "rdm.email@email.com",
            Password = "password",
            Username = "username",
            Name = "name",
            Surname = "surname"
        };
        _usrCtr.CreateNewUser(register);
        var result = _usrCtr.DeleteUser(21);
        Assert.That(result, Is.TypeOf<NotFoundObjectResult>());
        _db.Users.RemoveRange(_db.Users);
        _db.SaveChanges();
    }

    [Test]
    public void TestModifyValid()
    {
        var user = new UsersModel
        {
            Admin = true,
            Email = "email",
            Name = "Name",
            Password = "password",
            Surname = "Surname",
            Username = "Username",
            Id = 2
        };
        _db.Users.Add(user);
        _db.SaveChanges();
        user.Email = "te";
        user.Password = "pass";
        user.Name = "nm";
        user.Surname = "surn";
        user.Username = "usr";
        var result = _usrCtr.ModifyUser(user,
            "Bearer " +
            _adminToken);
        Assert.That(result, Is.TypeOf<CreatedResult>());
        _db.Users.RemoveRange(_db.Users);
        _db.SaveChanges();
    }
}