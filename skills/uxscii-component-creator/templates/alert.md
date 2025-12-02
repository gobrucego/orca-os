# Alert/Notification Component

Alert and notification messages for user feedback, system status, and important information display with various styles and interactive capabilities.

## Success Alert

```

  {{title}}                                   

                                                  
 {{message}}                                      
                                                  
                         
    Undo        View                         
                         

```

## Warning Alert

```

  Warning: Check Your Input                   

                                                  
 Some fields contain invalid data. Please         
 review and correct before proceeding.            
                                                  
                         
   Review     Continue                       
                         

```

## Error Alert

```

  Error: Failed to Save                       

                                                  
 An error occurred while saving your changes.    
 Please try again or contact support.            
                                                  
                         
  Try Again    Support                       
                         

```

## Info Alert

```

 ℹ Information                                  

                                                  
 New features are available! Check out the       
 latest updates in your dashboard.               
                                                  
                         
  Learn More   Dismiss                        
                         

```

## Compact Alert

```

  Saved successfully!                    

```

## Alert without Actions

```

  {{title}}                                   

                                                  
 {{message}}                                      
                                                  

```

## Alert without Border

```
 {{title}}                                      

{{message}}

  
   Undo        View   
  
```

## Toast Notification Style

```
    
      Changes saved!                    
    
```

## Progress Alert

```

  Uploading Files...                         

                                                  
 Please wait while we upload your files.         
                                                  
  75%                        
                                                  
                                     
   Cancel                                      
                                     

```

## Persistent Alert (No Auto-dismiss)

```

  Action Required                             

                                                  
 Your subscription expires in 3 days.            
 Please update your payment method.              
                                                  
                         
   Update     Remind Later                   
                         

```

## Alert Stack (Multiple Alerts)

```

  File uploaded successfully!                 


 ℹ New message received                        


  Storage almost full                         

```

## Loading Alert

```

  Processing Request...                       

                                                  
 Please wait while we process your request.      
 This may take a few moments.                    
                                                  

```

## Alert with Rich Content

```

  Welcome to Premium!                        

                                                  
 You've successfully upgraded to Premium plan.   
                                                  
  Unlimited storage                             
  Priority support                              
  Advanced features                             
                                                  
                         
  Get Started  Learn More                     
                         

```

## Status Message Alert

```

  System Maintenance                          

                                                  
 We're performing scheduled maintenance.         
 Expected completion: 2:00 AM EST                
                                                  
                                     
  Status Page                                  
                                     

```

## Inline Alert (Within Form)

```

 Name:    
        John Doe                               
          
                                                 
 Email:    
         invalid-email                         
           
  
   Please enter a valid email address       
  

```

## Dismissible with Timer

```

  Message sent!                              

                                                  
 Your message has been delivered successfully.   
                                                  
  Auto-dismiss in 3s          

```

## Dimensions

- **Standard Width**: 40-60 characters
- **Compact Width**: 30-45 characters
- **Toast Width**: 25-40 characters
- **Height**: 4-10 lines depending on content
- **Action Button Height**: 3 characters

## Variables

- `title` (string): Alert heading text (max 50 characters)
- `message` (string, required): Main alert content (max 200 characters)
- `variant` (string): Alert type ("success", "warning", "error", "info", "default")
- `icon` (string): Icon character for alert type (max 5 characters)
- `dismissible` (boolean): Show close button (default: true)
- `persistent` (boolean): Prevent auto-dismiss (default: false)
- `actions` (array): Action buttons with text and callbacks (max 3)
- `compact` (boolean): Use minimal spacing (default: false)
- `bordered` (boolean): Show container border (default: true)

## Accessibility

- **Role**: alert (for important messages) or status (for less critical)
- **Focusable**: Yes, for dismissible alerts
- **Keyboard Support**:
  - Escape: Dismiss alert (if dismissible)
  - Tab: Navigate through action buttons
  - Enter: Activate focused button
- **ARIA**:
  - `aria-live`: "assertive" for alerts, "polite" for status
  - `aria-label`: Descriptive label including alert type
  - `aria-describedby`: Link to message content

## Usage Examples

### Form Validation
```

  Validation Error                            

                                                  
 Please correct the following errors:             
 • Email address is required                     
 • Password must be at least 8 characters        
                                                  

```

### Save Confirmation
```

  Draft Saved                                 

                                                  
 Your draft has been automatically saved.        
                                                  
                                     
  Continue                                     
                                     

```

### System Status
```

  Maintenance Mode                           

                                                  
 The system is currently undergoing maintenance. 
 Please try again in a few minutes.              
                                                  

```

### Achievement Notification
```

  Achievement Unlocked!                      

                                                  
 You've completed 100 tasks! Keep up the         
 great work.                                     
                                                  
                         
    Share     View Badge                     
                         

```

## Component Behavior

### Auto-Dismiss Functionality

1. **Timer-based**: Automatically dismiss after specified duration
2. **Pause on Hover**: Stop timer when user hovers over alert
3. **Resume on Leave**: Continue timer when mouse leaves
4. **Persistent Override**: Some alerts stay until manually dismissed

### Animation States

- **Enter**: Slide in from edge with fade
- **Exit**: Slide out to edge with fade
- **Hover**: Subtle highlight or shadow
- **Progress**: Animated progress bars for loading states

### Stacking Behavior

- **Multiple Alerts**: Stack vertically with spacing
- **Max Count**: Limit visible alerts, queue excess
- **Position Management**: Handle overlapping and positioning
- **Cleanup**: Remove dismissed alerts from DOM

## Design Tokens

### Visual Elements
- `` = Alert container borders
- `` = Success icon
- `` = Warning icon  
- `` = Error icon
- `ℹ` = Info icon
- `` = Loading/processing icons
- `` = Dismiss button
- `` = Disabled/loading state

### Color Mapping (ASCII patterns)
- **Success**: `` = Green background
- **Warning**: `` = Yellow/orange background
- **Error**: `` = Red background
- **Info**: `` = Blue background
- **Default**: `` = Gray background

## Related Components

- **Toast**: Temporary notification messages
- **Banner**: Persistent page-level announcements
- **Modal**: Blocking dialog for critical alerts
- **Tooltip**: Contextual help and information

## Implementation Notes

This ASCII representation demonstrates alert patterns and states. When implementing:

1. **Animation System**: Smooth enter/exit transitions
2. **Position Management**: Handle multiple alerts and positioning
3. **Timer Management**: Accurate auto-dismiss with pause/resume
4. **Accessibility**: Proper announcement to screen readers
5. **Performance**: Efficient rendering and cleanup
6. **Mobile Adaptation**: Responsive sizing and positioning

## Variants

- **Toast Notification**: Temporary messages that auto-dismiss
- **Banner Alert**: Full-width page announcements
- **Inline Alert**: Contextual messages within content
- **Modal Alert**: Blocking alerts requiring user action
- **Status Alert**: System status and maintenance messages
- **Progress Alert**: Loading and operation progress indicators