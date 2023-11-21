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
    private readonly HttpService _client = new ();
    private readonly string _githubUri = "https://github.com/login/oauth/access_token";

    public GithubController(AppDbContext context, HttpService? client = null!)
    {
        _context = context;
        if (client == null)
            return;
        _client = client;
    }

    [HttpPost("")]
    public async Task<ActionResult> RequestGithubToken([FromBody] GithubModel githubCode, [FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);
        const string callbackUri = "http%3A%2F%2Flocalhost:8081%2Fsettings%2Fservices%2Fgithub";
        var query = $"?client_id=client id&client_secret=client secret&code={githubCode.Code}&redirect_uri={callbackUri}";  // NOTE to be changed when wanting program to really connect
        var result = await _client.PostWithQueryAsync(_githubUri, query, "application/x-www-forms-urlencoded", "application/json");
        try
        {
            var jsonRes = JObject.Parse(result);
            var userService = new UserServicesModel
            {
                ServiceId = _context.Services.First(service => service.Name == "Github").Id,
                UserId = decodedUser.Id,
                AccessToken = jsonRes["access_token"]!.ToString(),
                RefreshToken = jsonRes["refresh_token"]!.ToString(),
                ExpiresIn = (int)jsonRes["expires_in"]!,
            };
            _context.UserServices.Add(userService);
            await _context.SaveChangesAsync();
            return new OkResult();
        }
        catch
        {
            return new BadRequestObjectResult(result);
        }
    }

    [HttpPost("mobile")]
    public async Task<ActionResult> RequestGithubTokenMobile([FromBody] GithubModel githubCode, [FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);
        const string callbackUri = "area%3A%2F%2Foauth2redirect";
        var query = $"?client_id=client id&client_secret=client secret&code={githubCode.Code}&redirect_uri={callbackUri}"; // NOTE to be changed when wanting program to really connect
        var result = await _client.PostWithQueryAsync(_githubUri, query, "application/x-www-forms-urlencoded", "application/json");
        try
        {
            var jsonRes = JObject.Parse(result);
            var userService = new UserServicesModel
            {
                ServiceId = _context.Services.First(service => service.Name == "Github").Id,
                UserId = decodedUser.Id,
                AccessToken = jsonRes["access_token"]!.ToString(),
                RefreshToken = jsonRes["refresh_token"]!.ToString(),
                ExpiresIn = (int)jsonRes["expires_in"]!,
            };
            _context.UserServices.Add(userService);
            await _context.SaveChangesAsync();
            return new OkResult();
        }
        catch
        {
            return new BadRequestObjectResult(result);
        }
    }
}

