using System.ComponentModel.DataAnnotations;

namespace AREA_ReST_API.Models.OAuth.Google;

public class GoogleCallbackModel
{
   [Required] public required string AccessToken {get; set; }
   [Required] public required string ExpireIn { get; set; }
   [Required] public required string RefreshToken { get; set; }
   public string? Scope { get; set; }
   public string? TokenType { get; set; }
}
