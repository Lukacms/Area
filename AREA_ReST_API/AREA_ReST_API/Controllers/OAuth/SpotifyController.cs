using AREA_ReST_API.Classes;
using AREA_ReST_API.Middleware;
using AREA_ReST_API.Models;
using AREA_ReST_API.Models.OAuth.Spotify;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;

namespace AREA_ReST_API.Controllers.OAuth;


[Authorize]
[ApiController]
[Route("oauth/[controller]")]
public class SpotifyController
{
    private readonly AppDbContext _context;
    private readonly HttpService _client = new ();
    private readonly string _spotifyUrl = "https://accounts.spotify.com/api/token";

    public SpotifyController(AppDbContext context, HttpService? client = null!)
    {
        _context = context;
        if (client == null)
            return;
        _client = client;
    }

    [HttpPost("")]
    public async Task<ActionResult> RequestSpotifyToken([FromBody] SpotifyModel spotifyCodes,
        [FromHeader] string authorization)

    {
        var decodedUser = JwtDecoder.Decode(authorization);
        var callbackUri = "http://localhost:8081/settings/services/spotify";
        var authentication = $"834ee184a29945b2a2a3dc8108a5bbf4:b589f784bb3f4b3897337acbfdd80f0d";  // NOTE to be changed when wanting program to really connect
        var base64str = Convert.ToBase64String(System.Text.Encoding.ASCII.GetBytes(authentication));
        var data = new Dictionary<string, string>
        {
            { "code", spotifyCodes.Code },
            { "redirect_uri", callbackUri },
            { "grant_type", "authorization_code" },
        };
        var result = await _client.PostAsync(_spotifyUrl, data, "application/x-www-forms-urlencoded", base64str);
        try
        {
            var jsonRes = JObject.Parse(result);
            var userService = new UserServicesModel
            {
                ServiceId = _context.Services.First(service => service.Name == "Spotify").Id,
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
    public async Task<ActionResult> RequestSpotifyTokenMobile([FromBody] SpotifyModel spotifyCodes,
        [FromHeader] string authorization)

    {
        var decodedUser = JwtDecoder.Decode(authorization);
        var callbackUri = "area://oauth2redirect";
        var authentication = $"authentication"; // NOTE to be changed when wanting program to really connect
        var base64str = Convert.ToBase64String(System.Text.Encoding.ASCII.GetBytes(authentication));
        var data = new Dictionary<string, string>
        {
            { "code", spotifyCodes.Code },
            { "redirect_uri", callbackUri },
            { "grant_type", "authorization_code" },
        };
        var result = await _client.PostAsync(_spotifyUrl, data, "application/x-www-forms-urlencoded", base64str);
        try
        {
            var jsonRes = JObject.Parse(result);
            var userService = new UserServicesModel
            {
                ServiceId = _context.Services.First(service => service.Name == "Spotify").Id,
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
