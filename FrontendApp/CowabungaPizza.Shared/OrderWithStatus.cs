using System.Text.Json.Serialization;
using CowabungaPizza.ComponentsLibrary.Map;

namespace CowabungaPizza.Shared;

public class OrderWithStatus
{
    // If only pizza could be delivered this fast in real life...

    public readonly static TimeSpan PreparationDuration = TimeSpan.FromSeconds(10);
    public readonly static TimeSpan DeliveryDuration = TimeSpan.FromMinutes(1); 

    // Set from DB
    public Order Order { get; set; } = null!;

    // Set from Order
    public string StatusText { get; set; } = null!;

    public bool IsDelivered => StatusText == "Delivered";

    public List<Marker> MapMarkers { get; set; } = null!;

    public static OrderWithStatus FromOrder(Order order)
    {
        ArgumentNullException.ThrowIfNull(order.DeliveryLocation);

        // Simulating backend process by fake status updates based on the amount
        // of time since the order was placed -- part of Future Feature - Pizza Tracker

        string statusText;
        List<Marker> mapMarkers;
        var dispatchTime = order.CreatedTime.Add(PreparationDuration);

        if (DateTime.Now < dispatchTime)
        {
            statusText = "Preparing";
            mapMarkers = new List<Marker>
                                {
                                        ToMapMarker("You", order.DeliveryLocation, showPopup: true)
                                };
        }
        else if (DateTime.Now < dispatchTime + DeliveryDuration)
        {
            statusText = "Out for delivery";

            var startPosition = ComputeStartPosition(order);
            var proportionOfDeliveryCompleted = Math.Min(1, (DateTime.Now - dispatchTime).TotalMilliseconds / DeliveryDuration.TotalMilliseconds);
            var driverPosition = LatLong.Interpolate(startPosition, order.DeliveryLocation, proportionOfDeliveryCompleted);
            mapMarkers = new List<Marker>
                                {
                                        ToMapMarker("You", order.DeliveryLocation),
                                        ToMapMarker("Driver", driverPosition, showPopup: true),
                                };
        }
        else
        {
            statusText = "Delivered";
            mapMarkers = new List<Marker>
                                {
                                        ToMapMarker("Delivery location", order.DeliveryLocation, showPopup: true),
                                };
        }

        return new OrderWithStatus
        {
            Order = order,
            StatusText = statusText,
            MapMarkers = mapMarkers,
        };
    }

    private static LatLong ComputeStartPosition(Order order)
    {
        ArgumentNullException.ThrowIfNull(order.DeliveryLocation);

        // Random but based on order ID

        var rng = new Random(order.OrderId);
        var distance = 0.01 + rng.NextDouble() * 0.02;
        var angle = rng.NextDouble() * Math.PI * 2;
        var offset = (distance * Math.Cos(angle), distance * Math.Sin(angle));
        return new LatLong(order.DeliveryLocation.Latitude + offset.Item1, order.DeliveryLocation.Longitude + offset.Item2);
    }

    static Marker ToMapMarker(string description, LatLong coords, bool showPopup = false)
            => new Marker { Description = description, X = coords.Longitude, Y = coords.Latitude, ShowPopup = showPopup };
}