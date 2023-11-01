using System.Text.Json.Nodes;
using AREA_ReST_API;
using AREA_ReST_API.Classes.Register;
using AREA_ReST_API.Classes.Jwt;
using AREA_ReST_API.Classes.Login;
using AREA_ReST_API.Controllers;
using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace TestProject2;

public class Tests
{
    [SetUp]
    public void Setup()
    {
    }

    [Test]
    public void TestValidLogin()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: "InMemoryDatabase")
            .Options;
        var db = new AppDbContext(options);
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

        var usrCtr = new UsersController(db);
        usrCtr.CreateNewUser(register);
        var cred = new Credentials
        {
            Email = register.Email,
            Password = register.Password
        };
        var user = db.Users.FirstOrDefault();
        user.IsMailVerified = true;
        db.Users.Update(user);
        db.SaveChanges();
        var test = usrCtr.LoginUser(cred, opt);
        Assert.That(test, Is.TypeOf<OkObjectResult>());
    }

    [Test]
    public void TestInValidLoginNullCredential()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: "InMemoryDatabase")
            .Options;
        var db = new AppDbContext(options);
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
        opt.SigningKey = "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\ngbIj9CAr6FfVWSmp1wNPqh5HKkRO\n ";
        var usrCtr = new UsersController(db);
        usrCtr.CreateNewUser(register);
        var usr = db.Users.FirstOrDefault();
        var cred = new Credentials
        {
            Email = register.Email,
            Password = ""
        };
        var test = usrCtr.LoginUser(cred, opt);
        var retBadRequestObjRes = new BadRequestObjectResult(new JsonObject());
        if (test.GetType() == retBadRequestObjRes.GetType())
            Assert.Pass();
        Assert.Fail();
        }

    [Test]
    public void TestInValidLoginWrongPassword()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: "InMemoryDatabase")
            .Options;
        var db = new AppDbContext(options);
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
        opt.SigningKey = "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\ngbIj9CAr6FfVWSmp1wNPqh5HKkRO\n ";
        var usrCtr = new UsersController(db);
        usrCtr.CreateNewUser(register);
        var usr = db.Users.FirstOrDefault();
        var cred = new Credentials
        {
            Email = register.Email,
            Password = "wrong"
        };
        var test = usrCtr.LoginUser(cred, opt);
        var retBUnauthObjRes = new UnauthorizedObjectResult(new JsonObject());
        if (test.GetType() == retBUnauthObjRes.GetType())
            Assert.Pass();
        Assert.Fail();
        }


        [Test]
        public void TestInValidLoginUserNotFound()
        {
            var options = new DbContextOptionsBuilder<AppDbContext>()
                .UseInMemoryDatabase(databaseName: "InMemoryDatabase")
                .Options;
            var db = new AppDbContext(options);
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
            opt.SigningKey = "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\ngbIj9CAr6FfVWSmp1wNPqh5HKkRO\n ";
            var usrCtr = new UsersController(db);
            usrCtr.CreateNewUser(register);
            var usr = db.Users.FirstOrDefault();
            var cred = new Credentials
            {
                Email = "ff",
                Password = register.Password
            };
            var test = usrCtr.LoginUser(cred, opt);
            var retnotfound = new NotFoundObjectResult(null);
            if (test.GetType() == retnotfound.GetType())
                Assert.Pass();
            Assert.Fail();
            }


        [Test]
        public void TestCreateNewUserAlreadyCreated()
        {
            var options = new DbContextOptionsBuilder<AppDbContext>()
                .UseInMemoryDatabase(databaseName: "InMemoryDatabase")
                .Options;
            var db = new AppDbContext(options);
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
            opt.SigningKey = "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\ngbIj9CAr6FfVWSmp1wNPqh5HKkRO\n ";
            var usrCtr = new UsersController(db);
            usrCtr.CreateNewUser(register);
            var error = usrCtr.CreateNewUser(register);
            var retConflictObjRes = new ConflictObjectResult(new JsonObject());
            if (error.GetType() == retConflictObjRes.GetType())
                Assert.Pass();
            Assert.Fail();
        }

        [Test]
        public void TestCreateUserInvalid()
        {
            var options = new DbContextOptionsBuilder<AppDbContext>()
                .UseInMemoryDatabase(databaseName: "InMemoryDatabase")
                .Options;
            var db = new AppDbContext(options);
            var register = new RegisterClass
            {
                Email = null,
                Password = "password",
                Username = "username",
                Name = "name",
                Surname = "surname"
            };
            var usrCtr = new UsersController(db);
            var error = usrCtr.CreateNewUser(register);
            var badRequestObjs = new BadRequestObjectResult(new JsonObject());
            if (error.GetType() == badRequestObjs.GetType())
                Assert.Pass();
            Assert.Fail();
        }

        [Test]
        public void TestGetAllUsersValid()
        {
            var options = new DbContextOptionsBuilder<AppDbContext>()
                .UseInMemoryDatabase(databaseName: "InMemoryDatabase")
                .Options;
            var db = new AppDbContext(options);

        }


}