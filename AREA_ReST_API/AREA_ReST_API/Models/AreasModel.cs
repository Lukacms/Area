using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace AREA_ReST_API.Models;

public class AreasModel
{
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)] public int Id { get; set; }
    [Required] public required int UserId { get; set; }
    [Required] public required string Name { get; set; }
    [Required] public required bool Favorite { get; set; }
}