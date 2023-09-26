using System.Text.Json.Nodes;
using AREA_ReST_API.Classes.Jwt;
using AREA_ReST_API.Middleware;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using AREA_ReST_API.Models;

namespace AREA_ReST_API.Controllers;

[ApiController]
[Route("api/Areas/")]

public class AreaController
{
    private readonly AppDbContext _context;

    public AreaController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet("{userId:int}")]
    public ActionResult<List<AreaModel>> GetUserAreas([AsParameters] int userId)
    {
        var area = _context.Areas.Where(area => area.User == userId).ToList();
        return new OkObjectResult(area);
    }

    [HttpGet("{userId:int}/{areaId:int}")]
    public ActionResult<AreaModel> GetUserArea([AsParameters] int userId, [AsParameters] int areaId, [FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.JwtDecode(authorization);
        if (decodedUser.Id != userId && decodedUser.Admin == false)
            return new UnauthorizedObjectResult(new JsonObject { { "message", "Cannot access to the information" } });
        var area = _context.Areas.FirstOrDefault(area => area.User == userId && area.Id == areaId);
        if (area == null)
            return new NotFoundObjectResult(new JsonObject { {"message", "Area not found"}});
        return new OkObjectResult(area);
    }

    [HttpDelete("{areaId:int}")]
    public ActionResult DeleteArea([AsParameters] int areaId, [FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.JwtDecode(authorization);
        var deletedArea = _context.Areas.FirstOrDefault(area => area.Id == areaId);
        if (deletedArea == null)
            return new NotFoundObjectResult(new JsonObject { { "message", "Area does not exist" } });
        if (decodedUser.Id != deletedArea.User && decodedUser.Admin == false)
            return new UnauthorizedObjectResult(new JsonObject { { "message", "Not authorize to delete this area" } });
        _context.Areas.Remove(deletedArea);
        _context.SaveChanges();
        return new OkObjectResult(new JsonObject {{"message", "Area successfully deleted"}});
    }

    [HttpPut("")]
    public ActionResult ModifyArea([FromBody] AreaModel area, [FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.JwtDecode(authorization);
        if (area.User != decodedUser.Id && decodedUser.Admin == false)
            return new UnauthorizedObjectResult(new JsonObject { { "message", "Not authorize to modify this area" } });
        _context.Areas.Update(area);
        _context.SaveChanges();
        return new OkObjectResult(new JsonObject { { "message", "Area successfully update" } });
    }

    [HttpPost("")]
    public ActionResult CreateArea([FromBody] AreaModel area)
    {
        _context.Areas.Add(area);
        _context.SaveChanges();
        return new OkObjectResult(new JsonObject { { "message", "Area successfully create" } });
    }
}