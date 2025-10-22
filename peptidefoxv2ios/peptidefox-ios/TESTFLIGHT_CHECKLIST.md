# TestFlight Submission Checklist

## Pre-Submission Testing

### Code Quality
- [ ] All Swift files compile without errors
- [ ] All Swift files compile without warnings
- [ ] No force unwraps (!) in production code
- [ ] No print() statements in production code
- [ ] All TODO comments resolved or documented
- [ ] Code follows Swift API Design Guidelines
- [ ] No unused imports or variables

### Functional Testing
- [ ] Reconstitution calculator produces accurate results
- [ ] Supply planner calculations verified
- [ ] GLP-1 dose escalation schedules correct
- [ ] Protocol builder saves and loads correctly
- [ ] All navigation flows work correctly
- [ ] All buttons and UI elements responsive
- [ ] No crashes during normal usage
- [ ] No crashes during edge case testing

### UI/UX Testing
- [ ] Dark mode tested on all screens
- [ ] Light mode tested on all screens
- [ ] Auto light/dark switching works
- [ ] All fonts render correctly
- [ ] All colors match design system
- [ ] Layouts correct on iPhone SE (small screen)
- [ ] Layouts correct on iPhone 15 Pro Max (large screen)
- [ ] Layouts correct on iPad Pro 12.9"
- [ ] Layouts correct on iPad Mini
- [ ] Rotation handled correctly (if supported)
- [ ] Safe areas respected on all devices
- [ ] No clipped text or UI elements
- [ ] Scrolling smooth on all views

### Accessibility Testing
- [ ] VoiceOver works on all screens
- [ ] All buttons have accessibility labels
- [ ] All images have accessibility descriptions
- [ ] Contrast ratios meet WCAG AA standards
- [ ] Dynamic Type scaling works correctly
- [ ] Supports iOS Reduce Motion setting
- [ ] Supports iOS Increase Contrast setting
- [ ] Keyboard navigation works (iPad)

### Data Persistence
- [ ] User preferences saved correctly
- [ ] Protocols persist across app restarts
- [ ] Recent calculations saved
- [ ] App state restored after termination
- [ ] No data loss on iOS updates
- [ ] Migration from old data versions (if applicable)

### Performance Testing
- [ ] App launches in < 2 seconds
- [ ] All views load instantly
- [ ] Calculations complete in < 100ms
- [ ] No memory leaks (Instruments test)
- [ ] No excessive memory usage
- [ ] Smooth 60fps scrolling
- [ ] Battery usage acceptable
- [ ] App size < 50MB

### Privacy & Security
- [ ] Privacy manifest (PrivacyInfo.xcprivacy) included
- [ ] All privacy descriptions in Info.plist
- [ ] No data sent to external servers
- [ ] No analytics or tracking
- [ ] No third-party SDKs with tracking
- [ ] Sensitive data encrypted in UserDefaults
- [ ] No hardcoded API keys or secrets

---

## Build Configuration

### Xcode Project Settings
- [ ] Bundle Identifier: `com.peptidefox.ios` (or your registered ID)
- [ ] Display Name: "PeptideFox"
- [ ] Marketing Version: 1.0.0
- [ ] Build Number: 1 (increment for each upload)
- [ ] Deployment Target: iOS 17.0
- [ ] Swift Language Version: 6.0
- [ ] Optimization Level: -O (Release)
- [ ] Enable Bitcode: No (deprecated)
- [ ] Strip Debug Symbols: Yes (Release)

### Code Signing
- [ ] Development Team set
- [ ] Automatic signing enabled OR
- [ ] Manual provisioning profiles configured
- [ ] Distribution certificate valid
- [ ] App Identifier registered on Apple Developer
- [ ] Bundle ID matches App Store Connect

### Capabilities
- [ ] Required capabilities enabled in Xcode
- [ ] Corresponding entitlements added
- [ ] iCloud disabled (unless needed)
- [ ] Push Notifications disabled (unless needed)
- [ ] Background Modes disabled (unless needed)

### App Icons
- [ ] App Icon 1024x1024 added to Assets.xcassets
- [ ] Icon has no alpha channel
- [ ] Icon has no rounded corners (iOS adds them)
- [ ] Icon looks good at all sizes
- [ ] Icon tested on actual device home screen
- [ ] Icon follows Apple Human Interface Guidelines

### Launch Screen
- [ ] Launch screen configured
- [ ] Launch screen uses Asset Catalog images only
- [ ] Launch screen works in light mode
- [ ] Launch screen works in dark mode
- [ ] No text on launch screen (best practice)

