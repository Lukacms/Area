using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Text.Json.Nodes;
using AREA_ReST_API.Classes.Jwt;
using AREA_ReST_API.Classes.Login;
using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;

namespace AREA_ReST_API.Controllers;

[ApiController]
[Route("/api/[controller]")]

public class LoginController : ControllerBase
{
    private readonly AppDbContext _context;

    public LoginController(AppDbContext context)
    {
        _context = context;
    }
    
    [HttpPost("")]
    public ActionResult Login([FromBody] Credentials credentials, JwtOptions jwtOptions)
    {
        var email = credentials.Email;
        var password = credentials.Password;
        var askedUser = _context.Users.FirstOrDefault(user => user.Email == email);
        if (askedUser == null)
            return NotFound("User not found");
        if (askedUser.Password != password)
            return Unauthorized("Wrong password");
        var token = GenerateJwtToken(askedUser, jwtOptions);
        var json = new JsonObject { { "access_token", token } };
        return Ok(json);
    }

    private string GenerateJwtToken(UserModel user, JwtOptions jwtOptions)
    {
        var tokenHandler = new JwtSecurityTokenHandler();
        var key = Encoding.UTF8.GetBytes(jwtOptions.SigningKey);

        var claims = new List<Claim>
        {
            new Claim("username", user.Username),
            new Claim("email", user.Email),
            new Claim("status", user.Admin.ToString())
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