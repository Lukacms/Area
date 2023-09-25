﻿// <auto-generated />
using System;
using AREA_ReST_API;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

#nullable disable

namespace AREA_ReST_API.Migrations
{
    [DbContext(typeof(AppDbContext))]
    [Migration("20230925151905_update_areas_1")]
    partial class update_areas_1
    {
        /// <inheritdoc />
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "7.0.11")
                .HasAnnotation("Relational:MaxIdentifierLength", 64);

            modelBuilder.Entity("AREA_ReST_API.Models.ActionModel", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<string>("Endpoint")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<int>("Refresh")
                        .HasColumnType("int");

                    b.Property<int>("Service")
                        .HasColumnType("int");

                    b.Property<string>("Token")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.HasKey("Id");

                    b.ToTable("Actions");
                });

            modelBuilder.Entity("AREA_ReST_API.Models.AreaModel", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<int>("ActionId")
                        .HasColumnType("int");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<int>("User")
                        .HasColumnType("int");

                    b.Property<int?>("UserModelId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("ActionId");

                    b.HasIndex("UserModelId");

                    b.ToTable("Areas");
                });

            modelBuilder.Entity("AREA_ReST_API.Models.ReactionModel", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<int?>("AreaModelId")
                        .HasColumnType("int");

                    b.Property<string>("Endpoint")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<int>("Service")
                        .HasColumnType("int");

                    b.Property<string>("Token")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.HasKey("Id");

                    b.HasIndex("AreaModelId");

                    b.ToTable("Reactions");
                });

            modelBuilder.Entity("AREA_ReST_API.Models.ServiceModel", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<string>("AccessToken")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("Link")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("RefreshToken")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<int>("User")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.ToTable("Services");
                });

            modelBuilder.Entity("AREA_ReST_API.Models.UserModel", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    b.Property<bool>("Admin")
                        .HasColumnType("tinyint(1)");

                    b.Property<string>("Email")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("Password")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("Username")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.HasKey("Id");

                    b.ToTable("Users");
                });

            modelBuilder.Entity("AREA_ReST_API.Models.AreaModel", b =>
                {
                    b.HasOne("AREA_ReST_API.Models.ActionModel", "Action")
                        .WithMany()
                        .HasForeignKey("ActionId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("AREA_ReST_API.Models.UserModel", null)
                        .WithMany("Areas")
                        .HasForeignKey("UserModelId");

                    b.Navigation("Action");
                });

            modelBuilder.Entity("AREA_ReST_API.Models.ReactionModel", b =>
                {
                    b.HasOne("AREA_ReST_API.Models.AreaModel", null)
                        .WithMany("Reaction")
                        .HasForeignKey("AreaModelId");
                });

            modelBuilder.Entity("AREA_ReST_API.Models.AreaModel", b =>
                {
                    b.Navigation("Reaction");
                });

            modelBuilder.Entity("AREA_ReST_API.Models.UserModel", b =>
                {
                    b.Navigation("Areas");
                });
#pragma warning restore 612, 618
        }
    }
}
