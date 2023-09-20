using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Mvc;

namespace AREA_ReST_API.Controllers;

[ApiController]
[Route("api/[controller]")]

public class UserController : ControllerBase
{
    private AppDbContext? _context; 
    
    [HttpGet("")]
    public IEnumerable<UserModel> GetAllUsers(AppDbContext context)
    {
        _context = context;
        return _context.Users.ToList();
    }

    [HttpGet("/:id")]
    public IQueryable<UserModel> GetUser(AppDbContext context, [AsParameters] int id)
    {
        _context = context;
        return _context.Users.Where(user => user.Id == id);
    }
}