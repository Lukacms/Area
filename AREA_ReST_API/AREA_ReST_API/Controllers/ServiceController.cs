using System.Text.Json.Nodes;
using Microsoft.AspNetCore.Mvc;

namespace AREA_ReST_API.Controllers;

[ApiController]
[Route("api/[controller]")]

public class ServiceController
{
    private readonly AppDbContext _context;
    
    public ServiceController(AppDbContext context)
    {
        _context = context;
    }

    [HttpPost("")]
    public ActionResult CreateService()
    {
        return new OkResult();
    }
    
    [HttpDelete("{id:int}")]
    public ActionResult DeleteService([AsParameters] int id)
    {
        var deletedService = _context.Services.FirstOrDefault(service => service.Id == id);
        if (deletedService == null)
            return new NotFoundObjectResult(new JsonObject { { "message", "Service does not exist" } });
        _context.Services.Remove(deletedService);
        _context.SaveChanges();
        return new OkObjectResult(new JsonObject { { "message", "Service successfully delete" } });
    }
}