using System.Text.Json.Nodes;
using AREA_ReST_API.Classes.Jwt;
using AREA_ReST_API.Middleware;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using AREA_ReST_API.Models;

namespace AREA_ReST_API.Controllers;

[Authorize]
[ApiController]
[Route("api/Areas/")]

public class AreaController
{
    private readonly AppDbContext _context;

    public AreaController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet("")]
    public ActionResult<List<AreaModel>> GetUserAreas([FromQuery] int userId)
    {
        var area = _context.Areas.Where(area => area.User == userId).ToList();
        return new OkObjectResult(area);
    }

    [HttpGet("Area")]
    public ActionResult<AreaModel> GetUserArea([FromQuery] int userId, [FromQuery] int areaId, [FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.JwtDecode(authorization);
        if (decodedUser.Id != userId && decodedUser.Admin == false)
            return new UnauthorizedObjectResult(new JsonObject { { "message", "Cannot access to the information" } });
        var area = _context.Areas.FirstOrDefault(area => area.User == userId && area.Id == areaId);
        if (area == null)
            return new NotFoundObjectResult(new JsonObject { {"message", "Area not found"}});
        return new OkObjectResult(area);
    }
}