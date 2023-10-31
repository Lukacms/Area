using AREA_ReST_API.Classes;
using AREA_ReST_API.Middleware;
using AREA_ReST_API.Models;
using AREA_ReST_API.Models.OAuth.Github;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;

namespace AREA_ReST_API.Controllers.OAuth;

[Authorize]
[ApiController]
[Route("oauth/[controller]")]

public class GithubController
{
    private readonly AppDbContext _context;
    private readonly HttpService _client;
    private readonly string _githubUri = "https://github.com/login/oauth/access_token";

    public GithubController(AppDbContext context)
    {
        _context = context;
        _client = new HttpService();
    }

    [HttpPost("")]
    public async Task<ActionResult> RequestGithubToken([FromBody] GithubModel githubCode, [FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);
        const string callbackUri = "http%3A%2F%2Flocalhost:8091%2Fsettings%2Fservices%2Fgithub";
        var query = $"?client_id=Iv1.f47bfd491f94b532&client_secret=c8f7c650f3d4c47462ddbf0ca06b1113478c9f6e&code={githubCode.Code}&redirect_uri={callbackUri}";
        var result = await _client.PostWithQueryAsync(_githubUri, query, "application/x-www-forms-urlencoded", "application/json");
        var jsonRes = JObject.Parse(result);
        var userService = new UserServicesModel
        {
            ServiceId = _context.Services.First(service => service.Name == "Github").Id,
            UserId = decodedUser.Id,
            AccessToken = jsonRes["access_token"]!.ToString(),
            RefreshToken = jsonRes["refresh_token"]!.ToString(),
            ExpiresIn = (int)jsonRes["expires_in"]!,
        };
        Console.WriteLine(jsonRes);
        _context.UserServices.Add(userService);
        await _context.SaveChangesAsync();
        return new OkResult();
    }

    [HttpPost("mobile")]
    public async Task<ActionResult> RequestGithubTokenMobile([FromBody] GithubModel githubCode, [FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);
        const string callbackUri = "area%3A%2F%2Foauth2redirect";
        var query = $"?client_id=Iv1.f47bfd491f94b532&client_secret=c8f7c650f3d4c47462ddbf0ca06b1113478c9f6e&code={githubCode.Code}&redirect_uri={callbackUri}";
        var result = await _client.PostWithQueryAsync(_githubUri, query, "application/x-www-forms-urlencoded", "application/json");
        var jsonRes = JObject.Parse(result);
        var userService = new UserServicesModel
        {
            ServiceId = _context.Services.First(service => service.Name == "Github").Id,
            UserId = decodedUser.Id,
            AccessToken = jsonRes["access_token"]!.ToString(),
            RefreshToken = jsonRes["refresh_token"]!.ToString(),
            ExpiresIn = (int)jsonRes["expires_in"]!,
        };
        Console.WriteLine(jsonRes);
        _context.UserServices.Add(userService);
        await _context.SaveChangesAsync();
        return new OkResult();
    }
}

