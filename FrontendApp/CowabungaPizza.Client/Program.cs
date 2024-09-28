global using CowabungaPizza.Shared;
global using CowabungaPizza.Client;

using Microsoft.AspNetCore.Components.WebAssembly.Hosting;
using System;
using System.Net.Http;
using System.Threading.Tasks;

var builder = WebAssemblyHostBuilder.CreateDefault(args);

// Configure HttpClient to use the base address of the server project

builder.Services.AddScoped<HttpClient>(sp => 
	new HttpClient
	{
		BaseAddress = new Uri(builder.HostEnvironment.BaseAddress)
	});

builder.Services.AddScoped<IRepository, HttpRepository>();
builder.Services.AddScoped<OrderState>();


await builder.Build().RunAsync();
