using System.Text.Json.Nodes;
using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Mvc;

namespace AREA_ReST_API.Controllers;

[ApiController]
[Route("api/[controller]")]

public class UserActionsController
{
    private readonly AppDbContext _context;

    public UserActionsController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet("{areaId:int}")]
    public ActionResult<UserActionsModel> GetUserActionByAreaId([AsParameters] int areaId)
    {
        var requestedUserAction = _context.UserActions.FirstOrDefault(userAction => userAction.AreaId == areaId);
        if (requestedUserAction == null)
            return new NotFoundObjectResult(new JsonObject { { "message", "UserAction not found" } });
        return new OkObjectResult(requestedUserAction);
    }
    
    [HttpPost("")]
    public ActionResult CreateNewUserAction([FromBody] UserActionsModel newUserAction)
    {
        _context.UserActions.Add(newUserAction);
        _context.SaveChanges();
        return new OkObjectResult(new JsonObject { { "message", "UserAction successfully created" } });
    }
}