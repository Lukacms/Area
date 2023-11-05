using AREA_ReST_API.Classes.Services;
using AREA_ReST_API.Models;

namespace AREA_ReST_API.Classes;

public class ActionChecker : BackgroundService
{
    private readonly IServiceProvider _serviceProvider;
    private readonly Dictionary<string, Func<IService>> _services;
    public ActionChecker(IServiceProvider serviceProvider)
    {
        _serviceProvider = serviceProvider;
        _services = new Dictionary<string, Func<IService>>
        {
            { "Spotify", () => new SpotifyService() },
            { "Google", () => new GoogleService() },
            { "Github", () => new GithubService() },
            { "Microsoft", () => new MicrosoftService() },
            { "XIV Api", () => new XIVService() },
            { "Weather", () => new WeatherService() }
        };
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
                var userAction = area.UserAction;
                if (userAction == null)
                    continue;
                if (userAction.Countdown > 0)
                {
                    userAction.Countdown -= serverTimer;
                    context.UserActions.Update(userAction);
                    continue;
                }
                try
                {
                    await ManageActions(area.UserAction!, area, context);
                }
                catch
                {
                    // ignored
                }
                userAction.Countdown = userAction.Timer;
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

    private async Task ManageReactions(AreaWithActionReaction area, AppDbContext context)
    {
        foreach (var userReaction in area.UserReactions)
        {
            var reaction = context.Reactions.First(x => x.Id == userReaction.ReactionId);
            var service = context.Services.First(s => s.Id == reaction.ServiceId);
            var userService = context.UserServices.First(s => s.ServiceId == service.Id && s.UserId == area.UserId);
            var instance = _services[service.Name].Invoke();
            try
            {
                await instance.ReactionSelector(userReaction, userService, context);
            }
            catch
            {
                Console.WriteLine("TRY CATCH FAILED");
                return;
            }
        }
    }

    private async Task ManageActions(UserActionsModel userAction, AreaWithActionReaction area, AppDbContext context)
    {
        var action = context.Actions.First(a => a.Id == userAction.ActionId);
        var service = context.Services.First(s => s.Id == action.ServiceId);
        var userService = context.UserServices.FirstOrDefault(s => s.ServiceId == action.ServiceId && s.UserId == area.UserId);
        var instance = _services[service.Name].Invoke();
        Console.WriteLine("HERE'S " + action.Name);
        if (userService == null && service.IsConnectionNeeded == false)
            if (await instance.ActionSelectorWithoutUserService(userAction, context))
                await ManageReactions(area, context);
        if (await instance.ActionSelector(userAction, userService, context))
            await ManageReactions(area, context);
    }
}