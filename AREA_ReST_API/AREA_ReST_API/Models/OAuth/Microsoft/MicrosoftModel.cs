using System.ComponentModel.DataAnnotations;

namespace AREA_ReST_API.Models.OAuth.Microsoft;

public class MicrosoftModel
{
    [Required] public required string Code { get; set; }
    public string? Scope { get; set; }
}