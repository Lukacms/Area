using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Reflection.Metadata;

namespace AREA_ReST_API.Models;

public class ServicesModel
{
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)] public int Id { get; set; }
    [Required] public required string Name { get; set; }
    [Required] public required byte[] Logo { get; set; } 
}