using AREA_ReST_API.Classes;
using AREA_ReST_API.Middleware;
using AREA_ReST_API.Models;
using AREA_ReST_API.Models.OAuth.Discord;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;

namespace AREA_ReST_API.Controllers.OAuth;

[Authorize]
[ApiController]
[Route("oauth/[controller]")]

public class DiscordController
{
    private readonly AppDbContext _context;
    private readonly HttpService _client;
    private readonly string _discordUri = "https://discord.com/api/oauth2/token";

    public DiscordController(AppDbContext context)
    {
        _context = context;
        _client = new HttpService();
    }

    [HttpPost("")]
    public async Task<ActionResult> RequestDiscordToken([FromBody] DiscordModel discordCode, [FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);
        var callbackUri = "http://localhost:8081/settings/services/discord";
        var authentication = $"1158738215704985681:RKMdtaTvRUZ9Hoz9QUyM_t_d3jiPQz4N";
        var base64str = Convert.ToBase64String(System.Text.Encoding.ASCII.GetBytes(authentication));
        var data = new Dictionary<string, string>()
        {
          {"client_id", "1158738215704985681"},
          {"client_secret", "RKMdtaTvRUZ9Hoz9QUyM_t_d3jiPQz4N"},
          {"grant_type", "authorization_code"},
          {"code", discordCode.Code},
          {"redirect_uri", callbackUri},
        };
        var result = await _client.PostAsync(_discordUri, data, "application/x-www-forms-urlencoded", base64str);
        var jsonRes = JObject.Parse(result);
        var userService = new UserServicesModel
        {
            ServiceId = _context.Services.First(service => service.Name == "Discord").Id,
            UserId = decodedUser.Id,
            AccessToken = jsonRes["access_token"]!.ToString(),
            RefreshToken = jsonRes["refresh_token"]!.ToString(),
            ExpiresIn = (int)jsonRes["expires_in"]!,
        };
        _context.UserServices.Add(userService);
        await _context.SaveChangesAsync();
        return new OkResult();
    }
}