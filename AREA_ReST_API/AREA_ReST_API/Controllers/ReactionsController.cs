using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

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
}