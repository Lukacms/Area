using System.Text.Json.Nodes;
using AREA_ReST_API.Middleware;
using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AREA_ReST_API.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]

public class UserServicesController
{
    private readonly AppDbContext _context;

    public UserServicesController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet("{userId:int}")]
    public ActionResult<List<UserServicesModel>> GetUserServicesByUserId([AsParameters] int userId)
    {
        var userServicesList = _context.UserServices.Where(userService => userService.UserId == userId).ToList();
        return new OkObjectResult(userServicesList);
    }
    
    [HttpDelete("{userServiceId:int}")]
    public ActionResult DeleteUserServiceById([AsParameters] int userServiceId, [FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);
        var deletedUserService = _context.UserServices.FirstOrDefault(userService => userService.Id == userServiceId);
        if (deletedUserService == null)
            return new NotFoundObjectResult(new JsonObject { { "message", "UserService not found" } });
        if (decodedUser.Id != deletedUserService.UserId)
            return new UnauthorizedObjectResult(new JsonObject
                { { "message", "Not authorized to delete this UserService" } });
        _context.UserServices.Remove(deletedUserService);
        _context.SaveChanges();
        return new OkObjectResult(new JsonObject{{"message", "UserService successfully deleted"}});
    }
}