using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Text.Json.Nodes;
using AREA_ReST_API.Classes.Jwt;
using AREA_ReST_API.Classes.Login;
using AREA_ReST_API.Classes.Register;
using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;

namespace AREA_ReST_API.Controllers;

[Authorize]
[ApiController]
[Route("api/Users/")]

public class UserController : ControllerBase
{
    private readonly AppDbContext _context;

    public UserController(AppDbContext context)
    {
        _context = context;
    }
    
    [HttpGet("")]
    public ActionResult<IEnumerable<UserModel>> GetAllUsers()
    {
        return new OkObjectResult(_context.Users.ToList());
    }

    [HttpGet("{id:int}")]
    public ActionResult<UserModel?> GetUser([AsParameters] int id)
    {
        var askedUser = _context.Users.FirstOrDefault(user => user.Id == id);
        if (askedUser == null)
            return new NotFoundObjectResult("User not found");
        return new OkObjectResult(askedUser);
    }
    
    [HttpDelete("{id:int}")]
    public ActionResult DeleteUser([AsParameters] int id)
    {
        var deletedUser = _context.Users.FirstOrDefault(user => user.Id == id);
        if (deletedUser == null)
            return new NotFoundObjectResult(new JsonObject {{"message", "User does not exist"}});
        _context.Users.Remove(deletedUser);
        _context.SaveChanges();
        return new OkObjectResult(new JsonObject {{"message", "User successfully delete"}});
    }
    
    [HttpPost("register")]
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
    
    [HttpPost("login")]
    public ActionResult LoginUser([FromBody] Credentials credentials, JwtOptions jwtOptions)
    {
        var email = credentials.Email;
        var password = credentials.Password;
        var askedUser = _context.Users.FirstOrDefault(user => user.Email == email);
        if (askedUser == null)
            return new NotFoundObjectResult(new JsonObject { { "message", "User not found" } });
        if (askedUser.Password != password)
            return new UnauthorizedObjectResult(new JsonObject {{"message", "Wrong password" }});
        var token = GenerateJwtToken(askedUser, jwtOptions);
        return new OkObjectResult(new JsonObject { { "access_token", token } });
    }
    
    private string GenerateJwtToken(UserModel user, JwtOptions jwtOptions)
    {
        var tokenHandler = new JwtSecurityTokenHandler();
        var key = Encoding.UTF8.GetBytes(jwtOptions.SigningKey);

        var claims = new List<Claim>
        {
            new Claim("username", user.Username),
            new Claim("email", user.Email),
            new Claim("admin", user.Admin.ToString()),
            new Claim("id", user.Id.ToString()),
        };

        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(claims),
            Expires = DateTime.Now.AddMinutes(120),
            Issuer = jwtOptions.Issuer,
            Audience = jwtOptions.Audience,
            SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256)
        };
        var token = tokenHandler.CreateToken(tokenDescriptor);
        var jwt = tokenHandler.WriteToken(token);
        return jwt;
    }
}