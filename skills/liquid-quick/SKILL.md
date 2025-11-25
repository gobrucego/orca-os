---
name: liquid-quick
description: Quick Liquid syntax reference and help. Use for fast Liquid questions without full project context loading.
---

# Liquid Quick Reference

**For:** Fast Liquid syntax help, no project context needed.

---

## Liquid Essentials

### Output
```liquid
{{ product.title }}
{{ 'hello' | upcase }}
{{ product.price | money }}
```

### Tags
```liquid
{% if condition %}...{% endif %}
{% unless condition %}...{% endunless %}
{% for item in array %}...{% endfor %}
{% assign variable = value %}
{% capture variable %}...{% endcapture %}
```

### Control Flow
```liquid
{% if product.available %}
  In stock
{% elsif product.inventory_quantity == 0 %}
  Sold out
{% else %}
  Coming soon
{% endif %}

{% case product.type %}
  {% when 'Shirt' %}
    Shirt content
  {% when 'Pants' %}
    Pants content
  {% else %}
    Default content
{% endcase %}
```

### Loops
```liquid
{% for product in collection.products limit: 4 %}
  {{ product.title }}
  {% if forloop.first %}First item{% endif %}
  {% if forloop.last %}Last item{% endif %}
  {{ forloop.index }} {# 1-based #}
  {{ forloop.index0 }} {# 0-based #}
{% else %}
  No products found
{% endfor %}
```

### Common Filters
```liquid
| money                  {# Format as currency #}
| money_with_currency    {# With currency code #}
| img_url: '300x'        {# Image URL with size #}
| image_url: width: 300  {# Modern image URL #}
| asset_url              {# Asset file URL #}
| t                      {# Translation #}
| json                   {# JSON encode #}
| escape                 {# HTML escape #}
| strip_html             {# Remove HTML #}
| truncate: 50           {# Truncate text #}
| split: ','             {# String to array #}
| join: ', '             {# Array to string #}
| first / last           {# Array first/last #}
| size                   {# Array/string length #}
| default: 'fallback'    {# Default value #}
| append: '-suffix'      {# Append string #}
| prepend: 'prefix-'     {# Prepend string #}
| replace: 'a', 'b'      {# Replace substring #}
| downcase / upcase      {# Case conversion #}
| date: '%B %d, %Y'      {# Date format #}
```

### Shopify Objects
```liquid
{{ product.title }}
{{ product.price }}
{{ product.compare_at_price }}
{{ product.description }}
{{ product.featured_image }}
{{ product.variants }}
{{ product.options }}
{{ product.metafields.namespace.key }}

{{ collection.title }}
{{ collection.products }}
{{ collection.products_count }}

{{ cart.item_count }}
{{ cart.total_price }}
{{ cart.items }}

{{ customer.first_name }}
{{ customer.email }}
{{ customer.orders }}

{{ shop.name }}
{{ shop.currency }}
{{ shop.money_format }}

{{ settings.color_primary }}
{{ section.settings.heading }}
{{ block.settings.text }}
```

### Include/Render
```liquid
{% render 'snippet-name' %}
{% render 'snippet-name', variable: value %}
{% render 'snippet-name' for array as item %}

{# Sections (in templates) #}
{% section 'section-name' %}
```

### Schema (sections only)
```liquid
{% schema %}
{
  "name": "Section",
  "settings": [
    { "type": "text", "id": "heading", "label": "Heading" }
  ],
  "blocks": [
    { "type": "item", "name": "Item", "settings": [...] }
  ],
  "presets": [{ "name": "Section" }]
}
{% endschema %}
```

---

**Now answer the user's Liquid question directly.**
