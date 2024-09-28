using System.Text.Json.Serialization;

namespace CowabungaPizza.Shared;

// The PIZZA

public class Pizza
{
    // SIZES

    public const int DefaultSize = 12;
    public const int MinimumSize = 8;
    public const int MaximumSize = 18;

    public int Id { get; set; }

    public int OrderId { get; set; }

    public PizzaSpecial? Special { get; set; }

    public int SpecialId { get; set; }

    public int Size { get; set; }

    public List<PizzaTopping> Toppings { get; set; } = new();

    // METHODS

    public decimal GetBasePrice()
    {
        if(Special == null) throw new NullReferenceException($"{nameof(Special)} was null when calculating Base Price.");
        return ((decimal)Size / (decimal)DefaultSize) * Special.BasePrice;
    }

    public decimal GetTotalPrice()
    {
        if (Toppings.Any(t => t.Topping is null)) throw new NullReferenceException($"{nameof(Toppings)} contained null when calculating the Total Price.");
        return GetBasePrice() + Toppings.Sum(t => t.Topping!.Price);
    }

    // Converts the Total Price to a formatted string
    public string GetFormattedTotalPrice()
    {
        return GetTotalPrice().ToString("0.00");
    }
}

[JsonSourceGenerationOptions(GenerationMode = JsonSourceGenerationMode.Serialization)]
[JsonSerializable(typeof(Pizza))]
public partial class PizzaContext : JsonSerializerContext { }