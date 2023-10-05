using System.Text.Json.Nodes;
using AREA_ReST_API.Classes;
using AREA_ReST_API.Middleware;
using AREA_ReST_API.Models;
using AREA_ReST_API.Models.OAuth.Discord;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AREA_ReST_API.Controllers.OAuth;

[Authorize]
[ApiController]
[Route("oauth/[controller]")]

public class DiscordController
{
    private readonly AppDbContext _context;
    private readonly HttpService _client;

    public DiscordController(AppDbContext context)
    {
        _context = context;
        _client = new HttpService();
    }

    [HttpPost("")]
    public async Task<ActionResult> RequestDiscordToken([FromBody] DiscordModel discordCode ,[FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);
        var callbackUri = "http://localhost:8080/oauth/Discord/callback/" + decodedUser.Id;
        var json = new JsonObject
        {
            { "code", discordCode.Code },
            { "grant_type", "authorization_code" },
            { "redirect_uri", callbackUri}
        };
        var result = _client.PostAsync(callbackUri, json.ToString(), "application/x-www-form-urlencoded");
        return new OkResult();
    }

    [AllowAnonymous]
    [HttpPost("callback/{userId:int}")]
    public ActionResult CreateDiscordToken([AsParameters] int userId, [FromBody] DiscordCallbackModel discordResponse)
    {
        var userService = new UserServicesModel
        {
            ServiceId = _context.Services.First(service => service.Name == "Discord").Id,
            UserId = userId,
            AccessToken = discordResponse.AccessToken,
            RefreshToken = discordResponse.RefreshToken,
        };
        _context.UserServices.Add(userService);
        _context.SaveChanges();
        return new OkResult();
    }
}