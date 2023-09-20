using AREA_ReST_API.Models;
using Microsoft.EntityFrameworkCore;

namespace AREA_ReST_API;
public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
    {
        
    }
    
    public virtual DbSet<UserModel> Users { get; set; }
    
    public virtual DbSet<AreaModel> Areas { get; set; }
    
    public virtual DbSet<ActionModel> Actions { get; set; }
    
    public virtual DbSet<ReactionModel> Reactions { get; set; }
    
    public virtual DbSet<ServiceModel> Services { get; set; }
}