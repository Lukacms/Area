using System.Text.Json.Nodes;
using AREA_ReST_API.Classes;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace AREA_ReST_API;

[Authorize]
[ApiController]
[Route("about.json")]
public class AboutController
{
   private readonly AppDbContext _context;
   private readonly About _about = new ();
   private readonly AboutClient _aboutClient = new();
   private readonly AboutServer _aboutServer = new();
   private const string _uri = "https://api.ipify.org/?format=json";

   public AboutController(AppDbContext context)
    {
        _context = context;
    }

    [AllowAnonymous]
    [HttpGet("")]
    public async Task<ActionResult> CreateAboutJson()
    {
        SetupAboutServer();
        await SetupAboutClient();

        _about.Client = _aboutClient;
        _about.Server = _aboutServer;
        var jsonConvert = JObject.Parse(JsonConvert.SerializeObject(_about));
        return new OkObjectResult(JsonNode.Parse(jsonConvert.ToString()));
    }

    private void SetupAboutServer()
    {
        var time = DateTimeOffset.Now.ToUnixTimeSeconds();

        _aboutServer.CurrentTime = time;
        _aboutServer.Services = _context!.Services.Select(service => new AboutServices
        {
            Name = service.Name,
            Action = _context.Actions.Where(action => action.ServiceId == service.Id).Select(action => new ActionReactionDescriptor
            {
                Name = action.Name,
                Description = action.Description,
            }).ToList(),
            Reaction = _context.Reactions.Where(reaction => reaction.ServiceId == service.Id).Select(reaction => new ActionReactionDescriptor
            {
                Name = reaction.Name,
                Description = reaction.Description,
            }).ToList()
        }).ToList();
    }

    private async Task SetupAboutClient()
    {
        var client = new HttpClient();
        var requestMessage = new HttpRequestMessage(HttpMethod.Get, _uri);
        var response = await client.SendAsync(requestMessage);
        var jsonContent = JObject.Parse(await response.Content.ReadAsStringAsync());

        _aboutClient.Host = jsonContent["ip"]!.ToString();
    }
}