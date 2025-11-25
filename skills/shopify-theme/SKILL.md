---
name: shopify-theme
description: Shopify theme development expertise (Liquid, sections, snippets, JS components). Use when working on Shopify themes or asking about Liquid syntax.
---

# Shopify Theme Development Skill

**Activated for:** Liquid templates, sections, snippets, theme JS, Shopify CLI questions.

---

## Step 1: Load Project Context

First, check if we're in a Shopify theme project and load WARP.md if available:

```bash
# Check for Shopify theme markers
ls -la layout/theme.liquid sections/ snippets/ templates/ 2>/dev/null | head -5
```

```bash
# Load WARP.md if exists (contains architecture, patterns, design rules)
if [ -f WARP.md ]; then cat WARP.md; fi
```

---

## Step 2: Apply Shopify Theme Expertise

You now have deep knowledge of:

### Liquid Templating
- **Objects:** `product`, `collection`, `cart`, `shop`, `customer`, `settings`
- **Tags:** `{% if %}`, `{% for %}`, `{% assign %}`, `{% capture %}`, `{% render %}`, `{% section %}`
- **Filters:** `| money`, `| img_url`, `| asset_url`, `| t`, `| json`, `| escape`
- **Schema blocks:** Settings definitions in `{% schema %}...{% endschema %}`

### File Types
- **sections/*.liquid** - Modular sections with schema (merchant-configurable)
- **snippets/*.liquid** - Reusable partials ({% render 'snippet-name' %})
- **templates/*.json** - Page templates referencing sections (Online Store 2.0)
- **layout/theme.liquid** - Main HTML wrapper
- **assets/** - CSS, JS, images

### JavaScript Patterns (from WARP.md if loaded)
- Web Components via `customElements.define()`
- PubSub event system for cross-component communication
- No frameworks - vanilla JS only

### Design Token Rules (enforce these)
- **4px grid** - All spacing must be multiples of 4px
- **No hardcoded values** - Use CSS custom properties (`var(--color-*)`, `var(--space-*)`)
- **No inline styles** - Use design system classes

---

## Step 3: Handle the Request

Now handle the user's Shopify theme question or task.

**For code changes:**
1. Read the relevant file(s) first
2. Apply Liquid best practices
3. Warn (don't block) if design token violations detected
4. Suggest `shopify theme check` after significant changes

**For questions:**
- Provide direct answers with code examples
- Reference Shopify docs patterns when relevant

---

## Quick References

### Common Section Schema Pattern
```liquid
{% schema %}
{
  "name": "Section Name",
  "settings": [
    {
      "type": "text",
      "id": "heading",
      "label": "Heading",
      "default": "Default heading"
    }
  ],
  "blocks": [],
  "presets": [
    {
      "name": "Section Name"
    }
  ]
}
{% endschema %}
```

### Render Snippet with Variables
```liquid
{% render 'card-product', product: product, show_badge: true %}
```

### Asset URLs
```liquid
{{ 'component.css' | asset_url | stylesheet_tag }}
{{ 'component.js' | asset_url | script_tag }}
{{ 'image.png' | asset_url }}
```

### Settings Access
```liquid
{{ settings.color_primary }}
{{ section.settings.heading }}
{{ block.settings.text }}
```

---

**Now proceed with the user's request using this Shopify theme expertise.**
