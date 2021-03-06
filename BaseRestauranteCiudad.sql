USE [master]
GO
/****** Object:  Database [SiberianDB]    Script Date: 2021-09-27 21:52:06 ******/
CREATE DATABASE [SiberianDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SiberianDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012\MSSQL\DATA\SiberianDB.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'SiberianDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012\MSSQL\DATA\SiberianDB_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [SiberianDB] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SiberianDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SiberianDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SiberianDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SiberianDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SiberianDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SiberianDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [SiberianDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SiberianDB] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [SiberianDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SiberianDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SiberianDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SiberianDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SiberianDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SiberianDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SiberianDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SiberianDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SiberianDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SiberianDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SiberianDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SiberianDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SiberianDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SiberianDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SiberianDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SiberianDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SiberianDB] SET RECOVERY FULL 
GO
ALTER DATABASE [SiberianDB] SET  MULTI_USER 
GO
ALTER DATABASE [SiberianDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SiberianDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SiberianDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SiberianDB] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'SiberianDB', N'ON'
GO
USE [SiberianDB]
GO
/****** Object:  StoredProcedure [dbo].[Sp_Ciudad]    Script Date: 2021-09-27 21:52:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Adela Lorena Cujilema
-- Create date: 24-Septiembre-2021
-- Description:	Sp Ciudades
-- =============================================
CREATE PROCEDURE [dbo].[Sp_Ciudad] 
@opcion as int ,
@IDCiudad as int = null,
@nombreCiudad as varchar(100) = '', 	
@fecha as datetime = null
AS
BEGIN
	 
	SET NOCOUNT ON;
    
	-- Lista de ciudades
	if (@opcion = 1)
	begin
	select *		
	from Ciudad  
	end

	-- Filtro 1 ciudad
	if (@opcion = 2)
	begin
		select *		
		from Ciudad  
		where IDCiudad = @IDCiudad
	end

	-- Insert
	if (@opcion = 3)
	Begin try
		Begin tran
		insert into Ciudad(NombreCiudad, FechaCreacion)
		values
		(@nombreCiudad, @fecha)

		select 0 as IDCiudad , '' as NombreCiudad, getdate() as FechaCreacion        
		commit tran;
	End try
	Begin catch
		if(@@trancount > 0)
			rollback tran;
	End catch

	-- Update
	if (@opcion = 4)
	Begin try
		begin tran;
		update Ciudad
		set NombreCiudad= @nombreCiudad, 
			FechaCreacion= getdate()
		where IDCiudad = @IDCiudad

		select 0 as IDCiudad , '' as NombreCiudad, getdate() as FechaCreacion
		commit tran;
	End try
	Begin catch
		if (@@trancount > 0)
			rollback tran;
	End catch

	-- Delete
	if (@opcion = 5)
	Begin try
		begin tran;
		delete from Ciudad
		where IDCiudad = @IDCiudad

		select 0 as IDCiudad , '' as NombreCiudad, getdate() as FechaCreacion
		commit tran;
	End try
	Begin catch
		if (@@trancount > 0)
			rollback tran;
	End catch

END

GO
/****** Object:  StoredProcedure [dbo].[Sp_Restaurantes]    Script Date: 2021-09-27 21:52:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Adela Lorena Cujilema 
-- Create date: 24-Septiembre-2021
-- Description:	Sp_Restaurantes
-- =============================================
CREATE PROCEDURE [dbo].[Sp_Restaurantes]
@opcion as int,
@IDRestaurante as int = null,
@nombreRestaurante as varchar(100) = '', 
@idCiudad as int = null, 
@numeroAforo as int = null, 
@telefono as int = null, 
@fecha as datetime = null
AS
BEGIN
	 
	SET NOCOUNT ON;
    
	-- Lista de Restaurantes con el nombre de la ciudad
	if (@opcion = 1)
	begin
	select 
		r.IDRestaurante, r.NombreRestaurante, r.NumeroAforo, r.Telefono, r.FechaCreacion, c.NombreCiudad 
		from Restaurantes as r
		inner join Ciudad as c on r.IDCiudad = c.IDCiudad
	end

	-- Filtro 1 restaurante
	if (@opcion = 2)
	begin
		select 
		r.IDRestaurante, r.NombreRestaurante, r.NumeroAforo, r.Telefono, r.FechaCreacion, c.NombreCiudad 
		from Restaurantes as r
		inner join Ciudad as c on r.IDCiudad = c.IDCiudad
		where r.IDRestaurante = @IDRestaurante
	end

	-- Insert
	if (@opcion = 3)
	Begin try
		Begin tran
		insert into Restaurantes(NombreRestaurante, IDCiudad, NumeroAforo, Telefono, FechaCreacion)
		values
		(@nombreRestaurante, @idCiudad, @numeroAforo, @telefono, @fecha)
		select 0 IDRestaurante, '' NombreRestaurante, 0 NumeroAforo, 0 Telefono, getdate() FechaCreacion, '' NombreCiudad 
		commit tran;
	End try
	Begin catch
		if(@@trancount > 0)
			rollback tran;
	End catch

	-- Update
	if (@opcion = 4)
	Begin try
		begin tran;
		update Restaurantes
		set NombreRestaurante= @nombreRestaurante,
			IDCiudad= @idCiudad, 
			NumeroAforo= @numeroAforo, 
			Telefono= @telefono, 
			FechaCreacion= getdate()
		where IDRestaurante = @IDRestaurante
		select 0 IDRestaurante, '' NombreRestaurante, 0 NumeroAforo, 0 Telefono, getdate() FechaCreacion, '' NombreCiudad 
		commit tran;
	End try
	Begin catch
		if (@@trancount > 0)
			rollback tran;
	End catch

	-- Delete
	if (@opcion = 5)
	Begin try
		begin tran;
		delete from Restaurantes
		where IDRestaurante = @IDRestaurante
		select 0 IDRestaurante, '' NombreRestaurante, 0 NumeroAforo, 0 Telefono, getdate() FechaCreacion, '' NombreCiudad 
		commit tran;
	End try
	Begin catch
		if (@@trancount > 0)
			rollback tran;
	End catch


END

GO
/****** Object:  Table [dbo].[Ciudad]    Script Date: 2021-09-27 21:52:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Ciudad](
	[IDCiudad] [int] IDENTITY(1,1) NOT NULL,
	[NombreCiudad] [varchar](100) NULL,
	[FechaCreacion] [datetime] NULL,
 CONSTRAINT [PK_Ciudad] PRIMARY KEY CLUSTERED 
(
	[IDCiudad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Restaurantes]    Script Date: 2021-09-27 21:52:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Restaurantes](
	[IDRestaurante] [int] IDENTITY(1,1) NOT NULL,
	[NombreRestaurante] [varchar](100) NULL,
	[IDCiudad] [int] NULL,
	[NumeroAforo] [int] NULL,
	[Telefono] [int] NULL,
	[FechaCreacion] [datetime] NULL,
 CONSTRAINT [PK_Restaurantes] PRIMARY KEY CLUSTERED 
(
	[IDRestaurante] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Usuario]    Script Date: 2021-09-27 21:52:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Usuario](
	[IDUser] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](50) NULL,
	[Password] [varchar](50) NULL,
 CONSTRAINT [PK_Usuario] PRIMARY KEY CLUSTERED 
(
	[IDUser] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Restaurantes]  WITH CHECK ADD  CONSTRAINT [FK_Restaurantes_Ciudad] FOREIGN KEY([IDCiudad])
REFERENCES [dbo].[Ciudad] ([IDCiudad])
GO
ALTER TABLE [dbo].[Restaurantes] CHECK CONSTRAINT [FK_Restaurantes_Ciudad]
GO
USE [master]
GO
ALTER DATABASE [SiberianDB] SET  READ_WRITE 
GO
