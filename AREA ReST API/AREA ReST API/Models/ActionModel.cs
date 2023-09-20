using System.ComponentModel.DataAnnotations;

namespace AREA_ReST_API.Models;

public class ActionModel
{
    [Required]
    public int Id { get; set; }
    
    [Required]
    public int Service { get; set; }
    
    [Required]
    public string Token { get; set; }

    [Required]
    public string Endpoint { get; set; }
    
    [Required]
    public int Refresh { get; set; }
}