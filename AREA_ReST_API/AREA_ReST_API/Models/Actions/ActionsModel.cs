using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace AREA_ReST_API.Models;

public class ActionsModel
{
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)] public int Id { get; set; }
    [Required] public required int ServiceId { get; set; }
    [Required] public required string Name { get; set; }
    [Required] public required string Endpoint { get; set; }
    public string? DefaultConfiguration { get; set; }
    public string? Description { get; set; }
}
