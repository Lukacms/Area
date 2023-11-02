using System.Text.Json.Nodes;
using AREA_ReST_API.Classes;
using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using DateTime = System.DateTime;

namespace AREA_ReST_API;

[Authorize]
[ApiController]
[Route("/about.json")]
public class CreateAbout
{
   private readonly AppDbContext _context;
   private AboutJs _aboutValues = new ();
   private string _uri;
   
    public CreateAbout(AppDbContext context)
    {
        _context = context;
        _uri = "https://api.ipify.org/?format=json";
    }

    [AllowAnonymous]
    [HttpGet("")]
    public async Task<ActionResult> CreateAboutJson()
    {
        var jobject = new JObject();
        var client = new HttpClient();

        var requestMessage = new HttpRequestMessage(HttpMethod.Get, _uri);
        
        var response = await client.SendAsync(requestMessage);
        var result = JObject.Parse(await response.Content.ReadAsStringAsync());
        Console.WriteLine("Here");
        Console.WriteLine(result["ip"]!.ToString());

        _aboutValues.ClientIp = result["ip"]!.ToString();
        var time = DateTime.Now;
        _aboutValues.ServerTime = time.Date.ToString();
        _aboutValues.Services = _context.Services.Select(service => new AboutJsServices
        {
            Name = service.Name,
            Action = _context.Actions.Where(model => model.Id == service.Id).ToList(),
            Reaction = _context.Reactions.Where(model => model.Id == service.Id).ToList()
        }).ToList();
        var result2 = JObject.Parse(JsonConvert.SerializeObject(_aboutValues));
        Console.WriteLine(result2);
        return new OkObjectResult(JsonNode.Parse(result2.ToString()));
    }
}