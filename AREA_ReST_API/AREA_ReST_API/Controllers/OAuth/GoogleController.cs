using System.Text.Json.Nodes;
using AREA_ReST_API.Classes;
using AREA_ReST_API.Middleware;
using AREA_ReST_API.Models;
using AREA_ReST_API.Models.OAuth.Google;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AREA_ReST_API.Controllers.OAuth;


[Authorize]
[ApiController]
[Route("oauth/[controller]")]
public class GoogleController
{
    private readonly AppDbContext _context;
    private readonly HttpService _client;
    private readonly string googleUrl = "https://oauth2.googleapis.com/token";

    public GoogleController(AppDbContext context)
    {
      _context = context;
      _client = new HttpService();
    }

    [HttpPost("")]
    public ActionResult RequestGoogleToken([FromBody] GoogleModel googleCodes, [FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);
        var callbackUri = "http://localhost:8080/oauth/Google/callback/" + decodedUser.Id;
        var json = new JsonObject
        {
            { "code", googleCodes.Code },
            { "client_id", "315267877885-2np97bt3qq9s6er73549ldrfme2b67pi.apps.googleusercontent.com" },
            { "client_secret", "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" },
            { "redirect_uri", callbackUri},
            { "grant_type", "authorization_code" },
        };
        var result = _client.PostAsync(callbackUri, json.ToString(), "application/x-www-form-urlencoded");
      return new OkResult();
    }

    [HttpPost("callback/{userId:int}")]
    public ActionResult CreateGoogleToken([FromBody] GoogleCallbackModel googleResponse, [AsParameters] int userId)
    {
      var userService = new UserServicesModel
      {
          ServiceId = _context.Services.First(service => service.Name == "Google").Id,
          UserId = userId,
          RefreshToken = googleResponse.RefreshToken,
          AccessToken = googleResponse.AccessToken
      };
      _context.UserServices.Add(userService);
      _context.SaveChanges();
      return new OkResult();
    }
}