using System.ComponentModel.DataAnnotations;

namespace AREA_ReST_API.Models.OAuth.Github;

public class GithubModel
{
    [Required] public required string Code { get; set; }
    public string? Scope { get; set; }
}
