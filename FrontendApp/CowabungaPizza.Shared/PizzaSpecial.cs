﻿namespace CowabungaPizza.Shared;

// Pizza Specials, pre-configured pizzas that customers can order

public class PizzaSpecial
{
    public int Id { get; set; }

    public string Name { get; set; } = string.Empty;

    public decimal BasePrice { get; set; }

    public string Description { get; set; } = string.Empty;

    public string ImageUrl { get; set; } = "img/pizzas/cheese.jpg";

    public string GetFormattedBasePrice() => BasePrice.ToString("0.00");
}