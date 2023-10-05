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

    public GoogleController(AppDbContext context)
    {
      _context = context;
    }

    [HttpPost("")]
    public ActionResult RequestGoogleToken()
    {
      return new OkResult();
    }

    [HttpPost("callback/{id}")]
    public ActionResult CreateGoogleToken([FromBody] GoogleCallbackModel googleResponse)
    {
      return new OkResult();
    }
}