using AREA_ReST_API.Classes;
using AREA_ReST_API.Middleware;
using AREA_ReST_API.Models;
using AREA_ReST_API.Models.OAuth.Microsoft;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;

namespace AREA_ReST_API.Controllers.OAuth;


[Authorize]
[ApiController]
[Route("oauth/[controller]")]

public class MicrosoftController
{
    private readonly AppDbContext _context;
    private readonly HttpService _client = new ();
    private readonly string _microsoftUri = "https://login.microsoftonline.com/common/oauth2/v2.0/token";

    public MicrosoftController(AppDbContext context, HttpService? client = null!)
    {
        _context = context;
        if (client == null)
            return;
        _client = client;
    }

    [HttpPost("")]
    public async Task<ActionResult> RequestMicrosoftToken([FromBody] MicrosoftModel microsoftCode,
        [FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);
        var callbackUri = "http://localhost:8081/settings/services/microsoft";
        var authentication = "";
        var base64str = Convert.ToBase64String(System.Text.Encoding.ASCII.GetBytes(authentication));
        var data = new Dictionary<string, string>()
        {
            {"client_id", "5731d8cc-7d4b-47dc-812f-f4615f65b38d"},
            {"client_secret", "eHV8Q~MgohheH_~OxgTyRgbht8RvdEIZ5MkWQc50"},
            {"grant_type", "authorization_code"},
            {"code", microsoftCode.Code},
            {"redirect_uri", callbackUri}
        };
        var result = await _client.PostAsync(_microsoftUri, data, "application/x-www-forms-urlencoded", base64str);
        try
        {
            var microsoftService = _context.Services.First(s => s.Name == "Microsoft");
            var jsonRes = JObject.Parse(result);
            var microsoftUserService = new UserServicesModel
            {
                UserId = decodedUser.Id,
                ServiceId = microsoftService.Id,
                AccessToken = jsonRes["access_token"]!.ToString(),
                RefreshToken = jsonRes["refresh_token"]!.ToString(),
                ExpiresIn = (int)jsonRes["expires_in"]!,
            };
            _context.UserServices.Add(microsoftUserService);
            await _context.SaveChangesAsync();
            return new OkResult();
        }
        catch
        {
            return new BadRequestObjectResult(result);
        }
    }

    [HttpPost("mobile")]
    public async Task<ActionResult> RequestMicrosoftTokenMobile([FromBody] MicrosoftModel microsoftCode,
        [FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);
        var callbackUri = "area://oauth2redirect";
        var authentication = "";
        var base64str = Convert.ToBase64String(System.Text.Encoding.ASCII.GetBytes(authentication));
        var data = new Dictionary<string, string>()
        {
            {"client_id", "5731d8cc-7d4b-47dc-812f-f4615f65b38d"},
            {"grant_type", "authorization_code"},
            {"code", microsoftCode.Code},
            {"redirect_uri", callbackUri}
        };
        var result = await _client.PostAsync(_microsoftUri, data, "application/x-www-forms-urlencoded", base64str);
        try
        {
            var microsoftService = _context.Services.First(s => s.Name == "Microsoft");
            var jsonRes = JObject.Parse(result);
            var microsoftUserService = new UserServicesModel
            {
                UserId = decodedUser.Id,
                ServiceId = microsoftService.Id,
                AccessToken = jsonRes["access_token"]!.ToString(),
                RefreshToken = jsonRes["refresh_token"]!.ToString(),
                ExpiresIn = (int)jsonRes["expires_in"]!,
            };
            _context.UserServices.Add(microsoftUserService);
            await _context.SaveChangesAsync();
            return new OkResult();
        }
        catch
        {
            return new BadRequestObjectResult(result);
        }
    }
}