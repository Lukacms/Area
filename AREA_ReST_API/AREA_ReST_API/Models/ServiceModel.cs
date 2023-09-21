using System.ComponentModel.DataAnnotations;

namespace AREA_ReST_API.Models;

public class ServiceModel
{
    [Required]
    public required int Id { get; set; }
    
    [Required]
    public required int User { get; set; }
    
    [Required]
    public required string AccessToken { get; set; }
    
    [Required]
    public required string RefreshToken { get; set; }
    
    [Required]
    public required string Link { get; set; }
}