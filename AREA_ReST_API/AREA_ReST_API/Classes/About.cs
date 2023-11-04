using System.ComponentModel.DataAnnotations;
using AREA_ReST_API.Models;

namespace AREA_ReST_API.Classes;

public class AboutServices
{
    public string? Name { get; set; }
    public List<ActionReactionDescriptor>? Action { get; set; }
    public List<ActionReactionDescriptor>? Reaction { get; set; }
}

public class AboutClient
{
    public string? Host { get; set; }
}

public class AboutServer
{
    public long? CurrentTime { get; set; }
    public List<AboutServices>? Services { get; set; }
}

public class About
{
    public AboutClient? Client { get; set; }
    public AboutServer? Server { get; set; }
}

public class ActionReactionDescriptor
{
    [Required] public required string Name { get; set; }
    public string? Description { get; set; }
}