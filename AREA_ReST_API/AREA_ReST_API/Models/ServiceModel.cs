using System.ComponentModel.DataAnnotations;

namespace AREA_ReST_API.Models;

public class ServiceModel
{
    [Required]
    public int Id { get; set; }
    
    [Required]
    public int User { get; set; }
    
    [Required]
    public string AccessToken { get; set; }
    
    [Required]
    public string RefreshToken { get; set; }
    
    [Required]
    public string Link { get; set; }
}