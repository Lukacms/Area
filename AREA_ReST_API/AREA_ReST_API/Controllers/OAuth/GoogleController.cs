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
    private readonly HttpService _client = new ();
    private readonly string _googleUrl = "https://oauth2.googleapis.com/token";

    public GoogleController(AppDbContext context, HttpService? client = null!)
    {
        _context = context;
        if (client == null)
            return;
        _client = client;
    }

    [HttpPost("")]
    public async Task<ActionResult> RequestGoogleToken([FromBody] GoogleModel googleCodes, [FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);
        var callbackUri = "http://localhost:8081/settings/services/google";
        var data = new Dictionary<string, string>
        {
            { "code", googleCodes.Code },
            { "client_id", "client id" }, // NOTE to be changed when wanting program to really connect
            { "client_secret", "client secret" }, // NOTE to be changed when wanting program to really connect
            { "redirect_uri", callbackUri},
            { "grant_type", "authorization_code" },
        };
        var result = await _client.PostAsync(_googleUrl, data, "application/x-www-forms-urlencoded", "");
        try
        {
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
        catch
        {
            return new BadRequestObjectResult(result);
        }
    }

    [HttpPost("mobile")]
    public async Task<ActionResult> RequestGoogleTokenMobile([FromBody] GoogleModel googleCodes, [FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);
        var callbackUri = "com.googleusercontent.apps.315267877885-lkqq49r6v587fi9pduggbdh9dr1j69me:/";
        var data = new Dictionary<string, string>
        {
            { "code", googleCodes.Code },
            { "client_id", "client id" }, // NOTE to be changed when wanting program to really connect
            { "redirect_uri", callbackUri },
            { "grant_type", "authorization_code" },
        };
        var result = await _client.PostAsync(_googleUrl, data, "application/x-www-forms-urlencoded", "");
        try
        {
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
        catch
        {
            return new BadRequestObjectResult(result);
        }
    }
}