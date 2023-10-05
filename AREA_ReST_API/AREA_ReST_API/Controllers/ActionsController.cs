using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

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
}