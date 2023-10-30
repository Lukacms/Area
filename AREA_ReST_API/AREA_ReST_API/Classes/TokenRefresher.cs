using AREA_ReST_API.Classes.Services;

namespace AREA_ReST_API.Classes;

public class TokenRefresher : BackgroundService
{
    private readonly IServiceProvider _serviceProvider;
    private readonly Dictionary<string, Func<IService>> _services;

    public TokenRefresher(IServiceProvider serviceProvider)
    {
        _serviceProvider = serviceProvider;
        _services = new Dictionary<string, Func<IService>>
        {
            { "Spotify", () => new SpotifyService() },
            { "Google", () => new GoogleService() },
            { "Github", () => new GithubService() },
            { "Microsoft", () => new MicrosoftService() }
        };
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        const int serverTimer = 10;
        const int offset = 10;

        while (!stoppingToken.IsCancellationRequested)
        {
            await Task.Delay(TimeSpan.FromSeconds(serverTimer), stoppingToken);
            using var scope = _serviceProvider.CreateScope();
            var context = scope.ServiceProvider.GetRequiredService<AppDbContext>();

            var allToken = context.UserServices.ToList();
            foreach (var token in allToken)
            {
                var serviceName = context.Services.First(s => s.Id == token.ServiceId);
                if (token.ExpiresIn > 1800)
                {
                    token.ExpiresIn -= serverTimer + offset;
                    context.UserServices.Update(token);
                    await context.SaveChangesAsync(stoppingToken);
                    continue;
                }

                try
                {
                    var service = _services[serviceName.Name];
                    await service.Invoke().RefreshToken(token, context);
                }
                catch
                {
                    Console.WriteLine("REFRESH FAILED");
                }
            }
        }
    }
}