---

## App Store Connect Preparation

### App Information
- [ ] App name "PeptideFox" available
- [ ] Primary language: English (U.S.)
- [ ] Bundle ID registered
- [ ] SKU created (unique identifier)
- [ ] Category: Health & Fitness

### Pricing & Availability
- [ ] Price tier selected: Free (or paid)
- [ ] Availability: All countries OR selected countries
- [ ] Release date: Manual release recommended

### App Privacy
- [ ] Privacy policy URL: https://peptidefox.com/privacy
- [ ] Data collection questionnaire completed
- [ ] Privacy Nutrition Label accurate
- [ ] Tracking set to "No" (no tracking)

### Age Rating
- [ ] Age rating questionnaire completed
- [ ] Age rating: 17+ (Medical/Treatment Information)

---

## Screenshots & Media

### iPhone 6.7" Screenshots (1290 x 2796 pixels)
- [ ] Screenshot 1: Home/Calculator (required)
- [ ] Screenshot 2: Protocol Builder (required)
- [ ] Screenshot 3: Supply Planner (required)
- [ ] Screenshot 4: GLP-1 Journey (optional)
- [ ] Screenshot 5: Peptide Library (optional)
- [ ] Screenshots use actual app UI (no mockups)
- [ ] Screenshots show real data (no Lorem Ipsum)
- [ ] Screenshots comply with App Store guidelines

### iPad Pro 12.9" Screenshots (2048 x 2732 pixels)
- [ ] Screenshot 1: Home/Calculator (required)
- [ ] Screenshot 2: Protocol Builder (required)
- [ ] Screenshot 3: Supply Planner (required)
- [ ] iPad screenshots show optimized layout

### App Preview Video (Optional)
- [ ] iPhone preview video created (15-30 seconds)
- [ ] iPad preview video created (15-30 seconds)
- [ ] Videos show app functionality
- [ ] Videos comply with Apple guidelines

---

## Build Submission

### Archive Creation
- [ ] Clean build folder (Product → Clean Build Folder)
- [ ] Select "Any iOS Device (arm64)" as destination
- [ ] Product → Archive
- [ ] Archive created successfully
- [ ] Archive validated in Organizer

### Validation
- [ ] Validate app in Xcode Organizer
- [ ] No validation errors
- [ ] No validation warnings (or documented)
- [ ] App Store distribution certificate valid
- [ ] Provisioning profile valid

### Upload to App Store Connect
- [ ] Distribute App → App Store Connect
- [ ] Build uploaded successfully
- [ ] Build processing complete (can take 30-60 minutes)
- [ ] Build appears in App Store Connect
- [ ] No email from Apple about issues

---

## TestFlight Configuration

### TestFlight Information
- [ ] What to Test description written:
  ```
  Welcome to PeptideFox 1.0!

  FOCUS AREAS FOR TESTING:
  • Calculation accuracy (reconstitution, supply planning)
  • UI/UX usability and intuitiveness
  • Dark mode appearance
  • Performance on your device
  • Any crashes or bugs

  KNOWN ISSUES:
  • None currently

  HOW TO TEST:
  1. Start with GLP-1 Journey to see dose escalation
  2. Try the reconstitution calculator with different peptides
  3. Create a multi-peptide protocol in Protocol Builder
  4. Test dark mode (Settings → Appearance)

  Please report any issues or feedback to: support@peptidefox.com
  ```

### Export Compliance
- [ ] Export compliance configured
- [ ] Uses encryption: Yes (standard iOS only)
- [ ] No additional documentation needed

### Internal Testing
- [ ] Build available for internal testing
- [ ] Internal testers invited (up to 100)
- [ ] Internal testing group created
- [ ] Testers receive TestFlight invite
- [ ] Internal testing period: 1 week
- [ ] Critical bugs fixed before external beta

### External Testing
- [ ] External testing group created
- [ ] External testers invited (up to 10,000)
- [ ] Beta app review submitted (required for external testing)
- [ ] Beta app review approved
- [ ] External beta period: 2-4 weeks

---

## Beta Testing Feedback

### Feedback Collection
- [ ] Feedback email monitored: support@peptidefox.com
- [ ] TestFlight feedback reviewed daily
- [ ] Crash reports monitored in App Store Connect
- [ ] User feedback documented
- [ ] Critical issues prioritized

### Metrics to Track
- [ ] Number of sessions per tester
- [ ] Crash rate (should be < 1%)
- [ ] Most used features
- [ ] Feature completion rates
- [ ] Average session duration
- [ ] Device and iOS version distribution

