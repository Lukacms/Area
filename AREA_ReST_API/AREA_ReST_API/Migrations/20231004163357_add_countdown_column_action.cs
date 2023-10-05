using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace AREA_ReST_API.Migrations
{
    /// <inheritdoc />
    public partial class add_countdown_column_action : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "Countdown",
                table: "UserActions",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Countdown",
                table: "UserActions");
        }
    }
}
