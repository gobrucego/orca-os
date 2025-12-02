# ASCII Patterns - Visual Toolkit

Complete library of ASCII characters and patterns for uxscii components.

## Box-Drawing Characters

### Basic Borders

**Light (Default)**
```

 Box 

```
Characters: `     `

**Rounded (Friendly)**
```

 Box 

```
Characters: `     `

**Double (Emphasis)**
```

 Box 

```
Characters: `     `

**Heavy (Strong)**
```

 Box 

```
Characters: `     `

### Complex Borders

**With Dividers**
```

  Col 1    Col 2  

  Data     Data   

```

**Nested**
```

 Outer           
  
  Inner        
  

```

## Component State Patterns

### Buttons

**Default**
```

 Click  

```

**Hover (Highlighted)**
```

 Click  

```

**Focus (Ring)**
```

  Click   

```

**Disabled (Grayed)**
```
     
  Click  
     
```

**Pressed/Active**
```

Click 

```

### Form Inputs

**Text Input (Empty)**
```
[____________________]
```

**Text Input (Filled)**
```
[john@example.com    ]
```

**Text Input (Focus)**
```

john@example.com   

```

**Text Input (Error)**
```
[invalid-email       ]
 Please enter valid email
```

**Text Input (Success)**
```
[john@example.com    ]
```

**Text Input (Disabled)**
```
[]
```

**Password (Masked)**
```
[••••••••            ]
```

**Password (With Toggle)**
```
[••••••••            ]
```

### Checkboxes & Radios

**Checkbox (Unchecked)**
```
[] Option 1
```

**Checkbox (Checked)**
```
[] Option 1
```

**Checkbox (Indeterminate)**
```
[] Option 1
```

**Radio (Unselected)**
```
 Option A
```

**Radio (Selected)**
```
 Option A
```

### Selects & Dropdowns

**Select (Closed)**
```
[Choose option ]
```

**Select (Open)**
```
[Current option ]

 Option 1       
  Option 2     
 Option 3       

```

### Sliders

**Slider (Basic)**
```

0%              100%
```

**Slider (With Value)**
```
 45%
```

**Range Slider**
```

   20%   80%
```

## Status Indicators

### Icons

**Success**:   
**Error**:    
**Warning**:   
**Info**: ℹ  
**Loading**:          

### Progress Bars

**Loading (40%)**
```
 40%
```

**Loading (Indeterminate)**
```

```

**Steps**
```
      
```

### Badges

**Count Badge**
```
[Inbox] 3
```

**Status Badge**
```
 Online
 Offline
```

**Label Badge**
```
 New 
```

## Data Display

### Lists

**Unordered**
```
• Item 1
• Item 2
• Item 3
```

**Ordered**
```
1. First
2. Second
3. Third
```

**Nested**
```
• Parent
   Child 1
   Child 2
   Child 3
```

### Tables

**Simple**
```

 A    B    C   

 1    2    3   
 4    5    6   

```

**With Header**
```

 Name   Email  Status

 Alice  a@...       
 Bob    b@...       

```

### Cards

**Basic**
```

 Title       

 Content...  

```

**With Actions**
```

 Card Title          

 Content goes here   
                     
        [Action]   

```

**Metric Card**
```

 Revenue   

 $24,567   
 +12.5% ↗  

```

## Navigation

### Tabs

**Horizontal**
```
[Active] [Tab 2] [Tab 3]

Content for active tab
```

**Vertical**
```
  Tab 1
  Tab 2
  Tab 3
```

### Breadcrumbs

```
Home > Products > Details
```

### Pagination

```
‹ Prev  [1] 2 3 4 5  Next ›
```

### Menu

**Dropdown**
```
File 

 New      
 Open     
 Save     

 Exit     

```

**Sidebar**
```

 • Home  
 • Users 
 • Data  
 • Info  

```

## Modals & Overlays

### Modal

**Simple**
```

 Modal Title       

 Content here...   
                   
     [OK] [Cancel] 

```

**With Close**
```

 Title             

 Content...        

```

### Toast/Alert

**Success**
```

  Saved!       

```

**Error**
```

  Error: Try again 

```

**Warning**
```

  Warning message 

```

## Arrows & Indicators

### Directional
```
↑ ↓ ← →
↗ ↘ ↙ ↖
   
   
```

### Trend
```
↗ Up trend
→ Flat
↘ Down trend
```

### Expand/Collapse
```
 Expanded
 Collapsed
```

## Spacing & Alignment

### Padding Example
```

                ← 1 line padding
   Content    
                ← 1 line padding

```

### Grid Alignment
```
  ← No gap
    ← 1 char gap
      ← 2 char gap
```

## Tips for Consistent Patterns

1. **Choose one border style per component** - Don't mix light/rounded/heavy
2. **Use consistent spacing** - Multiples of 4 characters work well
3. **Align related elements** - Keep boxes at same width when stacked
4. **Test in monospace** - Always preview in monospace font
5. **Consider state transitions** - Visual changes should be clear

## Copy-Paste Ready

```
Light box: 
Rounded: 
Double: 
Heavy: 

Checkbox: [] []
Radio:  
Status:    ℹ
Arrows: ↑↓←→ ↗↘
```

Use these patterns to create beautiful, consistent uxscii components!
