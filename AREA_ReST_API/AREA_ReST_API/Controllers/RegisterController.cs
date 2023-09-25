using System.Text.Json.Nodes;
using AREA_ReST_API.Classes.Register;
using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Mvc;

namespace AREA_ReST_API.Controllers;

[ApiController]
[Route("/api/[controller]")]

public class RegisterController
{
    private readonly AppDbContext _context;

    public RegisterController(AppDbContext context)
    {
        _context = context;
    }

    [HttpPost("")]
    public ActionResult CreateNewUser([FromBody] RegisterClass userInfo)
    {
        var checkedUser = _context.Users.FirstOrDefault(user => user.Email == userInfo.Email);
        if (checkedUser != null)
            return new ConflictObjectResult(new JsonObject { { "message", "Email is already used" } });
        var newUser = new UserModel
        {
            Username = userInfo.Username,
            Email = userInfo.Email,
            Password = userInfo.Password,
            Admin = false,
            Areas = null,
        };
        _context.Users.Add(newUser); 
        _context.SaveChanges(); 
        return new CreatedResult("URI", newUser);
    }
}