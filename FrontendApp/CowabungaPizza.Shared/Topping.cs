namespace CowabungaPizza.Shared;

public class Topping
{
    public int Id { get; set; }

    public string Name { get; set; } = string.Empty;

    public decimal Price { get; set; }

    public string GetFormattedPrice() => Price.ToString("0.00");

}