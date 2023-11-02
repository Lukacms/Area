

using System.Numerics;
using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Mvc;

namespace AREA_ReST_API.Classes;



public class AboutJsServices 
{
    public string? Name { get; set; }
    public List<ActionsModel>? Action { get; set; }
    public List<ReactionsModel>? Reaction { get; set; }
}

public class AboutJs
{
    public string? ClientIp { get; set; }
    public string? ServerTime { get; set; }
    public List<AboutJsServices>? Services { get; set; }
}