### Iteration
- [ ] Critical bugs fixed immediately
- [ ] Minor bugs tracked for v1.0.1
- [ ] Feature requests documented for v1.1
- [ ] Build 2 uploaded if needed (increment build number)
- [ ] Testers notified of updates

---

## Pre-Production Checklist

### Final Validation
- [ ] All TestFlight feedback addressed
- [ ] No critical bugs remaining
- [ ] No crashes in last 100 sessions
- [ ] App reviewed by non-technical users
- [ ] App reviewed on multiple devices
- [ ] App reviewed on iOS 17.0 minimum version

### App Store Submission Prep
- [ ] Version 1.0.0 build selected for release
- [ ] App description finalized
- [ ] Keywords optimized
- [ ] Screenshots uploaded
- [ ] App preview videos uploaded (if created)
- [ ] Support URL verified: https://peptidefox.com/support
- [ ] Privacy policy URL verified: https://peptidefox.com/privacy

### Legal & Compliance
- [ ] Medical disclaimer included in app
- [ ] Terms of service available
- [ ] Privacy policy available
- [ ] Copyright notices correct
- [ ] No trademark violations
- [ ] No copyright violations
- [ ] App Store Review Guidelines compliance verified

---

## Post-Submission

### Monitoring
- [ ] App Store Connect monitored for review status
- [ ] Average review time: 24-48 hours
- [ ] Review rejection handled if needed
- [ ] Reviewer questions answered promptly

### Crash Reporting
- [ ] Crash reports monitored daily
- [ ] Critical crashes fixed immediately
- [ ] Hotfix build prepared if needed (v1.0.1)

### User Feedback
- [ ] App Store reviews monitored
- [ ] Support email monitored
- [ ] User issues tracked
- [ ] FAQ created based on common questions

### Analytics (Privacy-Preserving)
- [ ] App Store Connect analytics reviewed weekly
- [ ] Downloads tracked
- [ ] Retention metrics analyzed
- [ ] Feature usage via App Store Connect (not third-party)

---

## Version 1.0.1 Planning

### Bug Fixes
- [ ] List all bugs found in production
- [ ] Prioritize by severity and frequency
- [ ] Create fix plan
- [ ] Estimated release date

### Minor Improvements
- [ ] UI polish based on user feedback
- [ ] Performance optimizations
- [ ] Small feature enhancements
- [ ] Updated peptide data

### Version 1.1.0 Roadmap
- [ ] Major features planned:
  - [ ] HealthKit integration
  - [ ] Protocol templates
  - [ ] PDF export improvements
  - [ ] Additional peptides
  - [ ] Widget support
- [ ] User-requested features prioritized
- [ ] Development timeline created

---

## Success Criteria

### Launch Success Metrics
- [ ] App approved on first submission (or second)
- [ ] Crash rate < 1%
- [ ] Average rating > 4.5 stars (after 50+ reviews)
- [ ] 100+ downloads in first week
- [ ] < 5 support emails per day
- [ ] Positive user feedback

### Long-Term Metrics
- [ ] 1,000+ downloads in first month
- [ ] 50% 30-day retention
- [ ] 4.7+ star rating
- [ ] Featured in "New Apps We Love" (aspirational)
- [ ] Top 100 in Health & Fitness category (aspirational)

---

## Contact & Support

**Developer Email**: support@peptidefox.com
**App Store Connect Team**: [Your Team]
**TestFlight Coordinator**: [Name]

---

## Notes

### Common Rejection Reasons (To Avoid)
1. **Incomplete Privacy Policy**: Ensure https://peptidefox.com/privacy is live
2. **Missing Privacy Manifest**: PrivacyInfo.xcprivacy must be included
3. **Medical Claims**: Ensure all disclaimers are present
4. **Crashes During Review**: Test thoroughly on all devices
5. **Broken Links**: Verify all URLs work

### Tips for Smooth Review
- Respond to reviewer questions within 24 hours
- Provide clear demo account (if needed) - not applicable for PeptideFox
- Include helpful notes for reviewers in App Review Information
- Be polite and professional in all communications
- Fix issues quickly if rejection occurs

### Build Number Tracking
- Build 1: Initial TestFlight (Internal)
- Build 2: External TestFlight (if needed)
- Build 3: App Store Submission (if needed)
- Build 4: v1.0.1 Hotfix (if needed)

---

**Last Updated**: 2025-10-20
**Next Review Date**: Before each TestFlight upload
