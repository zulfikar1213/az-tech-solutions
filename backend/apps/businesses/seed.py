from decimal import Decimal
from apps.businesses.models import Business, Service

def seed_brilliant_star_signs():
    business, _ = Business.objects.get_or_create(
        name="Brilliant Star Signs",
        defaults={
            "sector": "Signs & Printing",
            "city": "Detroit",
            "phone": "313-982-1260",
        },
    )

    services = {
        "Yard Signs": Decimal("5.50"),
        "Banners": Decimal("45.00"),
        "LED Signs": Decimal("199.00"),
        "Business Cards": Decimal("29.00"),
        "Flyers": Decimal("35.00"),
        "Car Wrapping": Decimal("299.00"),
        "Window Graphics": Decimal("89.00"),
    }

    for service_name, price in services.items():
        Service.objects.get_or_create(
            business=business,
            name=service_name,
            defaults={"price": price},
        )

    return business