# ASCII Diagram Guide

Reference for building clean, aligned ASCII diagrams in documentation.

---

## 1. ASCII-Only Characters

Use only:
```
+  -  |  v  ^  <  >  =
```

Never use Unicode box-drawing:
```
BAD:  ┌ ┐ └ ┘ │ ─ ▼ ► ◄ ▲
```
They look good in some terminals but break in others.

---

## 2. Every `+` Is an Intersection

The `+` character marks where horizontal and vertical lines meet:

```
GOOD:                       BAD:
+----+----+                 +----+
|    |    |                 |
+----+----+                 +----
```

---

## 3. Bidirectional Flows

Use `<----->` for two-way communication:

```
+------------------+       +------------------+
|  Component A     |<----->|  Component B     |
+------------------+       +------------------+
```

---

## 4. Side-by-Side Boxes

For parallel or persistent concepts, place boxes next to each other:

```
+------------------+       +------------------+
|  Left box        |       |  Right box       |
|  (session flow)  |       |  (persistent)    |
+------------------+       +------------------+
```

---

## 5. Vertical Flow

Use `|` for vertical lines, `v` for downward arrows:

```
+------------------+
|  Step 1          |
+------------------+
         |
         v
+------------------+
|  Step 2          |
+------------------+
```

For upward flow, use `^`:

```
         ^
         |
+------------------+
|  Feeds back up   |
+------------------+
```

---

## 6. Count Characters for Alignment

1. Pick a consistent box width (e.g., 42 characters inside)
2. Stick to it for all boxes in a diagram
3. Pad text with spaces to fill the width
4. Align vertical connectors under box centers or edges

Example with 40-char inner width:
```
+------------------------------------------+
|  This text is padded to fill 40 chars    |
+------------------------------------------+
```

---

## 7. Show Loops and Persistence

Put persistent state on the side. Draw arrows both directions.
Show the same persistent box across sessions:

```
+----------------------+       +--------------------+
|  SESSION 1           |       |                    |
|  Does work           |<----->|  PERSISTENT MEMORY |
|  Saves decisions ----|-------|--> stores them     |
+----------------------+       |                    |
                               +--------------------+
                                        ^
+----------------------+                |
|  SESSION 2           |                |
|  Reads memory -------|----------------+
|  Builds on it        |
+----------------------+
```

---

## 8. Branching Flows

Use `+` to show where paths diverge:

```
+------------------+
|  Decision point  |
+--------+---------+
         |
    +----+----+
    |         |
    v         v
+-------+  +-------+
| Path A|  | Path B|
+-------+  +-------+
```

---

## 9. Nested Boxes

For showing components inside a larger container:

```
+------------------------------------------+
|  Outer Container                         |
|                                          |
|  +----------------+  +----------------+  |
|  |  Inner A       |  |  Inner B       |  |
|  +----------------+  +----------------+  |
|                                          |
+------------------------------------------+
```

---

## 10. Less Is More

- One good diagram beats five mediocre ones
- If it scrolls multiple pages, it's too long
- Keep prose outside the diagram, not crammed inside
- Use tables for lists, diagrams for flow/relationships

---

## Example: Full System Diagram

```
+------------------------------------------+       +-------------------------+
|  SESSION 1                               |       |                         |
|  "Build me an iOS app based on my site"  |       |   PERSISTENT MEMORY     |
+------------------------------------------+       |                         |
              |                                    |   ProjectContext MCP    |
              v                                    |   - project structure   |
+------------------------------------------+       |   - past decisions      |
|  Requirements gathered via conversation  |<----->|   - task history        |
+------------------------------------------+       |                         |
              |                                    |   Workshop              |
              v                                    |   - decisions           |
+------------------------------------------+       |   - gotchas             |
|  iOS Pipeline                            |       |   - standards           |
|                                          |       |                         |
|  ios-architect --> ios-builder ----+     |       +-------------------------+
|       |                            |     |               ^
|       v                            v     |               |
|  ios-swiftui-spec    ios-verification    |               |
+------------------------------------------+               |
              |                                            |
              v                                            |
+------------------------------------------+               |
|  V1 ships. Decisions saved. -------------|---------------+
+------------------------------------------+


+------------------------------------------+       +-------------------------+
|  SESSION 2                               |       |                         |
|  "Add dark mode"                         |       |   PERSISTENT MEMORY     |
+------------------------------------------+       |                         |
              |                                    |   Already knows:        |
              v                                    |   - MVVM architecture   |
+------------------------------------------+       |   - SwiftData models    |
|  Memory loaded. No re-explaining.        |<----->|   - Assets.xcassets     |
|  Complexity: SIMPLE                      |       |     color tokens        |
+------------------------------------------+       |                         |
              |                                    +-------------------------+
              v                                            ^
+------------------------------------------+               |
|  ios-swiftui-spec implements directly    |               |
|  Verification runs. Done.                |               |
|                                          |               |
|  New decision saved: --------------------|---------------+
|  "@Environment(\.colorScheme) theming"   |
+------------------------------------------+
```

---

## Quick Reference

| Element | Characters |
|---------|------------|
| Box corners | `+` |
| Horizontal lines | `-` |
| Vertical lines | `|` |
| Down arrow | `v` |
| Up arrow | `^` |
| Left arrow | `<` |
| Right arrow | `>` |
| Bidirectional | `<----->` |
| Section divider | `===` or `---` |
