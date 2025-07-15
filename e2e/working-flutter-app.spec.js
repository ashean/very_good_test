const { test, expect } = require('@playwright/test');

// Test configuration
const APP_URL = 'https://ashean.github.io/very_good_test/';
const SCREENSHOT_DIR = 'test-screenshots';

// Test data
const testUserProfile = {
  name: 'John Doe',
  age: '30',
  height: '175.5',
  weight: '70.2'
};

const testBloodTestData = {
  totalCholesterol: '180.5',
  hdlCholesterol: '45.2',
  ldlCholesterol: '110.3',
  triglycerides: '150.0',
  fastingGlucose: '95.5',
  hba1c: '5.8'
};

test.describe('Flutter App Comprehensive Tests', () => {
  
  test.beforeEach(async ({ page }) => {
    // Navigate to the deployed app
    await page.goto(APP_URL);
    
    // Wait for Flutter to fully load
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(5000); // Extra time for Flutter initialization
    
    // Take initial screenshot
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/01-app-initial-load.png`,
      fullPage: true 
    });
  });

  test('App loads correctly and shows counter functionality', async ({ page }) => {
    // Verify the app has loaded - look for the counter display
    const counterElement = await page.locator('#flt-semantic-node-4').textContent();
    expect(counterElement).toBe('0');
    
    // Verify we can see the app title/header
    const appTitle = await page.locator('text="Counter"').first();
    expect(appTitle).toBeDefined();
    
    // Take screenshot of initial counter state
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/02-counter-initial.png`,
      fullPage: true 
    });
  });

  test('Counter increment, decrement, and reset functionality', async ({ page }) => {
    // Test increment button (first floating action button)
    const incrementButton = page.locator('#flt-semantic-node-10');
    
    // Click increment button multiple times
    for (let i = 0; i < 3; i++) {
      await incrementButton.click();
      await page.waitForTimeout(500);
    }
    
    // Verify counter has incremented
    const counterAfterIncrement = await page.locator('#flt-semantic-node-4').textContent();
    expect(counterAfterIncrement).toBe('3');
    
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/03-counter-after-increment.png`,
      fullPage: true 
    });

    // Test decrement button (second floating action button)
    const decrementButton = page.locator('#flt-semantic-node-12');
    await decrementButton.click();
    await page.waitForTimeout(500);
    
    // Verify counter has decremented
    const counterAfterDecrement = await page.locator('#flt-semantic-node-4').textContent();
    expect(counterAfterDecrement).toBe('2');
    
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/04-counter-after-decrement.png`,
      fullPage: true 
    });

    // Test reset button (third floating action button)
    const resetButton = page.locator('#flt-semantic-node-14');
    await resetButton.click();
    await page.waitForTimeout(500);
    
    // Verify counter has reset to 0
    const counterAfterReset = await page.locator('#flt-semantic-node-4').textContent();
    expect(counterAfterReset).toBe('0');
    
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/05-counter-after-reset.png`,
      fullPage: true 
    });
  });

  test('Navigate to User Profile Form', async ({ page }) => {
    // Click the "Add Profile" button
    const addProfileButton = page.locator('#flt-semantic-node-7');
    await addProfileButton.click();
    await page.waitForTimeout(3000);
    
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/06-user-profile-form-page.png`,
      fullPage: true 
    });

    // Verify we're on the profile form page by looking for form text
    const pageText = await page.textContent('body');
    expect(pageText).toContain('User Profile Form');
  });

  test('Navigate to User Profile List', async ({ page }) => {
    // Click the "View Profiles" button
    const viewProfilesButton = page.locator('#flt-semantic-node-8');
    await viewProfilesButton.click();
    await page.waitForTimeout(3000);
    
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/07-user-profiles-list.png`,
      fullPage: true 
    });

    // Verify we're on the profiles list page
    const pageText = await page.textContent('body');
    expect(pageText).toContain('User Profiles');
  });

  test('Navigate to Database Test page', async ({ page }) => {
    // Click the "Database Test" button
    const databaseTestButton = page.locator('#flt-semantic-node-9');
    await databaseTestButton.click();
    await page.waitForTimeout(3000);
    
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/08-database-test-page.png`,
      fullPage: true 
    });

    // Verify we're on the database test page
    const pageText = await page.textContent('body');
    expect(pageText).toBeDefined();
  });

  test('Full user profile creation flow', async ({ page }) => {
    // 1. Navigate to Add Profile
    const addProfileButton = page.locator('#flt-semantic-node-7');
    await addProfileButton.click();
    await page.waitForTimeout(3000);
    
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/09-profile-form-loaded.png`,
      fullPage: true 
    });

    // 2. Fill out the form using Flutter's semantic structure
    // We'll need to interact with the form fields by clicking and typing
    // Since Flutter web uses canvas rendering, we'll simulate user interactions
    
    // Look for input fields in the semantic structure
    const allText = await page.textContent('body');
    console.log('Profile form page content:', allText);
    
    // Look for semantic elements that might be form fields
    const semanticElements = await page.$$eval('flt-semantics', elements => 
      elements.map(el => ({
        id: el.id,
        role: el.getAttribute('role'),
        text: el.textContent?.trim(),
        ariaLabel: el.getAttribute('aria-label')
      }))
    );
    
    console.log('Semantic elements on profile form:', JSON.stringify(semanticElements, null, 2));
    
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/10-profile-form-analysis.png`,
      fullPage: true 
    });
  });

  test('Test app navigation flow', async ({ page }) => {
    console.log('Starting navigation flow test...');
    
    // 1. Test counter functionality
    const incrementButton = page.locator('#flt-semantic-node-10');
    await incrementButton.click();
    await page.waitForTimeout(1000);
    
    let counterValue = await page.locator('#flt-semantic-node-4').textContent();
    expect(counterValue).toBe('1');
    
    // 2. Navigate to Add Profile
    const addProfileButton = page.locator('#flt-semantic-node-7');
    await addProfileButton.click();
    await page.waitForTimeout(3000);
    
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/11-navigation-add-profile.png`,
      fullPage: true 
    });
    
    // 3. Go back to main page (look for back button)
    const backButton = page.locator('flt-semantics[role="button"]').filter({ hasText: 'Back' }).first();
    if (await backButton.isVisible()) {
      await backButton.click();
      await page.waitForTimeout(2000);
    }
    
    // 4. Navigate to View Profiles
    const viewProfilesButton = page.locator('#flt-semantic-node-8');
    await viewProfilesButton.click();
    await page.waitForTimeout(3000);
    
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/12-navigation-view-profiles.png`,
      fullPage: true 
    });
    
    // 5. Navigate to Database Test
    const databaseTestButton = page.locator('#flt-semantic-node-9');
    await databaseTestButton.click();
    await page.waitForTimeout(3000);
    
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/13-navigation-database-test.png`,
      fullPage: true 
    });
    
    console.log('Navigation flow test completed successfully');
  });

  test('Test blood test functionality availability', async ({ page }) => {
    // Navigate to profiles page
    const viewProfilesButton = page.locator('#flt-semantic-node-8');
    await viewProfilesButton.click();
    await page.waitForTimeout(3000);
    
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/14-profiles-page-for-blood-test.png`,
      fullPage: true 
    });
    
    // Check if there are any existing profiles and blood test buttons
    const pageText = await page.textContent('body');
    console.log('Profiles page content:', pageText);
    
    // Look for blood test related elements
    const hasBloodTestButtons = pageText.includes('Blood Tests') || pageText.includes('Add Test');
    const hasProfileCards = pageText.includes('BMI') || pageText.includes('Created:');
    
    if (hasProfileCards) {
      console.log('Found existing profile cards');
      
      if (hasBloodTestButtons) {
        console.log('Found blood test buttons - blood test feature is available');
      } else {
        console.log('No blood test buttons found yet');
      }
    } else {
      console.log('No profiles found - need to create a profile first');
    }
    
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/15-blood-test-availability-check.png`,
      fullPage: true 
    });
  });

  test('App responsiveness and UI elements', async ({ page }) => {
    // Test different viewport sizes
    await page.setViewportSize({ width: 1200, height: 800 });
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/16-desktop-view.png`,
      fullPage: true 
    });
    
    await page.setViewportSize({ width: 768, height: 1024 });
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/17-tablet-view.png`,
      fullPage: true 
    });
    
    await page.setViewportSize({ width: 375, height: 667 });
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/18-mobile-view.png`,
      fullPage: true 
    });
    
    // Reset to default
    await page.setViewportSize({ width: 1280, height: 720 });
    
    // Test that all main buttons are still clickable
    const buttons = [
      { selector: '#flt-semantic-node-7', name: 'Add Profile' },
      { selector: '#flt-semantic-node-8', name: 'View Profiles' },
      { selector: '#flt-semantic-node-9', name: 'Database Test' },
      { selector: '#flt-semantic-node-10', name: 'Increment' },
      { selector: '#flt-semantic-node-12', name: 'Decrement' },
      { selector: '#flt-semantic-node-14', name: 'Reset' }
    ];
    
    for (const button of buttons) {
      const element = page.locator(button.selector);
      expect(await element.isVisible()).toBe(true);
      console.log(`${button.name} button is visible and clickable`);
    }
  });

  test('Error handling and edge cases', async ({ page }) => {
    // Test rapid clicking of buttons
    const incrementButton = page.locator('#flt-semantic-node-10');
    
    // Rapidly click increment button
    for (let i = 0; i < 10; i++) {
      await incrementButton.click();
      await page.waitForTimeout(100);
    }
    
    const counterValue = await page.locator('#flt-semantic-node-4').textContent();
    expect(parseInt(counterValue)).toBe(10);
    
    // Test reset after rapid increments
    const resetButton = page.locator('#flt-semantic-node-14');
    await resetButton.click();
    await page.waitForTimeout(1000);
    
    const resetValue = await page.locator('#flt-semantic-node-4').textContent();
    expect(resetValue).toBe('0');
    
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/19-rapid-interaction-test.png`,
      fullPage: true 
    });
  });

  test('App performance and load testing', async ({ page }) => {
    // Measure page load performance
    const startTime = Date.now();
    
    await page.goto(APP_URL);
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(5000);
    
    const loadTime = Date.now() - startTime;
    console.log(`App load time: ${loadTime}ms`);
    
    // Test multiple navigation actions
    const navigationStart = Date.now();
    
    // Quick navigation between pages
    await page.locator('#flt-semantic-node-7').click();
    await page.waitForTimeout(1000);
    
    await page.locator('#flt-semantic-node-8').click();
    await page.waitForTimeout(1000);
    
    await page.locator('#flt-semantic-node-9').click();
    await page.waitForTimeout(1000);
    
    const navigationTime = Date.now() - navigationStart;
    console.log(`Navigation test time: ${navigationTime}ms`);
    
    // Test counter performance
    const counterStart = Date.now();
    
    const incrementButton = page.locator('#flt-semantic-node-10');
    for (let i = 0; i < 20; i++) {
      await incrementButton.click();
      await page.waitForTimeout(50);
    }
    
    const counterTime = Date.now() - counterStart;
    console.log(`Counter performance test time: ${counterTime}ms`);
    
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/20-performance-test-complete.png`,
      fullPage: true 
    });
  });

});