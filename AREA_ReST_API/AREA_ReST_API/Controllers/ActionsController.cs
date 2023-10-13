using System.Text.Json.Nodes;
using AREA_ReST_API.Middleware;
using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;

namespace AREA_ReST_API.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]

public class ActionsController
{
    private readonly AppDbContext _context;

    public ActionsController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet("")]
    public ActionResult<List<ActionsModel>> GetAllActions()
    {
        var actions = _context.Actions.ToList();
        return new OkObjectResult(actions);
    }

    [HttpGet("{serviceId:int}")]
    public ActionResult<List<ActionsModel>> GetActionsByServiceId([AsParameters] int serviceId)
    {
        var requestedActions = _context.Actions.Where(action => action.ServiceId == serviceId).ToList();
        return new OkObjectResult(requestedActions);
    }

    [HttpPost("")]
    public ActionResult CreateNewAction([FromBody] ActionsModel newAction, [FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);

        if (!decodedUser.Admin)
          return new UnauthorizedObjectResult(new JsonObject{{"message", "You are not allowed to add a reaction"}});
        if (newAction.Name.IsNullOrEmpty())
            return new BadRequestObjectResult(new JsonObject { { "message", "Reaction name is empty" } });
        if (newAction.Endpoint.IsNullOrEmpty())
            return new BadRequestObjectResult(new JsonObject { { "message", "Reaction endpoint is empty" } });
        if (newAction.ServiceId == 0)
            return new BadRequestObjectResult(new JsonObject { { "message", "ServiceId cannot be equal to zero" } });
        var service = _context.Services.FirstOrDefault(s => s.Id == newAction.ServiceId);
        if (service == null)
            return new BadRequestObjectResult(new JsonObject { { "message", $"There's no services with this ServiceId" } });
        var registeredAction = _context.Actions.Add(newAction);
        _context.SaveChanges();
        return new CreatedResult("Action successfully created", registeredAction.Entity);
    }

    [HttpDelete("{actionId:int}")]
    public ActionResult DeleteAction([AsParameters] int actionId, [FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);
        var deletedAction = _context.Actions.FirstOrDefault(action => action.Id == actionId);

        if (!decodedUser.Admin)
            return new UnauthorizedObjectResult(new JsonObject{{"message", "You are not authorized to do this"}});
        if (deletedAction == null)
            return new NotFoundObjectResult(new JsonObject{{"message", "No Action found to delete"}});
        _context.Actions.Remove(deletedAction);
        _context.SaveChanges();
        return new OkObjectResult(new JsonObject{{"message", "Action successfully deleted"}});
    }
}
