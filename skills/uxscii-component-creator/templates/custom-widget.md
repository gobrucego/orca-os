# Custom Widget Component

A specialized widget component that extends the basic card with custom properties for dashboard and data display.

## Dashboard Widget

```

 {{data.icon}} {{data.title}}    

                                
      {{data.value}}            
                                
 {{data.trend}}                 

```

## Compact Widget

```

 {{data.icon}} {{data.title}} 
 {{data.value}} {{data.trend}} 

```

## Loading State

```

  Loading...                   

                                
    
                                
    

```

## Error State

```

  Error Loading Data           

                                
 Failed to load widget data.    
 Click to retry.                
                                

```

## Widget Types

### Analytics Widget
```

  Sales Analytics             

                                
      $45,678                   
                                
 ↗ +23% vs last month          

```

### Status Widget
```

  System Status               

                                
      All Systems               
      Operational               
                                

```

### Counter Widget
```

  Active Users                

                                
      2,347                     
                                
 +12 new this hour              

```

### Progress Widget
```

  Goal Progress               

                                
  80%       
                                
 8 of 10 completed              

```

## Interactive Elements

### Refreshable Widget
```

 {{data.icon}} {{data.title}}     ← Click to refresh

                                
      {{data.value}}            
                                
 Last updated: 2 min ago        

```

### Auto-Refresh Indicator
```

 {{data.icon}} {{data.title}}     ← Auto-refresh active

                                
      {{data.value}}            
                                
 Next refresh: 25s              

```

## Dimensions

- **Standard**: 30×8 characters
- **Compact**: 25×4 characters
- **Large**: 40×10 characters
- **Full Width**: Responsive to container

## Variables

- `widgetType` (string): Type of widget ("dashboard", "analytics", "status", "counter", "progress")
- `data` (object): Widget data with title, value, trend, and icon
  - `title` (string): Widget heading
  - `value` (string): Main display value
  - `trend` (string): Trend indicator (optional)
  - `icon` (string): Widget icon (emoji or symbol)
- `refreshable` (boolean): Whether widget can be manually refreshed
- `autoRefresh` (number): Auto-refresh interval in milliseconds (0 = disabled)
- `compact` (boolean): Use compact layout

## Accessibility

- **Role**: widget or region
- **Focusable**: Yes, if interactive
- **Keyboard Support**:
  - Enter/Space: Refresh widget (if refreshable)
  - Tab: Navigate to next widget
- **ARIA**:
  - `aria-label`: Widget title and current value
  - `aria-live`: "polite" for auto-updating widgets
  - `aria-busy`: "true" when loading

## Usage Examples

### Sales Dashboard Widget
```

  Monthly Revenue             

                                
      $127,890                  
                                
 ↗ +15.3% vs last month        

```

### Server Monitoring Widget
```

  Server Load                 

                                
      CPU: 45%                  
      RAM: 67%                  
      Disk: 23%                 

```

### Task Progress Widget
```

  Sprint Progress             

                                
  67%       
                                
 12 of 18 tasks completed       

```

## Component Behavior

### Data Loading

1. **Initial Load**: Show loading state while fetching data
2. **Error Handling**: Display error message and retry option
3. **Success**: Show formatted data with trend indicators
4. **Auto-Refresh**: Periodically update data in background

### Refresh Functionality

- **Manual Refresh**: Click refresh icon to update immediately
- **Auto-Refresh**: Configurable interval for automatic updates
- **Loading Feedback**: Visual indication during data fetch
- **Error Recovery**: Retry mechanism for failed requests

### State Management

- **Loading**: Semi-transparent with spinner
- **Error**: Red border with error message
- **Success**: Normal display with data
- **Stale**: Subtle indication when data is outdated

## Design Tokens

### Visual Elements
- `` = Widget container borders
- `` = Refresh button icon
- `` = Auto-refresh active indicator
- `` = Loading placeholder blocks
- `` = Error/warning indicator
- Emoji icons for widget types (, , , etc.)

### Status Colors
- **Success**: Green indicators for positive trends
- **Warning**: Yellow for caution states
- **Error**: Red for error states
- **Neutral**: Gray for normal/inactive states

## Related Components

- **Card**: Base component that this extends
- **Dashboard**: Container for multiple widgets
- **Chart**: Data visualization components
- **Metric**: Simple numeric display components

## Implementation Notes

This widget component extends the base card component with:

1. **Data Management**: Built-in data fetching and state management
2. **Auto-Refresh**: Configurable automatic data updates
3. **Error Handling**: Robust error states and recovery
4. **Accessibility**: Full screen reader and keyboard support
5. **Customization**: Flexible widget types and layouts
6. **Performance**: Efficient rendering and update mechanisms

## Extension Points

- **Custom Widget Types**: Add new widget variations
- **Data Sources**: Integrate with different APIs
- **Visualization**: Add charts and graphs
- **Theming**: Custom color schemes and layouts
- **Interactions**: Additional click handlers and actions