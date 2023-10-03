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

    public DiscordController(AppDbContext context)
    {
        _context = context;
    }

    [HttpPost("")]
    public ActionResult RequestDiscordToken()
    {
        return new OkResult();
    }
    
    [HttpPost("callback")]
    public ActionResult CreateDiscordToken([FromBody] DiscordCallbackModel discordResponse)
    {
        var userService = new UserServicesModel
        {
            ServiceId = _context.Services.First(service => service.Name == "Discord").Id,
            UserId = 0,
            AccessToken = discordResponse.AccessToken,
            RefreshToken = discordResponse.RefreshToken,
        };
        _context.UserServices.Add(userService);
        _context.SaveChanges();
        return new OkResult();
    }
}