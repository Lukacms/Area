using System.ComponentModel.DataAnnotations;

namespace AREA_ReST_API.Models;

public class AreaModel
{
    [Required]
    public int Id { get; set; }
    
    [Required]
    public int User { get; set; }

    [Required]
    public ActionModel Action { get; set; }
    
    [Required]
    public ReactionModel Reaction { get; set; }
}