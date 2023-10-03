using System.IdentityModel.Tokens.Jwt;
using AREA_ReST_API.Classes.Jwt;
using AREA_ReST_API.Models;

namespace AREA_ReST_API.Middleware;

public class JwtDecoder
{
    public static DecodedUser Decode(string token)
    {
        var rawToken = token.Split(' ')[1];
        var handler = new JwtSecurityTokenHandler();
        var decodedToken = handler.ReadJwtToken(rawToken);
        var user = new DecodedUser
        {
            Id = int.Parse(decodedToken.Claims.First(claim => claim.Type == "id").Value),
            Username = decodedToken.Claims.First(claim => claim.Type == "username").Value,
            Email = decodedToken.Claims.First(claim => claim.Type == "email").Value,
            Admin = (decodedToken.Claims.First(claim => claim.Type == "admin").Value == "True")
        };
        return user;
    }
}