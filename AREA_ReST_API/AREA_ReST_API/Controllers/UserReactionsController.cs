using System.Text.Json.Nodes;
using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AREA_ReST_API.Controllers;


[Authorize]
[ApiController]
[Route("api/[controller]")]

public class UserReactionsController
{   
    private readonly AppDbContext _context;

    public UserReactionsController(AppDbContext context)
    {
        _context = context;
    }

    [HttpPost("")]
    public ActionResult CreateNewUserReaction([FromBody] UserReactionsModel newUserReaction)
    {
        var userReaction = _context.UserReactions.Add(newUserReaction);
        _context.SaveChanges();
        return new CreatedResult("UserReaction successfully created", userReaction.Entity);   
    }

    [HttpGet("{areaId:int}")]
    public ActionResult<List<UserReactionsModel>> GetUserReactionByAreaId([AsParameters] int areaId)
    {
        var requestedUserReaction =
            _context.UserReactions.Where(userReaction => userReaction.AreaId == areaId).ToList();
        return requestedUserReaction;
    }

    [HttpGet("{userReactionId:int}")]
    public ActionResult DeleteUserReactionById([AsParameters] int userReactionId)
    {
        var deletedUserReactions =
            _context.UserReactions.FirstOrDefault(userReaction => userReaction.Id == userReactionId);
        if (deletedUserReactions == null)
            return new NotFoundObjectResult(new JsonObject { { "message", "UserReaction not found" } });
        _context.UserReactions.Remove(deletedUserReactions);
        _context.SaveChanges();
        return new OkObjectResult(new JsonObject { { "message", "UserReaction successfully deleted"} });
    }
}