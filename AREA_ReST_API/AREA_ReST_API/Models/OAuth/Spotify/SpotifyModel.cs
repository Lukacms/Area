using System.ComponentModel.DataAnnotations;

namespace AREA_ReST_API.Models.OAuth.Spotify;

public class SpotifyModel
{
  [Required] public required string Code { get; set; }
  public string? Scope { get; set; }
}
