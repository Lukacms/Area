using System.ComponentModel.DataAnnotations;

namespace AREA_ReST_API.Models.OAuth.Google;

public class GoogleModel
{
    [Required] public required string Code { get; set; }
    public string? Scope { get; set; }
}
