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

public class ReactionsController
{
    private readonly AppDbContext _context;

    public ReactionsController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet("")]
    public ActionResult<List<ActionsModel>> GetAllReactions()
    {
        var actions = _context.Reactions.ToList();
        return new OkObjectResult(actions);
    }

    [HttpGet("{serviceId:int}")]
    public ActionResult<List<ReactionsModel>> GetActionsByServiceId([AsParameters] int serviceId)
    {
        var requestedActions = _context.Reactions.Where(action => action.ServiceId == serviceId).ToList();
        return new OkObjectResult(requestedActions);
    }

    [HttpPost("")]
    public ActionResult CreateNewReaction([FromBody] ReactionsModel newReaction, [FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);

        if (!decodedUser.Admin)
          return new UnauthorizedObjectResult(new JsonObject{{"message", "You are not allowed to add a reaction"}});
        if (newReaction.Name.IsNullOrEmpty())
            return new BadRequestObjectResult(new JsonObject { { "message", "Reaction name is empty" } });
        if (newReaction.Endpoint.IsNullOrEmpty())
            return new BadRequestObjectResult(new JsonObject { { "message", "Reaction endpoint is empty" } });
        if (newReaction.ServiceId == 0)
            return new BadRequestObjectResult(new JsonObject { { "message", "ServiceId cannot be equal to zero" } });
        var service = _context.Services.FirstOrDefault(s => s.Id == newReaction.ServiceId);
        if (service == null)
            return new BadRequestObjectResult(new JsonObject { { "message", $"There's no services with this ServiceId" } });
        var registeredReaction = _context.Reactions.Add(newReaction);
        _context.SaveChanges();
        return new CreatedResult("Reaction successfully created", registeredReaction.Entity);
    }

    [HttpPut("")]
    public ActionResult ModifyReaction([FromBody] ReactionsModel newReaction, [FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);

        if (!decodedUser.Admin)
          return new UnauthorizedObjectResult(new JsonObject{{"message", "You are not allowed to add a reaction"}});
        if (newReaction.Id == 0)
            return new BadRequestObjectResult(new JsonObject { { "message", "Should have an Id" } });
        if (newReaction.Name.IsNullOrEmpty())
            return new BadRequestObjectResult(new JsonObject { { "message", "Reaction name is empty" } });
        if (newReaction.Endpoint.IsNullOrEmpty())
            return new BadRequestObjectResult(new JsonObject { { "message", "Reaction endpoint is empty" } });
        if (newReaction.ServiceId == 0)
            return new BadRequestObjectResult(new JsonObject { { "message", "ServiceId cannot be equal to zero" } });
        var service = _context.Services.FirstOrDefault(s => s.Id == newReaction.ServiceId);
        if (service == null)
            return new BadRequestObjectResult(new JsonObject { { "message", $"There's no services with this ServiceId" } });
        var registeredReaction = _context.Reactions.Add(newReaction);
        _context.SaveChanges();
        return new CreatedResult("Reaction successfully created", registeredReaction.Entity);
    }

    [HttpDelete("{reactionId:int}")]
    public ActionResult DeleteAction([AsParameters] int reactionId, [FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);
        var deletedReaction = _context.Reactions.FirstOrDefault(action => action.Id == reactionId);

        if (!decodedUser.Admin)
            return new UnauthorizedObjectResult(new JsonObject{{"message", "You are not authorized to do this"}});
        if (deletedReaction == null)
            return new NotFoundObjectResult(new JsonObject{{"message", "No Reaction found to delete"}});
        _context.Reactions.Remove(deletedReaction);
        _context.SaveChanges();
        return new OkObjectResult(new JsonObject{{"message", "Reaction successfully deleted"}});
    }
}
