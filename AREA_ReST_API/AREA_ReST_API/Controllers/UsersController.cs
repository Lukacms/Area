using System.IdentityModel.Tokens.Jwt;
using System.Net.Mail;
using System.Security.Claims;
using System.Text;
using System.Text.Json.Nodes;
using AREA_ReST_API.Classes.Jwt;
using AREA_ReST_API.Classes.Login;
using AREA_ReST_API.Classes.Register;
using AREA_ReST_API.Middleware;
using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;

namespace AREA_ReST_API.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]

public class UsersController : ControllerBase
{
    private readonly AppDbContext _context;

    public UsersController(AppDbContext context)
    {
        _context = context;
    }
    
    [HttpGet("")]
    public ActionResult<IEnumerable<UsersModel>> GetAllUsers([FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);
        if (decodedUser.Admin != true)
            return new UnauthorizedObjectResult(new JsonObject{{"message", "Not authorize to get data"}});
        return new OkObjectResult(_context.Users.ToList());
    }

    [HttpGet("{id:int}")]
    public ActionResult<UsersModel?> GetUser([AsParameters] int id, [FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);
        if (decodedUser.Admin != true)
            return new UnauthorizedObjectResult(new JsonObject{{"message", "Not authorize to get data"}});
        var requestedUser = _context.Users.FirstOrDefault(user => user.Id == id);
        if (requestedUser == null)
            return new NotFoundObjectResult("User not found");
        return new OkObjectResult(requestedUser);
    }

    [HttpGet("me")]
    public ActionResult<UsersModel?> GetMe([FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);
        var requestedUser = _context.Users.FirstOrDefault(user => user.Id == decodedUser.Id);
        if (requestedUser == null)
            return new NotFoundObjectResult(new JsonObject { { "message", "User not found" } });
        return new OkObjectResult(requestedUser);
    }
    
    [HttpDelete("{id:int}")]
    public ActionResult DeleteUser([AsParameters] int id)
    {
        var deletedUser = _context.Users.FirstOrDefault(user => user.Id == id);
        if (deletedUser == null)
            return new NotFoundObjectResult(new JsonObject {{"message", "User does not exist"}});
        _context.Users.Remove(deletedUser);
        _context.SaveChanges();
        return new OkObjectResult(new JsonObject {{"message", "User successfully deleted"}});
    }
    
    [AllowAnonymous]
    [HttpPost("register")]
    public ActionResult CreateNewUser([FromBody] RegisterClass userInfo)
    {
        var checkedUser = _context.Users.FirstOrDefault(user => user.Email == userInfo.Email);
        if (checkedUser != null)
            return new ConflictObjectResult(new JsonObject { { "message", "Email is already used" } });
        if (!IsUserValid(userInfo))
            return new BadRequestObjectResult(new JsonObject { { "message", "Request is not valid" } });
        var hashPassword = BCrypt.Net.BCrypt.EnhancedHashPassword(userInfo.Password, 13);
        var newUser = new UsersModel
        {
            Username = userInfo.Username,
            Email = userInfo.Email,
            Password = hashPassword,
            Name = userInfo.Name,
            Surname = userInfo.Surname,
            Admin = false,
        };
        var user = _context.Users.Add(newUser);
        _context.SaveChanges(); 
        return new CreatedResult("URI", user.Entity);
    }

    private static bool IsUserValid(RegisterClass newUser)
    {
        try {
            var addr = new MailAddress(newUser.Email);
        } catch {
            return false;
        }
        return !newUser.Username.IsNullOrEmpty() && !newUser.Name.IsNullOrEmpty() && !newUser.Password.IsNullOrEmpty();
    }
    
    [AllowAnonymous]
    [HttpPost("login")]
    public ActionResult LoginUser([FromBody] Credentials credentials, JwtOptions jwtOptions)
    {
        var email = credentials.Email;
        var password = credentials.Password;
        var requestedUser = _context.Users.FirstOrDefault(user => user.Email == email);
        if (requestedUser == null)
            return new NotFoundObjectResult(new JsonObject { { "message", "User not found" } });
        if (email.IsNullOrEmpty() || password.IsNullOrEmpty())
            return new BadRequestObjectResult(new JsonObject { { "message", "Request is not valid" } });
        if (BCrypt.Net.BCrypt.EnhancedVerify(password, requestedUser.Password) == false)
            return new UnauthorizedObjectResult(new JsonObject {{"message", "Wrong password" }});
        var token = GenerateJwtToken(requestedUser, jwtOptions);
        return new OkObjectResult(new JsonObject { { "access_token", token } });
    }
    
    private static string GenerateJwtToken(UsersModel user, JwtOptions jwtOptions)
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
            Issuer = jwtOptions.Issuer,
            Audience = jwtOptions.Audience,
            Expires = DateTime.Now.AddYears(1),
            SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256)
        };
        var token = tokenHandler.CreateToken(tokenDescriptor);
        var jwt = tokenHandler.WriteToken(token);
        return jwt;
    }

    [HttpPut("")]
    public ActionResult ModifyUser([FromBody] UsersModel modifiedUser, [FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);
        if (!decodedUser.Admin)
            return new UnauthorizedObjectResult(new JsonObject
                { { "message", "You are not authorized to modify this user" } });
        if (modifiedUser.Name.IsNullOrEmpty())
            return new BadRequestObjectResult(new JsonObject { {"message", "Name cannot be empty or null" } });
        if (modifiedUser.Surname.IsNullOrEmpty())
            return new BadRequestObjectResult(new JsonObject { {"message", "Surname cannot be empty or null" } });
        if (modifiedUser.Username.IsNullOrEmpty())
            return new BadRequestObjectResult(new JsonObject { {"message", "Username cannot be empty or null" } });
        if (modifiedUser.Password.IsNullOrEmpty())
            return new BadRequestObjectResult(new JsonObject { {"message", "Password cannot be empty or null" } });
        if (modifiedUser.Email.IsNullOrEmpty())
            return new BadRequestObjectResult(new JsonObject { {"message", "Email cannot be empty or null" } });
        var hashedPassword = BCrypt.Net.BCrypt.EnhancedHashPassword(modifiedUser.Password, 13)!;
        modifiedUser.Password = hashedPassword;
        var user = _context.Users.Update(modifiedUser);
        _context.SaveChanges();
        return new CreatedResult("User successfully modified", user.Entity);
    }
}