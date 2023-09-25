using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace AREA_ReST_API.Migrations
{
    /// <inheritdoc />
    public partial class update_areas_2 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Areas_Actions_ActionId",
                table: "Areas");

            migrationBuilder.DropIndex(
                name: "IX_Areas_ActionId",
                table: "Areas");

            migrationBuilder.DropColumn(
                name: "ActionId",
                table: "Areas");

            migrationBuilder.AddColumn<int>(
                name: "AreaModelId",
                table: "Actions",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Actions_AreaModelId",
                table: "Actions",
                column: "AreaModelId");

            migrationBuilder.AddForeignKey(
                name: "FK_Actions_Areas_AreaModelId",
                table: "Actions",
                column: "AreaModelId",
                principalTable: "Areas",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Actions_Areas_AreaModelId",
                table: "Actions");

            migrationBuilder.DropIndex(
                name: "IX_Actions_AreaModelId",
                table: "Actions");

            migrationBuilder.DropColumn(
                name: "AreaModelId",
                table: "Actions");

            migrationBuilder.AddColumn<int>(
                name: "ActionId",
                table: "Areas",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_Areas_ActionId",
                table: "Areas",
                column: "ActionId");

            migrationBuilder.AddForeignKey(
                name: "FK_Areas_Actions_ActionId",
                table: "Areas",
                column: "ActionId",
                principalTable: "Actions",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
