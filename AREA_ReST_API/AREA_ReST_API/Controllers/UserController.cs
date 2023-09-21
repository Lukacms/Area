using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AREA_ReST_API.Controllers;

[Authorize]
[ApiController]
[Route("api/Users/")]

public class UserController : ControllerBase
{
    private readonly AppDbContext _context;

    public UserController(AppDbContext context)
    {
        _context = context;
    }
    
    [HttpGet("")]
    public ActionResult<IEnumerable<UserModel>> GetAllUsers()
    {
        return Ok(_context.Users.ToList());
    }

    [HttpGet("{id:int}")]
    public ActionResult<UserModel?> GetUser([AsParameters] int id)
    {
        var askedUser = _context.Users.FirstOrDefault(user => user.Id == id);
        if (askedUser == null)
            return NotFound("User not found");
        return Ok(askedUser);
    }
}