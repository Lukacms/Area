using System.Text.Json.Nodes;
using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Microsoft.IdentityModel.Tokens;

namespace AREA_ReST_API.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]

public class AreasController
{
    private readonly AppDbContext _context;

    public AreasController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet("{userId:int}")]
    public ActionResult<List<AreaWithActionReaction>> GetAllAreasByUserId([AsParameters] int userId)
    {
        var requestedArea = _context.Areas.Where(area => area.UserId == userId).ToList();
        var areasWithId = requestedArea.Select(areasModel => new AreaWithActionReaction
            {
                Id = areasModel.Id,
                Name = areasModel.Name,
                UserId = areasModel.UserId,
                Favorite = areasModel.Favorite,
                UserAction = _context.UserActions.FirstOrDefault(userAction => userAction.AreaId == areasModel.Id),
                UserReactions = _context.UserReactions.Where(userReaction => userReaction.AreaId == areasModel.Id).ToList()
            }).ToList();
        return new OkObjectResult(areasWithId);
    }

    [HttpPost("")]
    public ActionResult CreateNewArea([FromBody] AreasModel newArea)
    {
        if (newArea.Name.IsNullOrEmpty())
            return new BadRequestObjectResult(new JsonObject { { "message", "Name cannot be null" } });
        var area = _context.Areas.Add(newArea);
        _context.SaveChanges();
        return new CreatedResult("Area successfully created", area.Entity);
    }

    [AllowAnonymous]
    [HttpPost("full")]
    public ActionResult CreateNewAreaWithActionAndReaction([FromBody] AreaWithActionReaction newArea)
    {
        if (newArea.Name.IsNullOrEmpty())
            return new BadRequestObjectResult(new JsonObject { { "message", "Name cannot be null" } });
        var onlyArea = new AreasModel
        {
            Name = newArea.Name,
            Favorite = newArea.Favorite,
            UserId = newArea.UserId
        };
        var registeredArea = _context.Areas.Add(onlyArea).Entity;
        _context.SaveChanges();
        UserActionsModel registeredAction = null!;
        if (newArea.UserAction != null)
        {
            newArea.UserAction.AreaId = registeredArea.Id;
            registeredAction = _context.UserActions.Add(newArea.UserAction).Entity;
        }
        var registeredReaction = newArea.UserReactions.Select(
            reaction =>
            {
                reaction.AreaId = registeredArea.Id;
                return _context.UserReactions.Add(reaction).Entity;
            }
    ).ToList();
        _context.SaveChanges();
        var createdArea = new AreaWithActionReaction
        {
            Id = registeredArea.Id,
            Name = registeredArea.Name,
            Favorite = registeredArea.Favorite,
            UserId = registeredArea.UserId,
            UserAction = registeredAction,
            UserReactions = registeredReaction,
        };
        return new CreatedResult("Area successfully created", createdArea);
    }

    [HttpDelete("{areaId:int}")]
    public ActionResult DeleteAreaWithActionAndReaction([AsParameters] int areaId)
    {
        var deletedArea = _context.Areas.FirstOrDefault(area => area.Id == areaId);
        if (deletedArea == null)
            return new NotFoundObjectResult(new JsonObject { { "message", "Area not found" } });
        DeleteAllActionAndReactionByAreaId(deletedArea.Id);
        return new OkObjectResult(new JsonObject { { "message", "Area successfully deleted" } });
    }

    private void DeleteAllActionAndReactionByAreaId(int areaId)
    {
        var userAction = _context.UserActions.FirstOrDefault(action => action.AreaId == areaId);
        var userReactions = _context.UserReactions.Where(reaction => reaction.AreaId == areaId).ToList();
        if (userAction != null)
            _context.UserActions.Remove(userAction);
        foreach (var userReaction in userReactions)
            _context.UserReactions.Remove(userReaction);
        _context.SaveChanges();
    }

    [HttpPut("")]
    public ActionResult ModifyArea([FromBody] AreasModel modifiedArea)
    {
        var requestedArea = _context.Areas.FirstOrDefault(area => area.Id == modifiedArea.Id);
        if (requestedArea == null)
            return new NotFoundObjectResult(new JsonObject { { "message", "Area not found" } });
        requestedArea.Favorite = modifiedArea.Favorite;
        requestedArea.Name = modifiedArea.Name;
        _context.Areas.Update(requestedArea);
        _context.SaveChanges();
        return new OkObjectResult(new JsonObject { { "message", "Area successfully updated" } });
    }
}