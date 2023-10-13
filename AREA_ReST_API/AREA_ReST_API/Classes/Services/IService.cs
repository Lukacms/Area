using AREA_ReST_API.Models;

namespace AREA_ReST_API.Classes.Services;

public class IService
{
    public virtual async Task<bool> ActionSelector(UserActionsModel userAction, UserServicesModel userService, AppDbContext context)
    {
        return false;
    }
    
    public virtual async Task ReactionSelector(UserReactionsModel userReaction, UserServicesModel userService, AppDbContext context)
    {
        return;
    }
}