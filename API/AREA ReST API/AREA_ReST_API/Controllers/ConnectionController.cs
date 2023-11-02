using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;

namespace AREA_ReST_API.Controllers;

[Route("[controller]")]

public class ConnectionController : ControllerBase
{
    private readonly AppDbContext _context;
    private readonly IConfiguration _config;

    public ConnectionController(AppDbContext context, IConfiguration config)
    {
        _context = context;
        _config = config;
    }
    
    [AllowAnonymous]
    [HttpPost("/Login")]
    public ActionResult GetAccessToken([FromBody] string email, string password)
    {
        var user = Authenticate(email, password);
        if (user == null)
            return NotFound("User not found");
        // var token = GenerateToken(user);
        return Ok();
    }

    private UserModel? Authenticate(string email, string password)
    {
        var currentUser = _context.Users.FirstOrDefault(user => user.Email.ToLower() == email.ToLower()
                                                                && user.Password == password);
        return currentUser;
    }

    /*private string GenerateToken(UserModel user)
    {
        var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["Jwt:Issuer"]));
        var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);
        var claims = new[]
        {
            new Claim(ClaimTypes.NameIdentifier, user.Email),
            new Claim(ClaimTypes.Role, user.Status.ToString()),
            new Claim(ClaimTypes.Email, user.Email)
        };
        var token = new JwtSecurityToken(_config["Jwt:Issuer"], _config["Jwt:Audience"],
            claims,
            expires: DateTime.Now.AddHours(1),
            signingCredentials: credentials);
        
        return new JwtSecurityTokenHandler().WriteToken(token);
    }*/
    
}