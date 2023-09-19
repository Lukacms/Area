using System.ComponentModel.DataAnnotations;

namespace AREA_ReST_API.Models;

public class UserModel
{
    [Required]
    public int Id { get; set; }
    
    [Required]
    public string Username { get; set; }
    
    [Required]
    public string Password { get; set; }
    
    [Required]
    public string Email { get; set; }
    
    [Required]
    public int Status { get; set; }
    
    public ICollection<AreaModel> Areas { get; set; }
}