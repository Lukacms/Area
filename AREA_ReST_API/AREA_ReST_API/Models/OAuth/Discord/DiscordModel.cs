using System.ComponentModel.DataAnnotations;

namespace AREA_ReST_API.Models.OAuth.Discord;

public class DiscordModel
{
    [Required] public required string Code { get; set; }
    public string GuildId { get; set; }
    public string Permission { get; set; }
}