using System.Text.Json.Nodes;
using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AREA_ReST_API.Controllers;

[Authorize]
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
        newUserAction.Countdown = newUserAction.Timer;
        var userAction = _context.UserActions.Add(newUserAction);
        _context.SaveChanges();
        return new CreatedResult("UserAction successfully created", userAction.Entity);
    }

    [HttpDelete("{userActionId:int}")]
    public ActionResult DeleteUserAction([AsParameters] int userActionId)
    {
        var deletedUserAction = _context.UserActions.FirstOrDefault(userAction => userAction.Id == userActionId);
        if (deletedUserAction == null)
            return new NotFoundObjectResult(new JsonObject { { "message", "UserAction not found" } });
        _context.UserActions.Remove(deletedUserAction);
        _context.SaveChanges();
        return new OkObjectResult(new JsonObject { { "message", "UserAction successfully deleted" } });
    }
}