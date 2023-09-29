using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AREA_ReST_API.Controllers;

/*[Authorize]*/
[ApiController]
[Route("api/[controller]")]

public class ServicesController
{
    private readonly AppDbContext _context;

    public ServicesController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet("")]
    public ActionResult<List<ServicesModel>> GetAllServices()
    {
        var actions = _context.Services.ToList();
        return new OkObjectResult(actions);
    }
}