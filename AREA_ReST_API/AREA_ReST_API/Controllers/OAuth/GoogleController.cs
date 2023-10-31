using AREA_ReST_API.Classes;
using AREA_ReST_API.Middleware;
using AREA_ReST_API.Models;
using AREA_ReST_API.Models.OAuth.Google;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;

namespace AREA_ReST_API.Controllers.OAuth;


[Authorize]
[ApiController]
[Route("oauth/[controller]")]
public class GoogleController
{
    private readonly AppDbContext _context;
    private readonly HttpService _client;
    private readonly string _googleUrl = "https://oauth2.googleapis.com/token";

    public GoogleController(AppDbContext context)
    {
        _context = context;
        _client = new HttpService();
    }

    [HttpPost("")]
    public async Task<ActionResult> RequestGoogleToken([FromBody] GoogleModel googleCodes, [FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);
        var callbackUri = "http://localhost:8091/settings/services/google";
        var data = new Dictionary<string, string>
        {
            { "code", googleCodes.Code },
            { "client_id", "315267877885-2np97bt3qq9s6er73549ldrfme2b67pi.apps.googleusercontent.com" },
            { "client_secret", "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" },
            { "redirect_uri", callbackUri},
            { "grant_type", "authorization_code" },
        };
        var result = await _client.PostAsync(_googleUrl, data, "application/x-www-forms-urlencoded", "");
        var jsonRes = JObject.Parse(result);
        var userService = new UserServicesModel
        {
            ServiceId = _context.Services.First(service => service.Name == "Google").Id,
            UserId = decodedUser.Id,
            AccessToken = jsonRes["access_token"]!.ToString(),
            RefreshToken = jsonRes["refresh_token"]!.ToString(),
            ExpiresIn = (int)jsonRes["expires_in"]!,
        };
        _context.UserServices.Add(userService);
        await _context.SaveChangesAsync();
        return new OkResult();
    }

    [HttpPost("mobile")]
    public async Task<ActionResult> RequestGoogleTokenMobile([FromBody] GoogleModel googleCodes, [FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);
        var callbackUri = "com.googleusercontent.apps.315267877885-lkqq49r6v587fi9pduggbdh9dr1j69me:/";
        var data = new Dictionary<string, string>
        {
            { "code", googleCodes.Code },
            { "client_id", "315267877885-lkqq49r6v587fi9pduggbdh9dr1j69me.apps.googleusercontent.com" },
            { "redirect_uri", callbackUri },
            { "grant_type", "authorization_code" },
        };
        var result = await _client.PostAsync(_googleUrl, data, "application/x-www-forms-urlencoded", "");
        var jsonRes = JObject.Parse(result);
        Console.WriteLine(jsonRes);
        var userService = new UserServicesModel
        {
            ServiceId = _context.Services.First(service => service.Name == "Google").Id,
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