using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace AREA_ReST_API.Migrations
{
    /// <inheritdoc />
    public partial class add_expiresin_userservice : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "ExpiresIn",
                table: "UserServices",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ExpiresIn",
                table: "UserServices");
        }
    }
}
