using AREA_ReST_API.Models;

namespace AREA_ReST_API.Classes;

public class ActionChecker : BackgroundService
{
    private readonly IServiceProvider _serviceProvider;
    
    public ActionChecker(IServiceProvider serviceProvider)
    {
        _serviceProvider = serviceProvider;
    }
    
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        const int serverTimer = 2;
        while (!stoppingToken.IsCancellationRequested)
        {
            await Task.Delay(TimeSpan.FromSeconds(serverTimer), stoppingToken);
            using var scope = _serviceProvider.CreateScope();
            var context = scope.ServiceProvider.GetRequiredService<AppDbContext>();
            var areas = GetAreasWithActionAndReaction(context);
            foreach (var area in areas)
            {
                var action = area.UserAction;
                if (action == null)
                    continue;
                if (action.Countdown > 0)
                {
                    action.Countdown -= serverTimer;
                    context.UserActions.Update(action);
                }
                else
                {
                    ManageReactions(area, context);
                    action.Countdown = action.Timer;
                }
            }
            await context.SaveChangesAsync(stoppingToken);
        }
    }

    private List<AreaWithActionReaction> GetAreasWithActionAndReaction(AppDbContext context)
    {
        var areas = context.Areas.ToList();
        var completeAreas = areas.Select(areasModel => new AreaWithActionReaction 
        {
            Id = areasModel.Id,
            Name = areasModel.Name,
            UserId = areasModel.UserId,
            Favorite = areasModel.Favorite,
            UserAction = context.UserActions.FirstOrDefault(userAction => userAction.AreaId == areasModel.Id),
            UserReactions = context.UserReactions.Where(userReaction => userReaction.AreaId == areasModel.Id).ToList()
        }).ToList();
        return completeAreas;
    }

    private void ManageReactions(AreaWithActionReaction area, AppDbContext context)
    {
        var reactions = area.UserReactions;
        foreach (var userReaction in reactions)
        {
            var reaction = context.Reactions.First(x => x.Id == userReaction.ReactionId);
            var service = context.UserServices.First(x => x.ServiceId == area.Id && x.UserId == area.UserId);
            Console.WriteLine("Reaction effectué");
        }
    }
}